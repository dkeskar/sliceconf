module Sprinkle
	module Installers
		class Deb < Installer
			
			protected
			def install_commands #:nodoc:
        [
				"wget -cq --directory-prefix=/tmp #{@packages.join(' ')}", 
				"dpkg -i #{@packages.collect{|p| "/tmp/#{package_name(p)}"}.join(" ")}"
				]				
			end			
		end
		
		class Apt < Installer
			
			def initialize(parent, *packages, &block)
        packages.flatten!

        options = { :dependencies_only => false }
        options.update(packages.pop) if packages.last.is_a?(Hash)

        super parent, options, &block

        @packages = packages				
			end
			
			protected
			def install_commands #:nodoc:
        command = @options[:dependencies_only] ? 'build-dep' : 'install'
				release = @options[:distro_release] ? "-t #{@options[:distro_release]}" : ""
        "env DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get --force-yes -qyu #{release} #{command} #{@packages.join(' ')}"				
			end
		end
	end
end
