require File.expand_path(File.dirname(__FILE__) + '/../../../../spec/spec_helper') # the default rails helper

SpecTestCase.fixture_path = File.dirname(__FILE__) + '/fixtures'

@@__plugin_system_root = File.join(RAILS_ROOT, 'vendor', 'plugins', 'railfrog', 'spec', 'lib', 'plugin_system', 'data')
@@__plugin_system_specs = File.join(@@__plugin_system_root, 'specifications')
@@__plugin_system_gems = File.join(@@__plugin_system_root, 'gems')
@@__no_plugins_root = File.join(RAILS_ROOT, 'vendor', 'plugins', 'railfrog', 'spec', 'lib', 'plugin_system', 'no_plugins')

::Dependencies.mechanism = :load
