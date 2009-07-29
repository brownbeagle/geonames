require 'net/http'

namespace :geonames do
  namespace :import do
    desc 'Import all geonames data. Should be performed on a clean install.'
    task :all => [:countries, :cities]

    desc 'Import all cities, regardless of population. Download requires about 5M.'
    task :cities => [:cities15000, :cities5000, :cities1000]
    
    desc 'Import feature data. Beware: 170M+ download required.'
    task :features => :environment do
      zip_file = "#{RAILS_ROOT}/db/geonames/allCountries.zip"
      txt_file = "#{zip_file.split('.').first}.txt"
      # Download and decompress the files if not already downloaded.
      unless File::exist?(txt_file)
        download("http://download.geonames.org/export/dump/allCountries.zip", zip_file)
        # OSX specific unzip command.
        `unzip -o -d #{File.dirname(zip_file)} #{zip_file}`
        File.unlink(zip_file)
      end
      # Import into the database.
      File.open(txt_file) {|f| insert_features(f)}
    end

    # geonames:import:citiesNNN where NNN is population size.
    %w[15000 5000 1000].each do |population|
      desc "Import cities with population greater than #{population}"
      task "cities#{population}".to_sym => :environment do
        zip_file = "#{RAILS_ROOT}/db/geonames/cities#{population}.zip"
        txt_file = "#{zip_file.split('.').first}.txt"
        # Download and decompress the files if not already downloaded.
        unless File::exist?(txt_file)
          download("http://download.geonames.org/export/dump/cities#{population}.zip", zip_file)
          # OSX specific unzip command.
          `unzip -o -d #{File.dirname(zip_file)} #{zip_file}`
          File.unlink(zip_file)
        end
        # Import into the database.
        File.open(txt_file) {|f| insert_features(f)}
      end
    end

    desc 'Import country information'
    task :countries => :environment do
      countries = fetch("http://download.geonames.org/export/dump/countryInfo.txt")
      col_names = [
        :iso,
        :iso3,
        :iso_numeric,
        :fips,
        :country,
        :capital,
        :area,
        :population,
        :continent,
        :tld,
        :currency_code,
        :currency_name,
        :phone,
        :postal_code_format,
        :postal_code_regex,
        :languages,
        :geonameid,
        :neighbours,
        :equivalent_fips_code
      ]
      countries.each_line do |line|
        attributes = {}
        line.strip.split("\t").each_with_index do |col_value, i|
          attributes[col_names[i]] = col_value
        end
        GeonamesCountry.create(attributes)
      end
    end
    
    desc 'Import admin1 codes'
    task :admin1 => :environment do
      txt_file = "#{RAILS_ROOT}/db/geonames/admin1Codes.txt"
      unless File::exist?(txt_file)
        download('http://download.geonames.org/export/dump/admin1Codes.txt', txt_file)
      end
      File.open(txt_file) do |file|
        col_names = [:code, :name]
        file.each_line do |line|
          attributes = {}
          line.strip.split("\t").each_with_index do |col_value, i|
            col_value.gsub!('(general)', '')
            attributes[col_names[i]] = col_value.strip
          end
          GeonamesAdmin1.create(attributes)
        end
      end
    end


    private

    def download(url, output)
      File.open(output, "wb") do |file|
        body = fetch(url)
        puts "Writing #{url} to #{output}"
        file.write(body)
      end
    end
    
    def fetch(url)
      puts "Fetching #{url}"
      url = URI.parse(url)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
      return res.body
    end
    
    def insert_features(file_fd)
      col_names = [
        :geonameid,
        :name,
        :asciiname,
        :alternatenames,
        :latitude,
        :longitude,
        :feature,
        :feature,
        :country,
        :cc2,
        :admin1,
        :admin2,
        :admin3,
        :admin4,
        :population,
        :elevation,
        :gtopo30,
        :timezone,
        :modification
      ]
      file_fd.each_line do |line|
        attributes = {}
        line.strip.split("\t").each_with_index do |col_value, i|
          attributes[col_names[i]] = col_value
        end
        GeonamesFeature.create(attributes)
      end
    end

  end
end