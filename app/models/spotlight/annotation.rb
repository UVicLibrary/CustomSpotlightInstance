module Spotlight
  ##
  # Resource Annotation
  class Annotation < ActiveRecord::Base
  	  belongs_to :resource
  	  
  end
end