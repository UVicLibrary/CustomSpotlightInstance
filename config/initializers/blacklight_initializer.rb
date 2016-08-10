# A secret token used to encrypt user_id's in the Bookmarks#export callback URL
# functionality, for example in Refworks export of Bookmarks. In Rails 4, Blacklight
# will use the application's secret key base instead.
#

# Blacklight.secret_key = 'be7df9886cf06300fee372fa744eb5b330608abce59db73ee2d220225a47ca0fa1afdc3f2ab579708d92ba5378c5efe0dc6898cdf8d5ba1343d64225ebe3125d'

ENV["TMPDIR"] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TEMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"

class Dir
  def self.tmpdir
    "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/"
  end
end