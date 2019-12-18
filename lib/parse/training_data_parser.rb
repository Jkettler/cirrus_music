require_relative './parser'

class TrainingDataParser < Parser

  REMOTE_URL = 'https://raw.githubusercontent.com/tbertinmahieux/MSongsDB/master/Tasks_Demos/CoverSongs/shs_dataset_train.txt'.freeze

  def initialize(lines)
    @separator = '<SEP>'
    @schema = [:track_id, :artist_id, nil]

    super(lines, @separator, @schema, @options)
  end
end