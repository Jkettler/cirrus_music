
#!/usr/bin/ruby

require 'mongo'
require_relative '../lib/connection'

conn = Connection.new

conn.artists.drop
conn.cliques.drop
conn.tracks.drop