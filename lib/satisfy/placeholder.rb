module Satisfy
  class Placeholder
    class Match < Struct.new(:regexp, :block); end

    class << self
      def resolve(name)
        find(name).regexp
      end

      def find(name)
        placeholders[name] || default
      end

      def apply(name, value)
        find(name).apply(value)
      end

      def add(name, &block)
        placeholders[name] = Placeholder.new(name, &block)
      end

      private

      def placeholders
        @placeholders ||= {}
      end

      def default
        @default ||= new(:default) do
          match(/(?:"([^"]*)"|'([^']*)'|([[:alnum:]_-]+))/) do |first, second, third|
            first || second || third
          end
        end
      end
    end

    def initialize(name, &block)
      @name = name
      @matches = []
      instance_eval(&block)
    end

    def match(regexp, &block)
      @matches << Match.new(regexp, block)
    end

    def apply(value)
      match, params = find_match(value)
      match && match.block ? match.block.call(*params) : value
    end

    def regexp
      Regexp.new(@matches.map(&:regexp).join('|'))
    end

    def find_match(value)
      @matches.each do |m|
        result = value.scan(m.regexp)
        return m, result.flatten unless result.empty?
      end
      nil
    end
  end
end
