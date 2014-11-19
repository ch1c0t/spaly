module Spaly
  class Layout
    def initialize name = :default
      default if name == :default
    end

    def wrap body
      "<!DOCTYPE html><html>#{head}<body>#{body}</body></html>"
    end

    private

    # There is only :default layout at the moment. No need to do anything.
    def default
    end

    def head
      template = Tilt.new "#{__dir__}/main.coffee"
      "<head><script>#{JQuery}#{template.render}</script></head>"
    end
  end

  class App
    include Grains

    def initialize declaration
      instance_eval &declaration
    end

    def run
      server = Server.new self
      server.run
    end

    class Initial
      attr_reader :html, :js
      def initialize layout
        @html = layout.wrap Grain.initial :html
        @js = Grain.initial :js
      end
    end

    def initial
      layout :default unless @layout
      @initial ||= Initial.new layout
    end

    def handle event
      id = event['id']
      Grain[id].handle event

      Grain.new_actions
    end

    private

    def layout name = nil
      if name.nil?
        @layout
      else
        @layout = Layout.new name
      end
    end

    def input id
      Input.new id: id
    end

    def text string
      Text.new id: random_id, string: string
    end

    def random_id
      Random.srand.to_s
    end
  end
end
