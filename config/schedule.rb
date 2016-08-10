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


every 1.day, :at => '4:30 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.generate_pdfs", :environment => 'development'
end

every 1.day, :at => '3:30 am' do
	command 'echo "$(date): "'
	runner "Spotlight::Resource.index_all", :environment => 'development'
end

# every 1.day :at => '2:30 am' do
# 	command 'echo "$(date): "'
# 	runner "Spotlight::Resource.upload_sketchfab", :environment => 'development'
# end
