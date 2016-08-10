env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']
env :GEM_HOME, ENV['GEM_HOME']
set :output, "/home/exhibit/ww1-project/ww1-project/log/cron_log.log"
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


every 1.day, :at => '3:30 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(0)", :environment => 'development' 
end
every 1.day, :at => '3:45 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(500)", :environment => 'development' 
end
every 1.day, :at => '4:00 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(1000)", :environment => 'development' 
end
every 1.day, :at => '4:15 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(1500)", :environment => 'development' 
end
every 1.day, :at => '4:30 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(2000)", :environment => 'development' 
end
every 1.day, :at => '4:45 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(2500)", :environment => 'development' 
end
every 1.day, :at => '5:00 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(3000)", :environment => 'development' 
end
every 1.day, :at => '5:15 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(3500)", :environment => 'development' 
end
every 1.day, :at => '5:30 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.reindex_group(4000)", :environment => 'development' 
end

every 1.day, :at => '5:55 am' do
	command 'echo "$(date): "'
	command 'rm /mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/magick*'
	command 'rm /mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/mini_magick*'
end

every 1.day, :at => '6:00 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.generate_pdfs", :environment => 'development' 
end

every 1.day, :at => '7:00 am' do
	command 'echo "$(date): "'
	command 'rm /mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/magick*'
	command 'rm /mnt/nfs/san_01/blacklight-tmp/imagemagick-tmp/mini_magick*'
end