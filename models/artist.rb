class Artist
  @client ||= Connection.new

  def self.collection_size
    @client.artists.count
  end

  def self.search_artists(str)
    @client.artists.find(
      { '$text' =>
        { '$search' => "\"#{str}\"", '$caseSensitive' => false }
      }
    ).to_a.uniq
  end
end