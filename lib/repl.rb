require 'pp'

module REPL

  INITIAL_PROMPT = "Enter a band or artist to search >> ".freeze
  SPECIFY_PROMPT = "Enter a number to specify artist >> ".freeze

  def self.handle_search_input(input)
    artists = Artist.search_artists(input)

    if artists.length > 1
      puts "\n"
      puts "Found #{artists.length} results for '#{input}'"

      artists.each_with_index do |artist, idx|
        puts "#{idx + 1}. #{artist[:artist_string]}"
      end
      puts "\n"
      puts SPECIFY_PROMPT

      choice = $stdin.gets.chomp!.to_i

      if (choice > 0) && (choice <= artists.length)
        artist = artists[choice - 1]
        originals = Track.find_all_by_artist(artist[:artist_string])
        puts "Songs by #{artist[:artist_string]}: \n"
        pp originals.uniq
      else
        puts "This is why we can't have nice things."
        return false
      end

    elsif artists.length == 1
      artist = artists[0]
      originals = Track.find_all_by_artist(artist[:artist_string])
      puts "Songs by #{artist[:artist_string]}: \n"
      puts "\n"
      pp originals.uniq
    else
      puts "Your search was bad and you should feel bad (No results)."
    end
    true
  end
end