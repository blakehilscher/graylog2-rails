namespace :graylog2_rails do
  desc "Install Graylog2"
  task :install do
    system "rails g graylog2_rails:install"
  end
end
