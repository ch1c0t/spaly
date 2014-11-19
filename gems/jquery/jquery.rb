module JQuery
  def self.to_s
    IO.read "#{__dir__}/jquery-2.1.1.min.js"
  end
end
