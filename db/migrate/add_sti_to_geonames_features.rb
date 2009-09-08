class AddStiToGeonamesFeatures < ActiveRecord::Migration
  def self.up
    add_column :geonames_features, :type, :string
  end

  def self.down
    remove_column :geonames_features, :type
  end
end
