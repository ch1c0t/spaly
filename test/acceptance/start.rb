require 'bundler'
Bundler.require :test

def ok? bool
  unless bool
    puts "Failed at #{caller[0]}."
    binding.pry
  end
end

begin
  sinatra_pid = fork { exec "bundle exec ruby #{__dir__}/dummy/app.rb" }
  spaly_pid   = fork { exec "bundle exec ruby examples/hello_world/hello_world.rb" }

  b = Watir::Browser.new
  scenario = -> do
    sleep 0.3
    ok? b.text == ''

    b.text_field.set 'мироощущение'
    sleep 0.3
    ok? b.text == 'Привет, мироощущение!'

    9.times { b.text_field.send_keys :backspace }
    sleep 0.3
    ok? b.text == 'Привет, мир!'

    b.text_field.send_keys 'аж'
    sleep 0.3
    ok? b.text == 'Привет, мираж!'

    puts 'It passed.'
  end

  puts 'Testing correctness of the acceptance test by running it against the app written in usual jquery manner.'
  b.goto 'http://localhost:4566/hello_world'
  scenario.call

  puts 'Running the acceptance test againts the spaly app.'
  b.goto 'http://localhost:4567'
  scenario.call
ensure
  %x! kill #{sinatra_pid} !
  %x! kill #{spaly_pid} !
  b.close
end
