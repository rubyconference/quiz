Gem::Specification.new do |s|
  s.name          = 'regexp_integer_matcher'
  s.version       = '0.1'
  s.date          = '2015-03-19'
  s.authors       = ['Aliaksandr Buhayeu']
  s.email         = 'aliaksandr.buhayeu@gmail.com'
  s.homepage      = 'https://github.com/aliaksandrb/quiz'
  s.summary       = 'A simple library that adds a class method called build() to Regexp'
  s.description   = "
    This method accepts a variable number of arguments,
    which can include Integers and Ranges of Integers.
    It returns a Regexp object that will match only Integers
    in the set of passed arguments.
  "

  s.files         = ['lib/regexp_integer_matcher.rb']
  s.test_files    = ['test/regexp_integer_matcher_test.rb']

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.4.3'
end
