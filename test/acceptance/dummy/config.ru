require 'bundler/setup'
Bundler.require :test

map '/assets' do
  env = Sprockets::Environment.new
  env.append_path 'assets/js'

  run env
end
