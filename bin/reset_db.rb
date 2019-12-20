#!/usr/bin/env ruby

require 'mongo'
require_relative '../lib/connection'

conn = Connection.new

conn.artists.drop
conn.tracks.drop