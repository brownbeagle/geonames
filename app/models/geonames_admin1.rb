class GeonamesAdmin1 < ActiveRecord::Base
  validates_uniqueness_of :code
end