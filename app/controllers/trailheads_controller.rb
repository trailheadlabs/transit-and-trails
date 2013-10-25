class TrailheadsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show,:near_address,
    :near_coordinates,:within_bounds,:info_window, :transit_routers]

  check_authorization :only => [:new,:edit,:create,:update,:destroy]
  load_and_authorize_resource :only => [:new,:edit,:create,:update,:destroy]

  def approve
    @trailhead = Trailhead.find(params[:id])
    @trailhead.update_attributes(approved:true)
  end

  def unapprove
    @trailhead = Trailhead.find(params[:id])
    @trailhead.update_attributes(approved:false)
  end

  def transit_routers
    @transit_routers = Trailhead.find(params[:id]).transit_routers
    render :json => @transit_routers
  end

  def upload_kml
    require "zip/zip"

    @trailheads = []    
    if file = params[:kml_file]
      if file.original_filename.end_with? ".kmz"
        Zip::ZipFile.open_buffer file.open do |zip|
          zip.each do |zip_file|            
            if zip_file.name.end_with? ".kml"
              puts "KML FILE FOUND!"
              dir = file.original_filename
              begin                                
                zip_file.extract('tmp/'+zip_file.name)
              rescue
              end
              @kml = File.open('tmp/'+zip_file.name,'rb').read
              puts @kml
              File.delete('tmp/'+zip_file.name)
            end
          end
        end
      else
        @kml = params[:kml_file].read
      end

      noko = Nokogiri::XML(@kml)
      placemarks = noko.css('Placemark > Point')
      placemarks.each do |p|
        placemark = p.parent
        point = placemark.css('Point').css('coordinates').text.strip.split(',').slice(0,2).collect{|c| c.to_f}.reverse
        name = placemark.css('name').try(:text)
        trailhead = Trailhead.new
        if params[:update_existing]          
          trailhead = Trailhead.find_or_create_by_name(name)
        else
          if Trailhead.find_by_name(name)
            name = name + " (Import #{Time.now.to_i})"
          end
          trailhead.approved = true
          trailhead.name = name
        end
        trailhead.latitude = point[0]
        trailhead.longitude = point[1]
        trailhead.save                
        @trailheads << trailhead
      end
    end

  end

  # GET /trailheads/near_address
  # GET /trailheads/near_address.json
  def near_address
    address = params[:address] || "San Francisco, CA"
    distance = params[:distance] || 10
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where(:approved => approved).near(address,distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads/near_coordinates
  # GET /trailheads/near_coordinates.json
  def near_coordinates
    latitude = params[:latitude] || 37.7749295
    longitude = params[:longitude] || -122.4194155
    distance = params[:distance] || 10
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where(:approved => approved).near([latitude,longitude],distance,:select=>'id,latitude,longitude,name').limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads/within_bounds
  # GET /trailheads/within_bounds.json
  def within_bounds
    min_latitude = Float(params[:sw_latitude])
    max_latitude = Float(params[:ne_latitude])
    min_longitude = Float(params[:sw_longitude])
    max_longitude = Float(params[:ne_longitude])
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trailheads = Trailhead.where("latitude > :min_latitude AND latitude < :max_latitude AND longitude > :min_longitude AND longitude < :max_longitude",
      :min_latitude => min_latitude, :min_longitude => min_longitude, :max_latitude => max_latitude, :max_longitude => max_longitude).limit(limit).offset(offset).approved
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trailheads }
    end
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    redirect_to find_trailheads_path
    # if(params[:park_id])
    #   @trailheads = Park.find(params[:park_id]).trailheads
    # else
    #   @trailheads = Trailhead.all
    # end
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @trailheads }
    # end
  end

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
    if request.referer =~ /\/embed\/parks/ && request.format == 'html'
      redirect_to "/embed" + request.path
      return
    end
    
    @trailhead = Trailhead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trailhead }
    end
  end

  def info_window
    @point = Trailhead.find(params[:id])
    @trips = Trip.where(:starting_trailhead_id=>@point.id)
    @feature_names = @point.trailhead_features.collect{|f| f.name}.join(",  ")
    respond_to do |format|
      format.html { render :layout => false} # show.html.erb
    end
  end

  def trip_editor_info_window
    @point = Trailhead.find(params[:id])
    @trips = Trip.where(:starting_trailhead_id=>@point.id)
    @feature_names = @point.trailhead_features.collect{|f| f.name}.join(",  ")
    respond_to do |format|
      format.html { render :layout => false} # show.html.erb
    end
  end

  # GET /trailheads/new
  # GET /trailheads/new.json
  def new
    @trailhead = Trailhead.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trailhead }
    end
  end

  # GET /trailheads/1/edit
  def edit
    @trailhead = Trailhead.find(params[:id])
  end

  # POST /trailheads
  # POST /trailheads.json
  def create
    @trailhead = Trailhead.new(params[:trailhead])
    @trailhead.user = current_user

    respond_to do |format|
      if @trailhead.save
        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully created.' }
        format.json { render json: @trailhead, status: :created, location: @trailhead }
      else
        format.html { render action: "new" }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trailheads/1
  # PUT /trailheads/1.json
  def update
    @trailhead = Trailhead.find(params[:id])

    respond_to do |format|
      if @trailhead.update_attributes(params[:trailhead])
        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trailheads/1
  # DELETE /trailheads/1.json
  def destroy
    @trailhead = Trailhead.find(params[:id])
    @trailhead.destroy

    respond_to do |format|
      flash[:notice] = "Trailhead deleted."
      format.html { redirect_to find_trailheads_path }
      format.json { head :no_content }
    end
  end
end
