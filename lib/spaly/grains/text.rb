module Spaly
  module Grains
    class Text
      prepend Grain

      def initialize(string:)
        @models = find_models_in string
        @string = string
      end

      def initial_html
        "<p id=#{@id}></p>"
      end

      def update
        string = if @models.values.all?
          adapted = @models.map {|k,v| ["{:#{k}}", v]}.to_h
          @string.gsub Interpoloid, adapted
        else
          ''
        end

        action = Action.new type: :update, id: @id, html: string
        @@new_actions << action
      end

      private

      Interpoloid = /\{(.*?)\}/
      def find_models_in string
        string.scan(Interpoloid).flatten.map do |string|
          string[1..-1].to_sym
        end.map { |model| [model, nil] }.to_h
      end
    end
  end
end
