module Spaly
  module Initiable
    def initial_html
      "<div id=#{@id}></div>"
    end

    def initial_js
      ''
    end
  end

  module Observable
    attr_reader :models

    private

    @@subscribers_of = Hash.new { |h,k| h[k] = [] }
    def subscribe_to_models
      models_ids.each do |id|
        @@subscribers_of[id] << self
      end
    end

    def notify_subscribers
      @@subscribers_of[@id].each do |grain|
        grain.models[@id] = @value
        grain.update
      end
    end

    def models_ids
      @models.keys
    end
  end
  
  class Action
    def initialize **kwargs
      @hash = kwargs
    end

    def to_json
      jsonable = @hash.map {|k,v| [k, v.to_s]}.to_h
      jsonable.to_json
    end
  end

  module Grain
    include Observable

    @@grains = HashWithIndifferentAccess.new
    def initialize *a
      @id = a.last.delete :id
      @@grains[@id] = self

      super **a.last if self.class == Grains::Text

      @models ||= {}
      subscribe_to_models unless @models.empty?
    end

    @@new_actions = []
    class << self
      def prepended grain
        grain.include Initiable
      end

      def new_actions
        @@new_actions.tap { @@new_actions = [] }
      end

      def [] id
        @@grains[id]
      end

      def initial kind
        @@grains.map { |_id, grain| grain.send "initial_#{kind}" }.join
      end
    end
  end
end
