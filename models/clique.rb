class Clique
  @client ||= Connection.new

  def self.collection_size
    @client.cliques.count
  end

  def self.find_clique_tracks(artist_id)
    results = Set.new

    @client.cliques.find(
      {'performances.artist_id' =>
        {'$eq' => artist_id }
      }, projection: {'performances.track_id' => 1, _id: 0}
    ).each do |result|
      result[:performances].each do |perf|
        # puts "pushing: #{perf["track_id"]}"
        results.add(perf["track_id"])
      end
    end
    results.to_a
  end
end