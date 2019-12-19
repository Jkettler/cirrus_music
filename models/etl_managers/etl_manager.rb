require_relative "../../lib/parser"
require 'open-uri'

##
# Manages the Extract, Translate, Load process for a data source


class ETLManager


  include Parser

  DEFAULT_DELIMITER = '<SEP>'.freeze
  MONGO_MAX_INSERT_SIZE = 100_000
  RESCUES = [OpenURI::HTTPError]

  # Params:
  # +collection+:: Mongo collection this parsed data will belong to
  # +file_location+:: URL or directory where this data originates from
  # +separator+:: Delimiter to split file lines on.
  # +scheme+:: A simple DSL for describing how to parse and translate raw lines from a file (see module Parser for detailed explanation)
  # +skip_symbols+:: Skip lines that begin with a symbol in this array
  #
  attr_reader :collection, :file_location, :delimiter, :slice, :scheme, :skip_symbols

  def initialize(collection, file_location, scheme, skip_symbols = [], slice = MONGO_MAX_INSERT_SIZE, delimiter = DEFAULT_DELIMITER)
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
        file.each_slice(self.slice) do |lotta_lines|
          threads << Thread.new {
            result = collection.insert_many(parse(lotta_lines, self.scheme, self.delimiter))
            puts "inserted #{result.inserted_count} #{self.collection} into db" if noisy
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