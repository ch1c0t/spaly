module Spaly
  class Layout
    def initialize name = :default
      default if name == :default
    end

    def wrap body
      "<!doctype html><html>#{head}<body>#{body}</body></html>"
    end

    private

    # There is only :default layout at the moment. No need to do anything.
    def default
    end

    def head
      template = Tilt.new "#{__dir__}/main.coffee"
      script   = "<script>#{JQuery}#{template.render}</script>"
      charset  = "<meta charset='utf-8' />"
      viewport = "<meta name='viewport' content='width=device-width, initial-scale=1.0' />"
      style    = "<style>#{ZurbFoundation.css}</style>"

      "<head>#{charset}#{viewport}#{script}#{style}</head>"
    end
  end

  require_relative './app/spec'
  class App
    include Grains

    def initialize declaration
      instance_eval &declaration
    end

    def run
      server = Server.new self
      server.run
    end

    def spec &block
      if block_given?
        @spec = Spec.new app: self, &block
      end
      @spec
    end

    def grains
      Grain.all
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
