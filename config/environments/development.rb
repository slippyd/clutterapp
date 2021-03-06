# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_controller.perform_caching             = true

# Use cache in dev in order to test that it actually works!
#config.cache_store = :memory_store

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true


require 'pp'


if File.exists?(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
  rdebugrc_path = File.expand_path('~/.rdebugrc')
  File.open(rdebugrc_path, File::CREAT|File::EXCL) do
    puts 'set autoeval'
    puts 'set autolist'
    puts 'set autoreload'
  end unless File.exists?(rdebugrc_path)
  
  require 'ruby-debug'
  Debugger.wait_connection = true
  Debugger.start_remote
  File.delete(File.join(RAILS_ROOT,'tmp', 'debug.txt'))
end
