
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

package :nginx_conf, :role => :app do 
	transfer './files/nginx.conf', "/etc/nginx/nginx.conf", :sudo => true
	
	post :install, '/etc/init.d/nginx restart'
	requires :nginx
end

package :unicorn do 
	
end

package :nginx_and_unicorn, :provides => :webserver do 
	requires :nginx_conf
end