module Satisfy
  class Pending < StandardError; end
  class Ambiguous < StandardError; end

  class ColumnMismatch < StandardError
    def initialize(expected, actual)
      super("Expected the table to be #{expected} columns wide, but found #{actual}.")
    end
  end

  class ColumnDoesNotExist < StandardError
    def initialize(column_name)
      super("The column named \"#{column_name}\" does not exist.")
    end
  end
end
