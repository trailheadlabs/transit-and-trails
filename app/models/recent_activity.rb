class RecentActivity < ActiveRecord::Base
  attr_accessible :description, :favorites_link1, :favorites_link1_text, :favorites_link2, :favorites_link2_text, :favorites_link3, :favorites_link3_text, :favorites_link4, :favorites_link4_text, :favorites_link5, :favorites_link5_text, :favorites_type1, :favorites_type2, :favorites_type3, :favorites_type4, :favorites_type5, :highlighted, :name, :recent_news_text
end
