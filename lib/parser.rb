module Parser

  # Params:
  # lines:: An array of lines to parse
  # scheme:: A simple DSL for describing how to parse and translate raw lines from a file (see below).
  # delimiter:: A string to split file lines on.
  #
  # scheme details:
  # Its structure is an array where each index represents a 'column' from that line of the input file.
  # If scheme is nil at a particular index, the o.g. column data is simply not included in the result.
  # Otherwise, the value becomes the new mongo key.
  #
  # Example:
  # Parsing a line of text "dog, cat, horse" with scheme = [:best, :ok, nil], the result is { best: 'dog', ok: 'cat' } (leading/trailing spaces are stripped)
  # The value at scheme[0] becomes the key under which the content of "dog, cat, horse".split(',')[0].strip will be stored in mongo.
  #

  def parse(lines, scheme, delimiter)
    new_docs = []

    lines.each do |line|
      obj = line_to_object(line.strip, delimiter, scheme)
      new_docs << obj if obj.any?
    end

    new_docs
  end

  def line_to_object(line, separator, scheme)
    result = {}
    line.to_s.split(separator).each_with_index do |col_val, idx|
      result[scheme[idx].to_sym] = col_val.strip  if scheme[idx]
    end
    result
  end
end