
package :ruby_enterprise do 
	description 'Ruby Enterprise Edition via .deb'
	
	version = '1.8.7-2010.01'
	pkg_name = "ruby-enterprise_#{version}_amd64.deb"
	pkg_url = "http://rubyforge.org/frs/download.php/68720/#{pkg_name}"
	
	binaries = %w(erb gem irb rackup rails rake rdoc ree-version ri ruby testrb)
	deb pkg_url do 
		post :install, "sudo gem update --system"
	end
	
	verify do 
		binaries.each {|bin| has_executable "#{bin}" }
		has_version_in_grep "ruby -v", "Ruby Enterprise Edition"
		has_executable_with_version "gem", "1.3.7"
	end
	
	requires :ree_dependencies
end

package :ree_dependencies do
	# nothing special for now, since we are installing from deb
	requires :essential
end

package :rails do 
	version = '2.3.5'
	gem 'rails', :version => version
	verify { has_executable_with_version 'rails', version }
end