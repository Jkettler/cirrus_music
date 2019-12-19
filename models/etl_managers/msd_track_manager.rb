

class MSDTrackManager < ETLManager
  include Parser

  TRACKS_LOCAL = File.join('.','dumps', 'unique_tracks.txt')
  TRACKS_REMOTE = "http://millionsongdataset.com/sites/default/files/AdditionalFiles/unique_tracks.txt"

  def initialize(local = false)

    scheme = [:track_id, nil, :artist_string, :track_title]
    location = local ? TRACKS_LOCAL : TRACKS_REMOTE

    super(:tracks, location, scheme)
  end
end