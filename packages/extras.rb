
package :geoip do 
	gem 'mtodd-geoip', :source => "http://gems.github.com"
	verify do 
		has_gem 'mtodd-geoip'
	end
	requires :geoip_lib
end

package :geoip_lib do 
	src_url = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.6.tar.gz"
	data = "GeoLiteCity.dat"
	data_dir = "/usr/local/share/GeoIP"
	data_url = "http://www.maxmind.com/download/geoip/database/#{data}.gz"
	source src_url, :sudo => true do 
		prefix '/usr/local'
		post :install, "mkdir -p #{data_dir}"
		post :install, "cd /tmp; wget #{data_url}"
		post :install, "gunzip /tmp/#{data}.gz && mv /tmp/#{data} #{data_dir}"
	end
	verify do 
		has_file "/usr/local/lib/libGeoIP.so.1.4.6"
		has_file "#{data_dir}/#{data}"
	end
end

package :daemons do 
	gem 'daemons'
	verify {has_gem 'daemons'}
end
