module JQuery
  def self.to_s
    @string ||= IO.read "#{__dir__}/jquery.min.js"
  end
end
