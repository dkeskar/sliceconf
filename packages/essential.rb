
# add backport line to /etc/apt/sources.list with necessary key
package :lenny_backports do 
	description 'Add lenny-backports to apt sources.list'
	sources_list = "/etc/apt/sources.list"
	backports = <<EOL
\n# backports
deb http://www.backports.org/debian lenny-backports main contrib non-free
EOL

	push_text backports, sources_list, :sudo => true do 
		post :install, 'apt-key adv --keyserver subkeys.pgp.net --recv 16BA136C'
	end	
	verify { file_contains sources_list, 'lenny-backports' } 	
end

package :build_essential do
  description 'Build tools'
  apt 'build-essential', :sudo => true do
    # Update the sources and upgrade the lists before we build essentials
    pre :install, ['aptitude update', 'aptitude -q -y safe-upgrade']
  end
end

package :essential do 
	description "Essential Debian packages"
	apt 'exim4 git-core'
	
	requires :lenny_backports
	requires :build_essential	
end