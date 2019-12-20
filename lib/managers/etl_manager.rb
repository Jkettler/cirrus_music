require_relative "../../lib/parser"
require 'open-uri'

##
# Manages the Extract, Translate, Load process for a data source

class ETLManager

  include Parser

  DEFAULT_DELIMITER = '<SEP>'.freeze
  RESCUES = [OpenURI::HTTPError, Errno::ENOENT]

  # Params:
  # +collection+:: Mongo collection this parsed data will belong to
  # +file_location+:: URL or directory where this data originates from
  # +separator+:: Delimiter to split file lines on.
  # +scheme+:: A simple DSL for describing how to parse and translate raw lines from a file (see module Parser for detailed explanation)
  #
  attr_reader :collection, :file_location, :delimiter, :slice, :scheme

  def initialize(collection, file_location, scheme, slice = 10_000, delimiter = DEFAULT_DELIMITER)
    @collection = collection
    @file_location = file_location
    @scheme = scheme
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
            result = collection.insert_many(parse(lotta_lines, self.scheme, self.delimiter), ordered: false)
            puts "inserted #{result.inserted_count} #{self.collection} into db" if noisy
          }
        end
      end
      threads.each(&:join)
    rescue *RESCUES => e
      puts "Error: #{e}"
    end

    threads.each(&:join)
  end

end