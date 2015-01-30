require 'angelo'

require 'tilt'
require 'tilt/erb'
require 'tilt/coffee'
require 'jquery'
require 'zurb_foundation'

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'

%w!
  grain
  grains
  app
  server
!.each { |file| require_relative "./spaly/#{file}" }

module Spaly
  def self.new &declaration
    App.new declaration
  end
end
