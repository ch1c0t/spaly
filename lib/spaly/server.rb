module Spaly
  class Server
    def initialize app
      @angelo = Class.new Angelo::Base do
        get '/' do
          app.initial.html
        end

        eventsource '/sse' do |s|
          sses[:single] << s

          message = { type: 'execute', js: app.initial.js }
          sses[:single].message message.to_json
        end

        post '/event' do
          actions = app.handle params
          actions.each do |action|
            sses[:single].message action.to_json
          end
        end
      end
    end

    def run
      @angelo.run!
    end
  end
end
