
package :monit do 
	description "Monit for system monitoring of files, processes, directories or devices"
	apt 'monit'
	verify {has_executable 'monit'}
end

package :monit_rc do 
  description "monitrc"	
	stage = "/home/app/monitrc"
	dest = "/etc/monit/monitrc"	
	transfer 'files/monitrc.erb', stage, :sudo => true do 
		post :install, "sudo mv #{stage} #{dest}"
		post :install, "sudo chmod 644 #{dest}"
	end

	verify do 
		has_file '/etc/monit/monitrc'
	end
	requires :monit, :monit_initd
end

package :monit_initd do
  description "monit init.d script"	
	stage = "/home/app/monit"
	dest = "/etc/init.d/monit"	
	transfer 'files/monit.init', stage, :sudo => true do 
		post :install, "sudo mv #{stage} #{dest}"
		post :install, "sudo chmod +x #{dest}"
	end

	verify do 
		has_executable '/etc/init.d/monit'
	end	
end

package :monit_setup, :provides => :monitoring do
	description 'Setup and configure monit'
	requires :monit
	requires :monit_initd
	requires :monitrc
end

# deprecated 
package :monit_from_source do
  description 'Monit for system monitoring of files, processes, directories, or devices'
  version = '5.1.1'
  source "http://mmonit.com/monit/dist/monit-#{version}.tar.gz", :sudo => true do
		prefix "/usr/local"
    post :install, 'mkdir /etc/monit'
    post :install, 'mkdir /var/lib/monit'
  end
  
  verify do
    has_executable "monit"
  end
  requires :essential
end
  
package :monit_dependencies do
  description "Dependencies to build monit from source"
  apt 'flex byacc'
end

