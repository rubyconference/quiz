# [RubyConference](http://rubyconference.by/) quiz


## Challenge


Build a library that adds a class method called `build()` to `Regexp`. This method should accept a variable number of arguments, which can include Integers and Ranges of Integers. Have `build()` return a `Regexp` object that will match only Integers in the set of passed arguments.

Here are some examples of possible usage:

```ruby
lucky = Regexp.build(3, 7)
"7"  =~ lucky # => true
"13" =~ lucky # => false
"3"  =~ lucky # => true
```

```ruby
month = Regexp.build(1..12)
"0"  =~ month # => false
"1"  =~ month # => true
"12" =~ month # => true
```

```ruby
day = Regexp.build(1..31)
"6"    =~ day # => true
"16"   =~ day # => true
"Tues" =~ day # => false
```

```ruby
year = Regexp.build(98, 99, 2000..2005)
"04"   =~ year # => false
"2004" =~ year # => true
"99"   =~ year # => true
```

```ruby
num = Regexp.build(0..1_000_000)
"-1" =~ num # => false
```


## Notes

* Obviously you should use `ruby` for solving this.
* Extra point for solutions completely following [ruby-style-guide](https://github.com/bbatsov/ruby-style-guide)
* You will receive additional points for covering different edge cases.


## Benefits

* On March 20, 2015 we will send free [RubyConference](http://rubyconference.by/) tickets to 3 winners.

## How to participate

* Fork this repository
* Add a folder with same name as your account on github.
* Write your solution inside your folder.
* Send us a pull request.

Once your pull request is merged - you are accepted.

MAY THE FORCE BE WITH YOU!
