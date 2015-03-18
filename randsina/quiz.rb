class Regexp
  def self.build(*args)
    str = args.join('|')
    Regexp.new(/\A(?:#{str})\z/)
    # /\A(?:7|3)\z/
  end
end

lucky = Regexp.build(3, 7)
puts "7"  =~ lucky # => true
p "13" =~ lucky # => false
p "3"  =~ lucky # => true

month = Regexp.build(1..12)
p "0"  =~ month # => false
p "1"  =~ month # => true
p "12" =~ month # => true

day = Regexp.build(1..31)
p "6"    =~ day # => true
p "16"   =~ day # => true
p "Tues" =~ day # => false

year = Regexp.build(98, 99, 2000..2005)
p "04"   =~ year # => false
p "2004" =~ year # => true
p "99"   =~ year # => true

num = Regexp.build(0..1_000_000)
p "-1" =~ num # => false
