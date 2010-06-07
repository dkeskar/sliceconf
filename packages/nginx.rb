
package :nginx_conf do 
	transfer 'files/nginx.conf', '/etc/nginx.conf', :sudo => true
end