##Prereqs:
- Docker
- I was using ruby 2.6.2 when I wrote this, but I imagine it's pretty backward compatible.

##Build Instructions  
Run the build script `./bin/build.sh`

##Usage

```
msearch.rb [-hln] [COMMAND]

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
