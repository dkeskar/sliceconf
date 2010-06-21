
package :monit_setup, :provides => :monitoring do
	description 'Setup and configure monit'
	requires :monit
	requires :monit_initd
	requires :monit_rc
end

package :monit do 
	description "Monit for system monitoring of files, processes, directories or devices"
	apt 'monit', :sudo => true
	verify {has_executable '/usr/sbin/monit'}
end

package :monit_rc do 
  description "Global monitrc customized with hostname"	
	stage = "/home/app/monitrc"
	dest = "/etc/monit/monitrc"	
	transfer 'files/monitrc.erb', stage, :render => true, :sudo => true do 
		post :install, %{sed "s/_SPRINKLE_HOSTNAME/`hostname`/" #{stage} > #{stage}.hn}
		post :install, "mv #{stage}.hn #{dest}"
		post :install, "chmod 644 #{dest}"
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
		post :install, "mv #{stage} #{dest}"
		post :install, "chmod +x #{dest}"
	end

	verify do 
		has_executable '/etc/init.d/monit'
	end	
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

