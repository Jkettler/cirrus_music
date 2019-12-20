
class MSDArtistManager < ETLManager

  ARTISTS_LOCAL = File.join('.','dumps', 'unique_artists.txt')
  ARTISTS_REMOTE = "http://millionsongdataset.com/sites/default/files/AdditionalFiles/unique_artists.txt"

  def initialize(local = false)

    scheme = [:artist_id, nil, nil, :artist_string]
    location = local ? ARTISTS_LOCAL : ARTISTS_REMOTE

    super(:artists, location, scheme, 10_000)
  end
end