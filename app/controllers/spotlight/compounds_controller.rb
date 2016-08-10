module Spotlight
	class CompoundsController < Spotlight::ApplicationController
		load_and_authorize_resource :exhibit, class: Spotlight::Exhibit, prepend: true
		before_action :authenticate_user!, only: [:new, :create, :update, :edit]
		before_action :check_authorization, only: [:new, :create, :update, :edit]
		require 'fileutils'
		
		def index
			@exhibit = Spotlight::Exhibit.find params[:exhibit_id]
		end
		
		def new
			@exhibit = Spotlight::Exhibit.find params[:exhibit_id]
		end
		
		def create
			begin
				@exhibit = Spotlight::Exhibit.find(params[:exhibit_id])
				@resource = Spotlight::Resource.new(exhibit: @exhibit)
				@resource.data = params[:data]
				@thumb_resource = Spotlight::Resource.find(params[:data][:items].first.split("-")[1])
				@resource.type = (@thumb_resource.type.include?("Video") ? "Spotlight::Resources::Videoupload" : "Spotlight::Resources::Upload")
				params[:resources_upload] = {}
				params[:resources_upload][:url] = @thumb_resource[:url]
				params[:resources_upload][:data] = params[:data]
				data_param_keys = Spotlight::Resources::Upload.fields(@exhibit).map(&:field_name) + @exhibit.custom_fields.map(&:field)
				@resource.attributes = params.require(:resources_upload).permit(:url, data: data_param_keys)
				@resource.save
				new_url = @thumb_resource.url.file.file.to_s.dup
				new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
				FileUtils.mkdir_p(File.dirname(new_url))
				FileUtils.cp(@thumb_resource.url.file.file, new_url)
				if  @thumb_resource.type.include? "Video"
					format = (@thumb_resource[:url].ends_with?("mp3") ? "audio" : "")
					new_url = new_url.sub! @resource.id.to_s+"/", @resource.id.to_s+"/thumb_"
					stock = new_url.dup
					stock = stock.split("resources").first + "resources/videoupload/url/stock"+format+".jpg"
					FileUtils.cp(stock, new_url)
					new_url = new_url.sub! "thumb", "square"
					FileUtils.cp(stock, new_url)
				else
					new_url = @thumb_resource.url.square.file.file.to_s.dup
					new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
					FileUtils.cp(@thumb_resource.url.square.file.file, new_url)
					new_url = @thumb_resource.url.thumb.file.file.to_s.dup
					new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
					FileUtils.cp(@thumb_resource.url.thumb.file.file, new_url)
				end
				@sidecar = Spotlight::SolrDocumentSidecar.new(exhibit: @exhibit)
				@sidecar.data["configured_fields"] = params[:data]
				@sidecar.document_id = "#{@resource.exhibit_id}-#{@resource.id}"
				@sidecar.document_type = "SolrDocument"
				@sidecar.save
				@resource.save_and_index
				redirect_to "/spotlight/#{params[:exhibit_id]}/dashboard", notice: 'compound object created successfully'
			rescue => e
				redirect_to "/spotlight/#{params[:exhibit_id]}/dashboard", alert: "There was an error: compound object was not created"
			end
		end
		
		def edit
			@exhibit = Spotlight::Exhibit.find params[:exhibit_id]
			id = params[:id].split('-')[1].to_i
			@resource = Spotlight::Resource.find(id)
			
		end
		
		def update
			begin
				@exhibit = Spotlight::Exhibit.find params[:exhibit_id]
				id = params[:id].split('-')[1].to_i
				@resource = Spotlight::Resource.find(id)
				@sidecar = Spotlight::SolrDocumentSidecar.where(document_id: params[:id]).first
				params[:data].each do |key, value|
					@resource.data[key] = value
					@sidecar.data["configured_fields"][key] = value
				end
				@sidecar.save
				resource_dir = @resource.url.file.file.dup
				resource_dir = resource_dir.sub(@resource[:url], "*")
				FileUtils.rm_rf(Dir.glob(resource_dir))
				#items....
				@thumb_resource = Spotlight::Resource.find(params[:data][:items].first.split("-")[1])
				params[:resources_upload] = {}
				params[:resources_upload][:url] = @thumb_resource[:url]
				params[:resources_upload][:data] = params[:data]
				@resource[:url] = @thumb_resource[:url]
				data_param_keys = Spotlight::Resources::Upload.fields(@exhibit).map(&:field_name) + @exhibit.custom_fields.map(&:field) + [:items, :spotlight_upload_compound_object_is]
				@resource.attributes = params.require(:resources_upload).permit(:url, data: data_param_keys)
				params[:data].each do |key, value|
					@resource.data[key] = value
					@sidecar.data["configured_fields"][key] = value
				end
				new_url = @thumb_resource.url.file.file.to_s.dup
				new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
				FileUtils.cp(@thumb_resource.url.file.file, new_url)
				if  @thumb_resource.type.include? "Video"
					format = (@thumb_resource[:url].ends_with?("mp3") ? "audio" : "")
					new_url = new_url.sub! @resource.id.to_s+"/", @resource.id.to_s+"/thumb_"
					stock = new_url.dup
					stock = stock.split("resources").first + "resources/videoupload/url/stock"+format+".jpg"
					FileUtils.cp(stock, new_url)
					new_url = new_url.sub! "thumb", "square"
					FileUtils.cp(stock, new_url)
				else
					new_url = @thumb_resource.url.square.file.file.to_s.dup
					new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
					FileUtils.cp(@thumb_resource.url.square.file.file, new_url)
					new_url = @thumb_resource.url.thumb.file.file.to_s.dup
					new_url = new_url.sub! "/"+@thumb_resource.id.to_s+"/", "/"+@resource.id.to_s+"/"
					FileUtils.cp(@thumb_resource.url.thumb.file.file, new_url)
				end
				@sidecar.save
				@resource.save_and_index
				@sidecar.data["configured_fields"] = params[:data]
				@sidecar.save
				index = 0
				@resource.data["items"].each do |value|
					Rails.logger.warn("COMPOUND CONTROLLER EDIT!!!!!: "+value)
					curr_resource = Spotlight::Resource.find(value.split("-").last.to_i)
					curr_resource.data["spotlight_upload_parent_tesim"] = "/spotlight/#{params[:exhibit_id]}/catalog/#{@exhibit.id.to_s}-#{@resource.id.to_s}/#{index.to_s}"
					curr_resource.save_and_index
					curr_sidecar = Spotlight::SolrDocumentSidecar.where(document_id: value).first
					curr_sidecar.data["configured_fields"]["spotlight_upload_parent_tesim"] = "/spotlight/#{params[:exhibit_id]}/catalog/#{@exhibit.id.to_s}-#{@resource.id.to_s}/#{index.to_s}"
					curr_sidecar.save
					index += 1
				end
				redirect_to "/spotlight/#{params[:exhibit_id]}/dashboard", notice: 'compound object updated successfully'
			rescue => e
				Rails.logger.warn(e.inspect)
				redirect_to "/spotlight/#{params[:exhibit_id]}/dashboard", alert: "compound object was not updated"
			end
		end
		
		protected
		
		def check_authorization
		  authorize! :curate, @exhibit
		end
	end
end