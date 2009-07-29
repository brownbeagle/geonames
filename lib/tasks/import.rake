require 'net/http'

namespace :geonames do
  namespace :import do
  
    desc 'Import countries'
    task :cities => :environment do
    end
    
    desc 'Import all cities'
    task :cities => [:cities15000, :cities5000, :cities1000]

    # geonames:import:citiesNNN where NNN is population size.
    %w[15000 5000 1000].each do |population|
      desc "Import cities with population greater than #{population}"
      task "cities#{population}".to_sym => :environment do
        # Download and decompress the files.
        zip_file = "#{RAILS_ROOT}/db/geonames/cities#{population}.zip"
        download("http://download.geonames.org/export/dump/cities#{population}.zip", zip_file)
        # OSX specific unzip command.
        `unzip -o -d #{File.dirname(zip_file)} #{zip_file}`
        File.unlink(zip_file)
        # Import into the database.
        txt_file = "#{zip_file.split('.').first}.txt"
        File.open(txt_file) do |f|
          f.each_line do |line|
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
            attributes = {}
            line.strip.split("\t").each_with_index do |col_value, i|
              attributes[col_names[i]] = col_value
            end
            GeonamesCity.create!(attributes)
          end
        end
      end
    end


    private

    def download(url, output)
      puts "Downloading #{url} to #{output}"
      url = URI.parse(url)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
      File.open(output, "wb") {|file| file.write(res.body)}
    end
  end
end
