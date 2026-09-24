class String

  alias match_spermy =~

  def =~ regexp
    result = match_spermy(regexp)
    regexp.humanize ? humanize_result(result) : result
  end

  private

  def humanize_result(result)
    result.nil? ? Regexp::FALSEY : Regexp::TRUTHY
  end

end
