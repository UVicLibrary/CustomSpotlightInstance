# encoding: utf-8
module Spotlight
  ##
  # Process a CSV upload into new Spotlight::Resource::Upload objects
  class AddUploadsFromCSV < ActiveJob::Base
  	  Rails.logger.info("\n AT:"+Time.now.strftime("%m/%d %H:%M:%S:%L")+"\n********IN AddUploadsFromCSV")
    queue_as :default

    after_perform do |job|
      csv_data, exhibit, user = job.arguments
      Spotlight::IndexingCompleteMailer.documents_indexed(csv_data, exhibit, user).deliver_now
    end

    def perform(csv_data, exhibit, _user)
    	#Rails.logger.info("\n AT:"+Time.now.strftime("%m/%d %H:%M:%S:%L")+"\n********IN PREFORM")
      encoded_csv(csv_data).each do |row|
      	  #Rails.logger.info("\n AT:"+Time.now.strftime("%m/%d %H:%M:%S:%L")+"\n****************************\nIn uploads from cvs preform \n\nCURRENT ROW: #{row.inspect}")
        url = row.delete('url')
        
        next unless url.present?

        if (url.include? ".mp4") || (url.include? ".mp3")
          Spotlight::Resources::Videoupload.create(
            remote_url_url: url,
            data: row,
            exhibit: exhibit
          )
        else
          Spotlight::Resources::Upload.create(
            remote_url_url: url,
            data: row,
            exhibit: exhibit
          )
        end
      end
    end

    private

    def encoded_csv(csv)
      csv.map do |row|
        row.map do |label, column|
          [label, column.encode('UTF-8', invalid: :replace, undef: :replace, replace: "\uFFFD")] if column.present?
        end.compact.to_h
      end.compact
    end
  end
end
