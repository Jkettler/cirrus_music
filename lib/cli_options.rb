require 'optparse'

@options = {}

@opts_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: ./msearch.rb [-hln] [COMMAND]'
  opt.separator ''
  opt.separator '** If this is your first time running this, make sure you\'ve run the build script in /bin first! **'
  opt.separator '** Everything in this script assumes the build script completed successfully and mongo is running in a docker container **'
  opt.separator ''
  opt.separator 'Commands'
  opt.separator '   search: begin REPL mode to query artist info'
  opt.separator '   counts: show collection counts'
  opt.separator '   init: seed the database and build indexes'
  opt.separator '   clear-db: wipe the database (you probably shouldn\'t do this)'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-h', '--help', 'help') do
    puts @opts_parser
  end

  opt.on('-l', '--local', 'use local files located in "cirrus_music/dumps/"') do
    @options[:local] = true
  end

  opt.on('-n', '--noisy', 'noisy') do
    @options[:noisy] = true
  end
end

@opts_parser.parse!