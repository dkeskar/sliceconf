
Sprinkle::Installers::Deb.class_eval do 
  protected
  def install_commands #:nodoc:
    [
    "wget -cq --directory-prefix=/tmp #{@packages.join(' ')}", 
    "dpkg -i #{@packages.collect{|p| "/tmp/#{package_name(p)}"}.join(" ")}"
    ]				
  end	
end

Sprinkle::Installers::Apt.class_eval do 
  protected
  def install_commands #:nodoc:
    command = @options[:dependencies_only] ? 'build-dep' : 'install'
    release = @options[:distro_release] ? "-t #{@options[:distro_release]}" : ""
    "env DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get --force-yes -qyu #{release} #{command} #{@packages.join(' ')}"				
  end	
end

Sprinkle::Package::Package.class_eval do 
  def monitor_using(configfile, options = {}, &block)
    @installers << Sprinkle::Installers::Monitor.new(self, configfile, options, &block)
  end  
end

module Sprinkle
  module Installers
    # = Monitoring configuration installer
    #
    # This installer pushes monit conf files from local disk and restarts monit
    # 
    # == Example Usage
    #
    # Monitor nginx using nginx.monit.erb
    #
    #   package :nginx_conf do
    #     monitor_using 'files/nginx.monit.erb'
    #   end
    #
    # By default, :sudo is true
    #
		# Default location for the file is /etc/monit.d/<first-part-of-filename-before-dot>
		# Supports pre/post :install directives should you need to run commands before or 
		# after the monitoring setup
		#
    class Monitor < Sprinkle::Installers::Transfer

      def initialize(parent, config, options={}, &block) #:nodoc:
        options.merge!(:render => true) if config.match(/erb$/)
        @component = config.split('/').last.split('.').first        
        stage = "/tmp/#{@component}.#{Time.now.to_i}"
        super parent, config, stage, options, &block
        @config = "/etc/monit/conf.d/#{@component}"
        post(:install, "cp #{stage} #{@config} && rm #{stage}")
        post(:install, "sudo chmod 644 #{@config}")
        post(:install, "sudo /etc/init.d/monit force-reload")
      end
      
    end
  end
end

module Sprinkle
  module Verifiers
    module Monitoring
      Sprinkle::Verify.register(Sprinkle::Verifiers::Monitoring)      
      
      def has_monitored(process_name)
        @commands << "grep 'check process #{process_name}' /etc/monit/monitrc /etc/monit/conf.d/*"
      end
    end
  end
end

