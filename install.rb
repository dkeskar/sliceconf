$:<< File.join(File.dirname(__FILE__), 'packages')

require 'lib/fixups.rb'
%w(essential ruby_enterprise webserver database extras monit).each do |package|
	require package
end

policy :app_slice, :roles => :app do 
	# requires :essential
	# requires :ruby_enterprise
	# requires :rails
	# requires :webserver
	# requires :database_driver
	# requires :geoip
	# requires :daemons
	requires :monit
	# requires :memcached
end

policy :data_slice, :roles => :storage do 
	requires :essential
	requires :database 
end

policy :front_end, :roles => :web do 
	requires :essential
	requires :nginx
	# requires :proxy_conf
end

deployment do 
	delivery :capistrano do 
		begin 
			recipes 'Capfile'
		rescue LoadError
			recipes 'config/deploy'
		end
	end
	
	source do 
		prefix '/usr/local'
		archives '/usr/local/sources'
		builds '/usr/local/build'
	end	
end

begin 
	gem 'sprinkle', '>= 0.2.3'
rescue Gem::LoadError
	puts 'require sprinkle 0.2.3.'
	exit
end
