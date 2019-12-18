require_relative './parser'

class MsdArtistsParser < Parser

  REMOTE_URL = 'http://millionsongdataset.com/sites/default/files/AdditionalFiles/unique_artists.txt'.freeze

  def initialize(lines)
    @collection = :artists
    @separator = '<SEP>'
    @schema = [:artist_id, nil, nil, :artist_string]

    super(lines, @separator, @schema)
  end
end