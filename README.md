## Requirements:
- Docker
- Ruby (I was using ruby 2.6.2 when I wrote this, but I imagine it's pretty backward compatible.)
- Ruby driver gem for mongo (Installed in the build script)

## Build Instructions  
`git clone https://github.com/Jkettler/cirrus_music.git`

`cd cirrus_music`

You may need to run this with `sudo` depending on your environment: \
`[sudo] ./bin/build.sh` (wait for things to happen magically)  
 

## Usage

`./msearch [-ln] init` - Wait for ETL into from sources and build indexes.
I recommend running this with the `-n` (noisy) option at first so you see info about what's going on, 
and with `-l` (use local sources) since I have copies of the data in the project anyway (for better or worse).

`./msearch search` - Enter a Read, Evaluate, Print, Loop where you can search artist names. Type exit() or ctrl-C to stop

`./msearch` or `./msearch -h` will show you: 


```
./msearch.rb [-hln] [COMMAND]

** If this is your first time running this, make sure you've run the build script in /bin first! **
** Everything in this script assumes the build script completed successfully and mongo is running in a docker container **

Commands
   search: begin REPL mode to query artist info
   counts: show collection counts
   init: seed the database and build indexes
   clear-db: wipe the database (you probably shouldn't do this)

Options
    -h, --help                       help
    -l, --local                      use local files located in "cirrus_music/dumps/"
    -n, --noisy                      noisy
```