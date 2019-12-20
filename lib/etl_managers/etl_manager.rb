require_relative "../../lib/parser"
require 'open-uri'

##
# Manages the Extract, Translate, Load process for a data source


class ETLManager

  include Parser

  DEFAULT_DELIMITER = '<SEP>'.freeze
  RESCUES = [OpenURI::HTTPError]

  # Params:
  # +collection+:: Mongo collection this parsed data will belong to
  # +file_location+:: URL or directory where this data originates from
  # +separator+:: Delimiter to split file lines on.
  # +scheme+:: A simple DSL for describing how to parse and translate raw lines from a file (see module Parser for detailed explanation)
  # +skip_symbols+:: Skip lines that begin with a symbol in this array
  #
  attr_reader :collection, :file_location, :delimiter, :slice, :scheme, :skip_symbols

  def initialize(collection, file_location, scheme, slice = 10_000, delimiter = DEFAULT_DELIMITER)
    @collection = collection
    @file_location = file_location
    @scheme = scheme
    @skip_symbols = skip_symbols
    @slice = slice
    @delimiter = delimiter
  end

  def threaded_etl(connection, noisy = false)
    threads = []
    collection = connection.send(self.collection)

    begin
      open(self.file_location) do |file|
        file.set_encoding(Encoding.default_external)
        file.each_slice(self.slice) do |lotta_lines|
          threads << Thread.new {
            begin
              parsed = parse(lotta_lines, self.scheme, self.delimiter)
              result = collection.insert_many(parsed, ordered: false)
              puts "inserted #{result.inserted_count} #{self.collection} into db" if noisy
            rescue Encoding::UndefinedConversionError => e
              puts "#{e}"
            end
          }
        end
      end
      threads.each(&:join)
    rescue *RESCUES => e
      return noisy ? e : nil
    end

    threads.each(&:join)
  end

end