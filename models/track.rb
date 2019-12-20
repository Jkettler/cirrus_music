class Track
  @client ||= Connection.new

  def self.collection_size
    @client.tracks.count
  end

  def self.find_all_by_track(track_ids)
    @client.tracks.find(track_id: { '$in' => track_ids}).map{|t| t[:track_title]}
  end

  def self.find_all_by_artist(name)
    @client.tracks.find({
      '$text' =>
        { '$search' => "\"#{name}\"", '$caseSensitive' => false }
      }).map{|t| t[:track_title]}
  end
end