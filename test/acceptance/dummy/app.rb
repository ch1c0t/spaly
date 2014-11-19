require 'bundler'
Bundler.require :test

set :port, 4566

set :assets, Sprockets::Environment.new
settings.assets.append_path "#{__dir__}/assets/js"
RailsAssets.load_paths.each { |path| settings.assets.append_path path }

get '/js/:file.js' do
  content_type 'application/javascript'
  settings.assets["#{params[:file]}.js"]
end

get '/hello_world' do
  slim :hello_world
end
