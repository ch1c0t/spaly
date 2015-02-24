require 'watir-webdriver'
require 'pry'

class Spaly::App
  class Scenario
    def initialize app: nil, &block
      @app = app
      @block = block
    end

    def assert
      sleep 0.2
      yield ? true : binding.pry
    end

    def grains
      @app.grains.map do |id, grain|
        element = grain.watir_element
        @browser.send element, :id, id
      end
    end

    attr_reader :browser
    def run
      @browser = Watir::Browser.new
      #@browser.goto @app.url
      @browser.goto 'http://localhost:4567'
      instance_eval &@block
      @browser.close
    end
  end

  class Spec
    def initialize app: nil, &b
      @app = app
      @scenarios = []
      instance_eval &b
    end

    def scenario &b
      scenario = Scenario.new app: @app, &b
      @scenarios << scenario
    end

    def run
      pid = fork { exec @app.run }
      @scenarios.each { |s| s.run }
      `kill #{pid}`
    end
  end
end
