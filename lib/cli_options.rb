require 'optparse'

@options = {}

@opts_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: msearch.rb [-options] [ARTIST]'
  opt.separator ''
  opt.separator 'Commands'
  opt.separator '   ARTIST: provide a first, last, or group name to search'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-h', '--help', 'help') do
    puts opt_parser
  end

  opt.on('-n', '--noisy', 'noisy') do
    @options[:noisy] = true
  end

  opt.on('-i', '--init', 'initialize/pull data from sources and import into db') do
    @options[:init] = true
  end
end

@opts_parser.parse!