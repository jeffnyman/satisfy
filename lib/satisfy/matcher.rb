module Satisfy
  class Matcher
    class Match < Struct.new(:step_definition, :params, :block)
      def expression
        step_definition.name
      end

      def method_name
        step_definition.method_name
      end

      def called_from
        step_definition.called_from
      end

      def trace
        %{  - "#{expression}" (#{called_from})}
      end
    end

    attr_reader :name, :method_name, :called_from, :block

    def initialize(name, method_name = nil, called_from = nil, &block)
      @name = name
      @method_name = method_name || name
      @called_from = called_from
      @block = block
    end

    def match(description)
      # puts "Matcher.match (description): #{description}"

      result = description.match(regexp)
      if result
        params = result.captures
        @placeholders.each_with_index do |name, index|
          params[index] = Satisfy::Placeholder.apply(name.to_sym, params[index])
        end
      end
      Match.new(self, params, block) if result
    end

    def regexp
      @regexp ||= generate_regexp
    end

    PLACEHOLDER_REGEXP = /:([\w]+)/
    OPTIONAL_WORD_REGEXP = /(\\\s)?\\\(([^)]+)\\\)(\\\s)?/
    ALTERNATE_WORD_REGEXP = /([[:alpha:]]+)((\/[[:alpha:]]+)+)/

    def generate_regexp
      @placeholders = []
      regexp = Regexp.escape(name)

      regexp.gsub!(PLACEHOLDER_REGEXP) do |_|
        @placeholders << "#{$1}"
        "(?<#{$1}>#{Placeholder.resolve($1.to_sym)})"
      end

      regexp.gsub!(OPTIONAL_WORD_REGEXP) do |_|
        [$1, $2, $3].compact.map { |m| "(?:#{m})?" }.join
      end

      regexp.gsub!(ALTERNATE_WORD_REGEXP) do |_|
        "(?:#{$1}#{$2.tr('/', '|')})"
      end

      Regexp.new("^#{regexp}$")
    end
  end
end
