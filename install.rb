require 'packages/build_essential'

policy :slice_setup, :roles => :app do 
	requires :lenny_backports
	requires :build_essential
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
