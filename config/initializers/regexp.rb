class Regexp
  def to_javascript
    Regexp.new(inspect.sub('\\A', '^').sub('\\Z', '$').sub('\\z', '$').sub(%r{^/}, '').sub(%r{/[a-z]*$}, '').gsub(/\(\?#.+\)/, '').gsub(/\(\?-\w+:/, '('), options).inspect
  end
end
