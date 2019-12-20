#!/usr/bin/env ruby

require 'mongo'
require 'pp'

Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'lib', 'etl_managers', '*.rb')].each { |file| require_relative file }
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require_relative file }

@connection = Connection.new

def create_indexes
  artists = @connection.artists
  tracks = @connection.tracks

  artists.indexes.create_many(
    [
      { :key => { artist_string: 'text'}},
      { :key => { artist_id: 1 }},
    ])

  tracks.indexes.create_many(
    [
      { :key => { "$**" => "text" }},
      { :key => { track_id: 1 }}
    ]
  )
end

def init_all
  threads = []

  if Artist.collection_size == 0
    threads << Thread.new do
      MSDArtistManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
      puts "Finished populating artists"
    end
  else
    puts "Artists exist already! Skipping..."
  end

  if Track.collection_size == 0
    threads << Thread.new do
      puts "Importing tracks. This one takes a minute..."
      MSDTrackManager.new(@options[:local]).threaded_etl(@connection, @options[:noisy])
      puts "Finished populating tracks"
    end
  else
    puts "Tracks exist already! Skipping..."
  end
  threads.each(&:join)
end

def clear_database
  [:artists, :tracks].each do |model|
    @connection.send(model).drop
  end
end

def model_etl(model)
  model.send(:new, @options[:local]).threaded_etl(@connection, @options[:noisy])
end


case ARGV[0]
when nil
  puts @opts_parser

when 'counts'
  puts "Artists: #{Artist.collection_size}"
  puts "Tracks: #{Track.collection_size}"

when 'clear-db'
  puts "I hope you know what you're doing.."
  clear_database

when 'init'
  init_all
  puts "Creating indexes..."
  create_indexes
  puts "Done!"

when 'search'

  repl = -> prompt do
    print prompt
    input = $stdin.gets.chomp!
    if input == "exit()"
      return nil
    else
      REPL.handle_search_input(input)
    end
  end

  loop do
    res = repl[REPL::INITIAL_PROMPT]
    if res.nil?
      puts "Goodbye!"
      break
    end
  end
end
