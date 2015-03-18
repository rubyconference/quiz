# Add a class method 'build' to Regexp
class Regexp
  def self.build(*args)
    reg = args.map { |arg| arg.is_a?(Range) ? arg.to_a : arg }
    Regexp.new(/\A(?:#{reg.flatten.uniq.join('|')})\z/)
  end
end
