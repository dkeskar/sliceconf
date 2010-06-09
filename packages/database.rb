
package :database_driver do 
	requires :mysql_driver
	requires :mongo_driver
end

package :database do 
	requires :mysql
	requires :mongodb
end

package :mysql_driver do
	description "Ruby MySQL database driver"
	
	gem 'mysql'
	verify do 
		has_gem 'mysql'
	end
	requires :ruby_enterprise
	requires :mysql_client
end

package :mysql_client do 
	description 'MySQL client components'	
	apt %w(mysql-client libmysqlclient15-dev) 
	
	verify do 
		has_directory '/usr/lib/mysql'
		has_executable 'mysql'
	end
end

package :mysql do 
	description 'MySQL database'
	
	apt 'mysql-server'
	verify do 
		has_executable '/etc/init.d/mysql'
	end	
	requires :mysql_client
end

# MongoDB
package :mongo_driver do 
	gem 'mongo_mapper'
	# mongo_mapper installs bson and mongo (1.0)
	gem 'bson_ext', :version => "1.0"
	
	verify do 
		%w(mongo bson bson_ext mongo_mapper).each do |mongo_component|
			has_gem mongo_component
		end
		has_gem 'bson', "1.0"
	end
	requires :ruby_enterprise
end

package :mongodb do 
	apt 'mongodb-stable' do 
		post :install, "sudo /etc/init.d/mongod start"
	end
	verify do 
		has_executable 'mongod'
		has_executable 'mongo'
	end
	requires :mongodb_deb
end

package :mongodb_deb do 
	description "Add mongodb to apt-sources list"
	
	sources_list = "/etc/apt/sources.list"
	mongodb = <<EOL
\n# mongodb package repository
deb http://downloads.mongodb.org/distros/debian 5.0 10gen
EOL

	push_text mongodb, sources_list, :sudo => true do 
		post :install, 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10'
		post :install, 'apt-get update'
	end	
	verify { file_contains sources_list, 'mongodb' }	
end
