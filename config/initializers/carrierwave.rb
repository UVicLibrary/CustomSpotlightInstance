ENV["TMPDIR"] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"
ENV['TEMP'] = "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp"

class Dir
  def self.tmpdir
    "/mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/"
  end
end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end