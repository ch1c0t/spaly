module ZurbFoundation
  def self.css
    @css ||= IO.read "#{__dir__}/foundation.min.css"
  end
end
