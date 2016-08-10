module Spotlight
  module Resources
    ##
    # Creating new exhibit items from single-item entry forms
    # or batch CSV upload
    class UploadController < ApplicationController
      helper :all
      helper_method :create
      before_action :authenticate_user!

      load_and_authorize_resource :exhibit, class: Spotlight::Exhibit
      before_action :build_resource

      load_and_authorize_resource class: 'Spotlight::Resources::Upload', through_association: 'exhibit.resources', instance_name: 'resource'

      # rubocop:disable Metrics/MethodLength
      def create
       @resource.attributes = resource_params

        if @resource.save_and_index
          flash[:notice] = t('spotlight.resources.upload.success')
		  
		  if(params[:resources_upload][:url].content_type.include? "zip")
            @resource.to_sketchfab
          end

          if params['add-and-continue']
            redirect_to new_exhibit_resource_path(@resource.exhibit, anchor: :new_resources_upload)
          else
            redirect_to admin_exhibit_catalog_index_path(@resource.exhibit, sort: :timestamp)
          end
        else
          flash[:error] = t('spotlight.resources.upload.error')
          redirect_to admin_exhibit_catalog_index_path(@resource.exhibit, sort: :timestamp)
        end
      end
      # rubocop:enable Metrics/MethodLength

      private

      def build_resource
		  Rails.logger.info("\n AT:"+Time.now.strftime("%m%d %H:%M:%S:%L")+"\n****************************\nIn upload_controller \n\nPARAMS: #{params.inspect}")
      if (params[:resources_upload][:url].content_type.include? "audio") ||
		 (params[:resources_upload][:url].content_type.include? "video") ||
         (params[:resources_upload][:url].content_type.include? "zip")
			  @resource ||= Spotlight::Resources::Videoupload.new exhibit: current_exhibit
		  else
			  @resource ||= Spotlight::Resources::Upload.new exhibit: current_exhibit
		  end
      end

      def resource_params
        params.require(:resources_upload).permit(:url, data: data_param_keys)
      end

      def data_param_keys
        Spotlight::Resources::Upload.fields(current_exhibit).map(&:field_name) + current_exhibit.custom_fields.map(&:field)+[:spotlight_upload_annotation_count_is, :items]
      end
    end
  end
end
