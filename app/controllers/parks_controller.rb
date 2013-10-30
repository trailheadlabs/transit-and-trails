class ParksController < ApplicationController
  autocomplete :park, :name

  def show_by_unit_slug
    render_park(parks)
  end

  def show
    if params[:county_slug]
      @parks = Park.where(:slug=>params[:slug],:county_slug=>params[:county_slug])
    elsif params[:slug]
      @parks = Park.where(:slug=>params[:slug])
      if @parks.empty?
         @parks = Park.where(:id=>params[:slug])
      end
    elsif params[:id]
      @parks = Park.where(:id=>params[:id])
    end

    @polys = []
    @acres = 0
    @agencies = []
    @names = []
    @trips = []
    @tripnames = []
    @trailheads = []
    @trailheadnames = []
    @campgrounds = []
    @campgroundnames = []

    @agencies = @parks.collect{|p| p.agency}.uniq.compact

    @parks.each do |park|
      @acres += (park.acres || 0)      
      @polys += park.polys
      @trips += park.trips
      @campgrounds += park.campgrounds
      @trailheads += park.trailheads
    end

    @trips.uniq!
    @campgrounds.uniq!
    @park = @parks && @parks.first
    respond_to do |format|
      if @park
        format.html # show.html.erb
      else
        not_found
      end
    end
  end

  def upload_kml
    require "zip/zip"

    @parks = []    
    if file = params[:kml_file]
      if file.original_filename.end_with? ".kmz"
        Zip::ZipFile.open_buffer file.open do |zip|
          zip.each do |zip_file|            
            if zip_file.name.end_with? ".kml"
              puts "KML FILE FOUND!"              
              begin                                
                zip_file.extract
              rescue
              end
              @kml = File.open(zip_file.name,'rb').read
              puts @kml
              File.delete(zip_file.name)
            end
          end
        end
      else
        @kml = params[:kml_file].read
      end

      noko = Nokogiri::XML(@kml)
      placemarks = noko.css('Placemark')      
      placemarks.each do |p|
        bounds = []
        placemark = p
        polygons = p.css('LinearRing')        
        polygons.each do |poly|
          
          coords = poly.css('coordinates').text.split(' ')
          coords.collect! do |p|
            p.strip.split(',').slice(0,2)
          end

          bounds << "(" + coords.collect{|p| p.join(" ")}.join(", ") + ")"
        end

        name = placemark.css('name').try(:text)
        name = name.titleize
        park = Park.new
        if params[:update_existing] && params[:update_existing] == 'true'        
          park = Park.find_or_create_by_name(name)
        else
          if Park.find_by_name(name)
            name = name + " (Import #{Time.now.to_i})"
          end
          park.name = name
        end
        park.agency_id = current_user.agencies.first.id if current_user.agencies.any?
        park.bounds = "MULTIPOLYGON((" + bounds.join(',') + "))"
        park.save                
        @parks << park
      end
    end

  end

end
