class Regexp
  FALSEY = 'falsey'
  TRUTHY = 'truthy'

  attr_accessor :humanize

  def self.build(*params)
    args = params.map do |param|
      case param
        when Range then param.to_a
        when Fixnum then param
        else raise 'Only Integers and Ranges are acceptable as parameter'
      end
    end.flatten.join('|')

    r = self.new(/^(?:#{args})$/)
    r.humanize = true
    r
  end

end
