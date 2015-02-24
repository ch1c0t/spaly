require 'spaly'

app = Spaly.new do
  input :name
  text 'Привет, {:name}!'
end

app.spec do
  scenario do
    name, greeting = grains

    assert { greeting.text == '' }

    name.set 'мироощущение'
    assert { greeting.text == 'Привет, мироощущение!' }

    9.times { name.send_keys :backspace }
    assert { greeting.text == 'Привет, мир!' }

    name.send_keys 'аж'
    assert { greeting.text == 'Привет, мираж!' }
  end
end

if ENV['SPALY_ENV'] == 'test'
  app.spec.run
else
  app.run
end
