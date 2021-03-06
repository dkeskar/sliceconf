
package :nginx do 
	descr "Nginx 0.7.65 via lenny backports"
	apt 'nginx' do 
		distro_release 'lenny-backports'
	end
		
	verify do 
		has_executable '/usr/sbin/nginx'
		has_executable '/etc/init.d/nginx'
		has_directory '/etc/nginx'
	end
end

package :nginx_setup do 
	stage = "/home/app/nginx.conf"
	dest = "/etc/nginx/nginx.conf"
	transfer 'files/nginx.conf', stage, :sudo => true	do 
		post :install, "sudo cp #{stage} #{dest} && rm #{stage}"
		post :install, 'sudo /etc/init.d/nginx restart'
	end
	
	monitor_using "monitoring/nginx.monit"
	
	verify do 
		file_contains dest, "sprinkle"
		has_process 'nginx'
		has_monitored 'nginx'
	end

	requires :nginx
end

package :unicorn do 
	version = '0.99.0'
	gem 'unicorn', :version => version do 
		post :install, "sudo gem uninstall rack --version 1.1.0"
	end

	verify do 
		has_gem 'unicorn', version
		has_gem 'rack', '1.0.1'
		has_executable 'unicorn'
		has_executable 'unicorn_rails'		
	end
	requires :unicorn_initd
end

package :unicorn_initd do 
	stage = "/home/app/unicorn"
	dest = "/etc/init.d/unicorn"	
	transfer 'files/unicorn.init', stage, :sudo => true do 
		post :install, "sudo mv #{stage} #{dest}"
		post :install, "sudo chmod +x #{dest}"
	end

	verify do 
		has_executable '/etc/init.d/unicorn'
	end	
end

package :nginx_and_unicorn, :provides => :webserver do 
	requires :nginx_setup
	requires :unicorn
end
