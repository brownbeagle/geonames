# http://download.geonames.org/export/dump/admin1Codes.txt

class CreateGeonamesAdmin1s < ActiveRecord::Migration

  def self.up
    create_table :geonames_admin1s do |t|
      t.column :code,         :string
      t.column :name,         :string

      t.timestamps
    end

    add_index :geonames_admin1s, :code
  end

  def self.down
    # TODO Do we need to remove index if we remove the table anyway?
    remove_index :geonames_admin1s, :code

    drop_table :geonames_admin1s
  end
end
