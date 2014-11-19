lib = File.expand_path './lib/'
$:.unshift lib unless $:.include? lib

Gem::Specification.new do |g|
  g.name    = 'spaly'
  g.version = '0.0.0'
  g.summary = 'A framework for creating SPAs(single-page applications) in a quick, pleasant, and spaly way.'
  g.authors = ['Anatoly Chernow']

  g.require_path = 'lib'
end
