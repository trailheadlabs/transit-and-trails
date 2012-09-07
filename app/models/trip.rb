class Trip < ActiveRecord::Base
  belongs_to :user
  belongs_to :intensity
  belongs_to :duration
  belongs_to :ending_trailhead, :class_name => "Trailhead", :foreign_key => "ending_trailhead_id"
  belongs_to :starting_trailhead, :class_name => "Trailhead", :foreign_key => "starting_trailhead_id"
  has_and_belongs_to_many :trip_features
  has_many :stories, :as => :storytellable, :dependent => :destroy
  has_many :photos, :as => :photoable, :dependent => :destroy
  has_many :maps, :as => :mapable, :dependent => :destroy

  attr_accessible :description, :ending_trailhead_id, :name, :route, :starting_trailhead_id

  def length_miles
    if geometry.nil?
      return 0.0
    else
      factory = ::RGeo::Geographic.spherical_factory()
      obj = factory.parse_wkt(self.geometry)
      return obj.length / 1609.344
    end
  end

  def categorized_attributes
    result = {}
    Category.all.each do |category|
      features = self.trip_features.where(:category_id=>category.id).order("id")
      if features.count > 0
        result[category.name] = features
      end
    end
    result
  end

end
