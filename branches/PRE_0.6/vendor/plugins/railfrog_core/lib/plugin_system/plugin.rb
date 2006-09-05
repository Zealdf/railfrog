module PluginSystem
  class PluginIsAlreadyEnabledException < PluginSystem::Exception; end
  class PluginIsAlreadyDisabledException < PluginSystem::Exception; end
  class PluginIsAlreadyStartedException < PluginSystem::Exception; end
  class CannotStartDisabledPluginException < PluginSystem::Exception; end
  class CannotUninstallEnabledPluginException < PluginSystem::Exception; end
  class SpecificationFileDoesNotExistException < PluginSystem::Exception; end
  
  class Plugin
    attr_reader :specification
    
    def initialize(specification_file)
      if File.exists? specification_file
        @specification = ::Gem::Specification.load(specification_file)
        @started = false
      else
        raise SpecificationFileDoesNotExistException, "Specification file #{specification_file} does not exist."
      end
    end
    
    def enable
      if self.enabled?
        raise PluginIsAlreadyEnabledException
      else
        unless File.exist?(path_to_the_plugin_in_the_railsengines_plugins_directory)
          FileUtils.mkdir(path_to_the_plugin_in_the_railsengines_plugins_directory)
        end
        Dir.chdir(path_to_the_plugin_in_the_railfrog_plugins_directory) do
          Dir["**/*"].each do |file_or_directory|
            dest = File.join(
              path_to_the_plugin_in_the_railsengines_plugins_directory,
              file_or_directory)
            unless File.exist?(dest)
              if File.file?(file_or_directory)
                FileUtils.cp(file_or_directory, dest)                
              elsif File.directory?(file_or_directory)
                FileUtils.mkdir(dest)
              end
            end
          end
        end
      end
    end
    
    def enabled?
      File.exist?(path_to_the_plugin_in_the_railsengines_plugins_directory)
    end
    
    def disable
      if self.disabled?
        raise PluginIsAlreadyDisabledException
      else
        FileUtils.rm_rf(
          path_to_the_plugin_in_the_railsengines_plugins_directory,
          :secure => true)
      end
    end
    
    def disabled?
      not enabled?
    end
    
    def start
      if self.disabled?
        raise CannotStartDisabledPluginException
      elsif self.started?
        raise PluginIsAlreadyStartedException
      else
        Engines.start "railfrog_#{specification.name}"
        @started = true
      end
    end
    
    def started?
      @started
    end
    
    def uninstall
      if self.enabled?
        raise CannotUninstallEnabledPluginException
      else
        #FIXME: implement uninstall routine
      end
    end
    
    def path_to_the_plugin_in_the_railfrog_plugins_directory
      File.join(PluginSystem::Base.path_to_gems, specification.full_name)
    end
    
    def path_to_the_plugin_in_the_railsengines_plugins_directory
      File.expand_path(
        File.join(Engines.config(:root), "railfrog_#{specification.name}"))
    end
  end
end
