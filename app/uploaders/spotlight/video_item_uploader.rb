# encoding: utf-8
module Spotlight
  ##
  # Uploaded resource image attachments, downloaded locally for cropping and
  # representation. See {Spotlight::Resource::Upload}
  class VideoItemUploader < CarrierWave::Uploader::Base
    Rails.logger.warn("In VideoItemUploader 7 AT:"+Time.now.strftime("%m%d %H:%M:%S:%L")+"")
    storage Spotlight::Engine.config.uploader_storage


    def extension_white_list
	  Rails.logger.warn("In ItemUploader.extension_white_list 14 AT:"+Time.now.strftime("%m%d %H:%M:%S:%L")+"")
      Spotlight::Engine.config.allowed_upload_extensions
    end

    def store_dir
	 # Rails.logger.warn("In ItemUploader 7 AT:"+Time.now.strftime("%m%d %H:%M:%S:%L")+"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}")
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
