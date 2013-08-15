$:.unshift File.expand_path("../lib", __FILE__)

require 'bundler'
require 'thor/rake_compat'

class Default < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  desc "build", "Build nit-#{Nit::VERSION}.gem into the pkg directory"
  def build
    Rake::Task["build"].execute
  end

  # sometimes gem install pkg/nit-0.x.x works.
  desc "install", "Build and install nit-#{Nit::VERSION}.gem into system gems"
  def install
    Rake::Task["install"].execute
  end
end
