##
# Parses a chunk of text file lines into a format that can be bulk inserted into mongo

class Parser

  ##
  # Creates a Parser instance that can be lazily parsed as needed
  #
  # Params:
  # +lines+:: is a slice of a text file (array of text file line strings).
  # +separator+:: is a delimiter to split file lines on.
  # +scheme+:: is a simple DSL for describing how to parse and translate raw lines from a file.
  # +collection+:: If provided, will returnis the mongo key these data live under.
  # +opts+:: can be used to define :ignore for comment lines, :header_sym to provide header symbol, and :header_separator/:header_scheme which behave
  #
  # The scheme explained:
  # It's structure is that of an array where each index represents a 'column' from the input file.
  # If scheme is nil at that index, the o.g. column data is simply not included in the new document
  #
  # Example:
  # Parsing +"dog,cat,horse"+ with +scheme=[:best,:ok,nil]+
  # The value at +scheme[0]+ becomes the key under which the content of +"dog,cat,horse".split(',')[0]+ will be stored in mongo,
  # so the result is +{:best=>'dog',:ok=>'cat'}+
  #
  attr_accessor :lines, :separator, :scheme,  :collection, :options

  def initialize(lines, line_separator, line_scheme, collection = nil, opts = {})
    @lines = lines
    @separator = line_separator
    @scheme = line_scheme
    @collection = collection
    @options = opts
  end

  def parse
    new_docs = []

    @lines.each do |line|
      obj = Parser.line_to_object(line, @separator, @scheme)
      new_docs << obj if obj.any?
    end

    new_docs
  end

  class << self
    def line_to_object(line, separator, scheme)
      result = {}
      line.to_s.split(separator).each_with_index do |col_val, idx|
        result[scheme[idx].to_sym] = col_val.strip  if scheme[idx]
      end
      result
    end
  end
end