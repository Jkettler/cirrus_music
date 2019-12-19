#!/usr/bin/env ruby

require 'mongo'
require_relative './lib/connection'
require_relative './lib/cli_options' # defines @options object used throughout
Dir[File.join(__dir__, 'models', 'etl_managers', '*.rb')].each { |file| require_relative file }

@connection = Connection.new

def create_indexes
  artists = @connection.artists
  cliques = @connection.cliques
  tracks = @connection.tracks

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
  tracks.indexes.create_many(
    [
      { :key => { artist_string: 1 }},
      { :key => { track_title: 1 }},
      { :key => { track_id: 1 }}
    ]
  )
end

def init_all
  threads = []
  threads << Thread.new do
    puts "populating tracks, local: #{@options[:local]}"
    MSDTrackManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
    puts "finished populating tracks"
  end
  threads << Thread.new do
    puts "populating artists, local: #{@options[:local]}"
    MSDArtistManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
    puts "finished populating artists"
  end
  threads << Thread.new do
    puts "populating cliques, local: #{@options[:local]}"
    TrainingDataManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
    puts "finished populating cliques"
  end
  threads.each(&:join)
end

case ARGV[0]
when nil
  puts @opts_parser
when 'destroy-db-data'
  @connection.artists.drop
  @connection.cliques.drop
  @connection.tracks.drop
when 'create-indexes'
  create_indexes
when 'create-tracks'
  MSDTrackManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
when 'create-artists'
  puts "populating artists, local: #{@options[:local]}"
  MSDArtistManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
when 'create-cliques'
  TrainingDataManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
when 'init'
  init_all
  # create_indexes
else

end


# db.cliques.find({"performances": {"track_id": "TRWFVNB12903CAAACF", "artist_id": "ARODTXM1187B9B7855"}})
# db.cliques.find({"performances.artist_id": {"$eq": "ARODTXM1187B9B7855"}})
