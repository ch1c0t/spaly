module Spaly
  module Grains
    include Grain
  end
end

Dir["./lib/spaly/grains/**/*.rb"].each do |file|
  require_relative File.expand_path file
end
