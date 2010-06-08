$:<< File.join(File.dirname(__FILE__), 'packages')

require 'lib/fixups.rb'
%w(essential ruby_enterprise webserver mongo).each do |package|
	require package
end

policy :slice_setup, :roles => :app do 
	requires :essential
	requires :ruby_enterprise
	requires :rails
	requires :webserver
	# requires :nginx
	# requires :rails
	# requires :unicorn
	# requires :mongo_mapper	
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
