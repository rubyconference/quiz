class Regexp
  def self.build(*args)
    fail ArgumentError, 'wrong number of arguments (0 for 1+)' if args.empty?

    error_msg = 'wrong argument type %s (expected Integer or Range of Integers)'
    args.each do |arg|
      next if arg.is_a? Integer

      if arg.is_a? Range
        unless (first_elem = arg.first).is_a? Integer
          fail TypeError, error_msg % "#{arg.class}[#{first_elem.class}]"
        end
      else
        fail TypeError, error_msg % arg.class
      end
    end

    matchers = args.map { |matcher| [*matcher] }.flatten.uniq.join('|')

    new(/\A(?:#{matchers})\z/)
  end
end
