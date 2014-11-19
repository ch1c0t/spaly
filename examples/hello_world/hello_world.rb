require 'spaly'

app = Spaly.new do
  input :name
  text 'Привет, {:name}!'
end

app.run
