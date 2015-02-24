module Spaly
  module Grains
    class Input
      prepend Grain

      def watir_element
        :text_field
      end

      def initial_html
        "<input id='#{@id}'></input>"
      end

      def initial_js
        template = Tilt.new "#{__dir__}/input.coffee.erb"
        CoffeeScript.compile template.render self
      end

      def handle event
        new_value = event['input'] if event['type'] == 'input'
        if @value != new_value
          @value = new_value
          notify_subscribers
        end
      end
    end
  end
end
