require 'pp'

module REPL

  INITIAL_PROMPT = "Enter a band or artist to search >> ".freeze
  SPECIFY_PROMPT = "Enter a number to specify artist >> ".freeze

  def self.find_and_display_results(artist)
    originals = Track.find_all_by_artist(artist[:artist_string])
    puts "Songs by #{artist[:artist_string]}: \n"
    puts "\n"
    pp originals.uniq
  end

  def self.handle_search_input(input)
    artists = Artist.search_artists(input)
    result_artist = nil

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
        result_artist = artists[choice - 1]
      else
        puts "This is why we can't have nice things."
        return
      end

    elsif artists.length == 1
      result_artist = artists[0]
    else
      puts "Your search was bad and you should feel bad (No results)."
    end
    find_and_display_results(result_artist) if result_artist
    true
  end
end