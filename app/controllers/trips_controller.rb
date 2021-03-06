class TripsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index,:show,:info_window,:near_coordinates]
  check_authorization :only => [:new,:edit]
  load_and_authorize_resource :only => [:new,:edit]

  def import_gpx
    @trip = Trip.new

    if params[:gpx_file]
      @points = []
      with_z = false
      with_m = false
      params[:gpx_file]
      data = params[:gpx_file].read
      
      file_mode = data =~ /trkpt/ ? "//trkpt" : (data =~ /wpt/ ? "//wpt" : "//rtept")
      Nokogiri.HTML(data).search(file_mode).each do |tp|
        z = z.inner_text.to_f if with_z && z = tp.at("ele")
        m = m.inner_text if with_m && m = tp.at("time")
        @points << [tp['lat'].to_f,tp["lon"].to_f]
      end      
      @trip.route = @points
    end

    @trip.approved = true
    @trip.intensity = Intensity.first
    @trip.duration = Duration.first
    @start_id = params[:start_id]
    @center_latitude = params[:center_latitude]
    @center_longitude = params[:center_longitude]

    render "new"
  end

  def import_kml
    require "zip/zip"
    @trip = Trip.new

    if file = params[:kml_file]
      @points = []
      @kml = nil
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
      placemark = noko.css('LineString').each do |line|        
        coords = line.css('coordinates').text.split(' ')
        coords.collect! do |p|
          p.strip.split(',').slice(0,2).collect{|c| c.to_f}.reverse
        end
        @points.concat(coords)
      end  
      @points.sort!{|p| p[0]}
      @trip.route = @points
    end

    @trip.approved = true
    # @trip.name = placemark.css('name').text
    # @trip.description = placemark.css('description').text
    @trip.user_ud = current_user.id
    @trip.intensity = Intensity.first
    @trip.duration = Duration.first
    @start_id = params[:start_id]
    @center_latitude = params[:center_latitude]
    @center_longitude = params[:center_longitude]

    render "new"
  end

  # GET /trips
  # GET /trips.json
  def index
    redirect_to find_trips_path
  end

  def approve
    @trip = Trip.find(params[:id])
    @trip.update_attributes(approved:true)
  end

  def unapprove
    @trip = Trip.find(params[:id])
    @trip.update_attributes(approved:false)
  end

  # GET /trips/near_coordinates
  # GET /trips/near_coordinates.json
  def near_coordinates
    latitude = params[:latitude] || 37.7749295
    longitude = params[:longitude] || -122.4194155
    distance = params[:distance] || 10
    limit = 1000 || params[:limit]
    offset = 0 || params[:offset]
    approved = true || params[:approved]
    @trips = Trip.where(:approved => approved).near([latitude,longitude],distance).limit(limit).offset(offset)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    if request.referer =~ /\/embed\/parks/ && request.format == 'html'
      redirect_to "/embed" + request.path
      return
    end

    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        @trip['start_lat'] = @trip.starting_trailhead.latitude
        @trip['start_lng'] = @trip.starting_trailhead.longitude
        @trip['end_lat'] = @trip.ending_trailhead.latitude
        @trip['end_lng'] = @trip.ending_trailhead.longitude
       render json: @trip
      end
    end
  end

  def info_window
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new

    @trip.approved = true
    @trip.intensity = Intensity.first
    @trip.duration = Duration.first
    @start_id = params[:start_id]
    @center_latitude = params[:center_latitude]
    @center_longitude = params[:center_longitude]

  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])
    @trip.user = current_user

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to find_trips_url }
      format.json { head :no_content }
    end
  end
end
