require "test/unit"
require_relative "../lib/parser"
require_relative "../lib/managers/msd_artist_manager"
require_relative "../lib/managers/msd_track_manager"

ARTISTS_TEST_LINES = [
  "AR002UA1187B9A637D<SEP>7752a11c-9d8b-4220-ac44-e4a04cc8471d<SEP>TRMUOZE12903CDF721<SEP>The Bristols",
  "AR003FB1187B994355<SEP>1dbd2d7b-64c8-46aa-9f47-ff589096d672<SEP>TRWDPFR128F93594A6<SEP>The Feds",
  "AR006821187FB5192B<SEP>94fc1228-7032-4fe6-a485-e122e5fbee65<SEP>TRMZLJF128F4269EAC<SEP>Stephen Varcoe/Choir of King's College_ Cambridge/Sir David Willcocks"
]

TRACK_TEST_LINES = [
  "TRMMMYQ128F932D901<SEP>SOQMMHC12AB0180CB8<SEP>Faster Pussy cat<SEP>Silent Night",
  "TRMMMKD128F425225D<SEP>SOVFVAK12A8C1350D9<SEP>Karkkiautomaatti<SEP>Tanssi vaan",
  "TRMMMRX128F93187D9<SEP>SOGTUKN12AB017F4F1<SEP>Hudson Mohawke<SEP>No One Could Ever"
]

class TestParser < Test::Unit::TestCase
  include Parser

  def test_with_tracks
    manager = MSDTrackManager.new
    parsed = parse(TRACK_TEST_LINES, manager.scheme, manager.delimiter)
    expected =
      [
        {:track_id=>"TRMMMYQ128F932D901", :artist_string=>"Faster Pussy cat", :track_title=>"Silent Night"},
        {:track_id=>"TRMMMKD128F425225D", :artist_string=>"Karkkiautomaatti", :track_title=>"Tanssi vaan"},
        {:track_id=>"TRMMMRX128F93187D9", :artist_string=>"Hudson Mohawke", :track_title=>"No One Could Ever"}
      ]
    assert_equal(expected, parsed)
  end

  def test_with_artists
    manager = MSDArtistManager.new
    parsed = parse(ARTISTS_TEST_LINES, manager.scheme, manager.delimiter)
    expected =
      [
        {:artist_id=>"AR002UA1187B9A637D", :artist_string=>"The Bristols"},
        {:artist_id=>"AR003FB1187B994355", :artist_string=>"The Feds"},
        {:artist_id=>"AR006821187FB5192B", :artist_string=>"Stephen Varcoe/Choir of King's College_ Cambridge/Sir David Willcocks"}
      ]
    assert_equal(expected, parsed)
  end

end
