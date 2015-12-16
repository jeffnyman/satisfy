module Satisfy
  class Table
    include Enumerable

    attr_reader :repr
    alias_method :to_a, :repr

    def initialize(repr)
      @repr = repr
    end

    def headers
      repr.first
    end

    def rows
      repr.drop(1)
    end

    def rows_hash
      raise Satisfy::ColumnMismatch.new(2, width) unless width == 2
      transpose.hashes.first
    end

    def hashes
      rows.map { |row| Hash[headers.zip(row)] }
    end

    def each
      repr.each { |row| yield(row) }
    end

    def transpose
      self.class.new(repr.transpose)
    end

    def map_column!(name, strict = true)
      index = headers.index(name.to_s)
      if index.nil?
        raise Satisfy::ColumnDoesNotExist.new(name) if strict
      else
        rows.each { |row| row[index] = yield(row[index]) }
      end
    end

    def width
      repr[0].size
    end
  end
end
