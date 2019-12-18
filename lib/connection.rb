require 'mongo'

class Connection

  def initialize
    # set logger level to FATAL (only show serious errors)
    Mongo::Logger.logger.level = ::Logger::FATAL

    # set up a connection to the mongod instance which is running in a docker container, but with ports mapped
    # such that it appears to be running locally on the default port 27017
    @client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'cirrus-music')
  end

  def client
    @client
  end

  def artists
    @client[:artists]
  end

  def tracks
    @client[:tracks]
  end

  def cliques
    @client[:cliques]
  end

end