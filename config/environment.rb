# Load the Rails application.
require File.expand_path('../application', __FILE__)
ENV["TMPDIR"] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TEMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"

class Dir
  def self.tmpdir
    "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/"
  end
end
# Initialize the Rails application.
Rails.application.initialize!
