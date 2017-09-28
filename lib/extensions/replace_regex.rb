# Used by Jekyll during conversion
module Jekyll
  # A Liquid Template Filter for using regular expressions
  module RegexFilter
    # Simple replacement
    def replace_regex(input, regex_string, replace_string)
      regex = Regexp.new regex_string
      input.gsub regex, replace_string
    end
  end
end

Liquid::Template.register_filter(Jekyll::RegexFilter)
