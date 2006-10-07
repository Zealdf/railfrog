require 'hash_extension'

# The Plugin System needs Edge Rails to work.
# NOTE: Currently Rails Engines doesn't work with Edge Rails, so don't forget to
# turn Rails Engines off.

if Dependencies.respond_to?(:autoloaded_constants) # I just try to figure out if Edge Rails is installed
  require 'plugin_system'
  require 'railfrog_resources'
  
  # FIXME: REMOVE THIS
  if RAILS_ENV == 'test'
    PluginSystem::Instance.installed_plugins.each do |plugin|
      plugin.enable if plugin.disabled?
    end
  end
  ####################
  
  # Start Plugin System
  PluginSystem::Instance.start(config)
end