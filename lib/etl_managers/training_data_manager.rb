
class TrainingDataManager < ETLManager

  REMOTE = 'https://raw.githubusercontent.com/tbertinmahieux/MSongsDB/master/Tasks_Demos/CoverSongs/shs_dataset_train.txt'.freeze
  LOCAL = File.join('.','dumps', 'cliques.txt')

  attr_reader :slice_token, :comment_token

  def initialize(local = false)
    @slice_token = "%"
    @comment_token = "#"
    scheme = [:track_id, :artist_id, nil]
    location = local ? LOCAL : REMOTE

    super(:cliques, location, scheme)
  end

  def threaded_etl(connection, noisy = false)
    queue = Queue.new
    collection = connection.send(self.collection)
    count = 0

    Thread.abort_on_exception = true

    begin
      open(self.file_location) do |file|
        file.set_encoding(Encoding.default_external)
        lines = []
        clique_chunk = []
        file.each_line do |line|
          line.strip!
          first_char = line[0]

          next if (first_char.nil? || first_char == self.comment_token)

          if (first_char == self.slice_token) && lines.any?
            count += 1
            clique_chunk << {performances: parse(lines.slice(1, lines.length), self.scheme, self.delimiter)}
            lines = [line]
          else
            lines << line
          end

          if file.eof?
            queue << clique_chunk
          end
        end
      end

      thread = Thread.new do
        while e = queue.deq # wait for nil to break loop
          Thread::exit if e.nil?
          result = collection.insert_many(e)
          puts "inserted #{result.inserted_count} #{self.collection} into the db" if noisy
        end
      end
      queue.close
      thread.join
    rescue Exception => e
      return noisy ? e : nil
    end
  end
end