#!/usr/bin/env ruby

require 'open-uri'
require 'mongo'
require_relative './lib/connection'
require_relative './lib/cli_options'
Dir[File.join(__dir__, 'lib', 'parse', '*.rb')].each { |file| require_relative file }


MONGO_INSERT_LIMIT = 100_000
@connection = Connection.new


# TODO for v2: benchmark multithreading to see if it's beneficial
def import_artists
  threads = []
  artists = @connection.artists

  begin
    open(File.join('.','dumps', 'unique_artists.txt')) do |file|
      file.each_slice(MONGO_INSERT_LIMIT) do |lotta_lines|
        threads << Thread.new {
          result = artists.insert_many(MsdArtistsParser.new(lotta_lines).parse)
          puts "inserted #{result.inserted_count} docs into :artists collection"
        }
      end
    end
    threads.each(&:join)
  rescue OpenURI::HTTPError => e
    return @options[:noisy] ? e : nil
  end
end

def import_cliques
  threads = []
  cliques = @connection.cliques
  header_sym = '%'
  comment_sym = '#'
  chunk_size = 100

  begin
    open(File.join('.','dumps', 'cliques.txt')) do |file|
      lines = []
      clique_chunk = []
      file.each_line do |line|
        line.strip!
        first_char = line[0]

        next if first_char.nil?
        next if first_char == comment_sym

        if (first_char == header_sym) && lines.any?
          clique_chunk << {performances: TrainingDataParser.new(lines.slice(1, lines.length)).parse}
          lines = [line]
        else
          lines << line
        end

        if (clique_chunk.length >= chunk_size) || file.eof?
          threads << Thread.new {
            result = cliques.insert_many(clique_chunk)
            puts "inserted #{result.inserted_count} docs into :cliques collection (chunk size: #{clique_chunk})" if @options[:noisy]
          }
          clique_chunk = []
        end
      end
    end
    threads.each(&:join)
  rescue OpenURI::HTTPError => e
    return @options[:noisy] ? e : nil
  end

end

def import_tracks

end

def create_indexes
  artists = @connection.artists
  cliques = @connection.cliques

  artists.indexes.create_many(
    [
      { :key => { artist_string: 1 }},
      { :key => { artist_id: 1 }},
    ])

  cliques.indexes.create_many(
    [
      { :key => { artist_id: 1 }},
      { :key => { track_id: 1 }}
    ]
  )
end

case ARGV[0]
when nil
  # puts @opts_parser
  import_cliques
when 'init'
  create_indexes
when 'tracks'
  import_tracks
when 'artists'
  import_artists
when 'cliques'
  import_cliques
else

end


# db.cliques.find({"performances": {"track_id": "TRWFVNB12903CAAACF", "artist_id": "ARODTXM1187B9B7855"}})
# db.cliques.find({"performances.artist_id": {"$eq": "ARODTXM1187B9B7855"}})