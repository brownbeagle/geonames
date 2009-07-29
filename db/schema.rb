# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090729103157) do

  create_table "geonames_cities", :force => true do |t|
    t.integer  "geonameid"
    t.string   "name"
    t.string   "asciiname"
    t.string   "alternatenames"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "feature"
    t.string   "country"
    t.string   "cc2"
    t.string   "admin1"
    t.string   "admin2"
    t.string   "admin3"
    t.string   "admin4"
    t.integer  "population"
    t.integer  "elevation"
    t.integer  "gtopo30"
    t.string   "timezone"
    t.datetime "modification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geonames_countries", :force => true do |t|
    t.string   "iso"
    t.string   "iso3"
    t.string   "iso_numeric"
    t.string   "fips"
    t.string   "country"
    t.string   "capital"
    t.integer  "area"
    t.integer  "population"
    t.string   "continent"
    t.string   "tld"
    t.string   "currency_code"
    t.string   "currency_name"
    t.string   "phone"
    t.string   "postal_code_format"
    t.string   "postal_code_regex"
    t.string   "languages"
    t.string   "geonameid"
    t.string   "neighbours"
    t.string   "equivalent_fips_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
