require 'spec/rake/spectask'

desc 'Run all model and controller specs'
task :spec do
  Rake::Task["spec:models"].invoke      rescue got_error = true
  Rake::Task["spec:controllers"].invoke rescue got_error = true
  Rake::Task["spec:plugins"].invoke     rescue got_error = true
  
  # not yet supported
  #if File.exist?("spec/integration")
  #  Rake::Task["spec:integration"].invoke rescue got_error = true
  #end

  raise "RSpec failures" if got_error
end

task :stats => "spec:statsetup"

namespace :spec do
  desc "Run the specs under spec/models"
  Spec::Rake::SpecTask.new(:models => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/models/**/*_spec.rb']
  end

  desc "Run the specs under spec/controllers"
  Spec::Rake::SpecTask.new(:controllers => "db:test:prepare") do |t|
    t.spec_files = FileList['spec/controllers/**/*_spec.rb']
  end
  
  desc "Run the specs under vendor/plugins"
  Spec::Rake::SpecTask.new(:plugins => "db:test:prepare") do |t|
    t.spec_files = FileList['vendor/plugins/**/spec/**/*_spec.rb']
  end

  desc "Print Specdoc for all specs"
  Spec::Rake::SpecTask.new('doc') do |t|
    t.spec_files = FileList[
      'spec/models/**/*_spec.rb',
      'spec/controllers/**/*_spec.rb',
      'vendor/plugins/**/spec/**/*_spec.rb'
    ]
    t.spec_opts = ["--format", "specdoc"]
  end
end
