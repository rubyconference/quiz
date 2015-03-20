namespace :tests do
  desc 'run all tests available'
  task :test do
    Dir.glob('./test/**/*_test.rb') { |file| require file }
  end
end

task default: 'tests:test'
