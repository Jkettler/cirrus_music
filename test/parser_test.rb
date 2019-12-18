require "test/unit"
require_relative "../lib/parse/parser"
require_relative "../lib/parse/msd_artists_parser"
require_relative "../lib/parse/training_data_parser"

class TestParser < Test::Unit::TestCase

  TRACK_TEST_LINES = [
      "TRMMMYQ128F932D901<SEP>SOQMMHC12AB0180CB8<SEP>Faster Pussy cat<SEP>Silent Night",
      "TRMMMKD128F425225D<SEP>SOVFVAK12A8C1350D9<SEP>Karkkiautomaatti<SEP>Tanssi vaan",
      "TRMMMRX128F93187D9<SEP>SOGTUKN12AB017F4F1<SEP>Hudson Mohawke<SEP>No One Could Ever"
  ]



  TRAINING_TEST_LINES = [
    "# Please get involved with www.secondhandsongs.com, and enjoy this dataset!",
    "%72636,4253, My Sweet Lord",
    "TRPYNNL12903CAF506<SEP>ARXJJSN1187B98CB37<SEP>46770",
    "TRFYRVZ128F92EF998<SEP>ARNUFGE1187B9B7881<SEP>72636",
    "TRXAJXI128F4267A92<SEP>AR7K9W71187B9AF065<SEP>76190",
    "TRMONTS128F427FF78<SEP>ARHYUI71187FB48366<SEP>4253",
    "TRGSXCN128F9320D4B<SEP>ARZEAO01187B998042<SEP>130256",
    "%51981, These Things Will Keep Me Loving You",
    "TRTRNUX128F93297EF<SEP>AR31EL21187B98A723<SEP>51981",
    "TRKQBVB128C7196AED<SEP>AR8L6W21187B9AD317<SEP>51982"
  ]

  ARTISTS_TEST_LINES = [
    "AR002UA1187B9A637D<SEP>7752a11c-9d8b-4220-ac44-e4a04cc8471d<SEP>TRMUOZE12903CDF721<SEP>The Bristols",
    "AR003FB1187B994355<SEP>1dbd2d7b-64c8-46aa-9f47-ff589096d672<SEP>TRWDPFR128F93594A6<SEP>The Feds",
    "AR006821187FB5192B<SEP>94fc1228-7032-4fe6-a485-e122e5fbee65<SEP>TRMZLJF128F4269EAC<SEP>Stephen Varcoe/Choir of King's College_ Cambridge/Sir David Willcocks",
  ]

  #
  # def test_with_full_schema
  #   instance = Parser.new(TRACK_TEST_LINES, :tracks, '<SEP>', [:track_id, :song_id, :artist, :title])
  #   expected =
  #     [
  #       {:track_id=>"TRMMMYQ128F932D901", :song_id=>"SOQMMHC12AB0180CB8", :artist=>"Faster Pussy cat", :title=>"Silent Night"},
  #       {:track_id=>"TRMMMKD128F425225D", :song_id=>"SOVFVAK12A8C1350D9", :artist=>"Karkkiautomaatti", :title=>"Tanssi vaan"},
  #       {:track_id=>"TRMMMRX128F93187D9", :song_id=>"SOGTUKN12AB017F4F1", :artist=>"Hudson Mohawke", :title=>"No One Could Ever"}
  #     ]
  #   assert_equal(expected, instance.parsed_lines)
  # end
  #
  # def test_with_skipped_cols
  #   instance = Parser.new(TRACK_TEST_LINES, :tracks, '<SEP>', [:track_id, nil, :artist, :title])
  #   expected =
  #     [
  #       {:track_id=>"TRMMMYQ128F932D901", :artist=>"Faster Pussy cat" , :title=>"Silent Night"},
  #       {:track_id=>"TRMMMKD128F425225D", :artist=>"Karkkiautomaatti", :title=>"Tanssi vaan"},
  #       {:track_id=>"TRMMMRX128F93187D9", :artist=>"Hudson Mohawke", :title=>"No One Could Ever"}
  #     ]
  #
  #   assert_equal(expected, instance.parsed_lines)
  # end
  #
  # def test_with_artists
  #   instance = MsdArtistsParser.new(ARTISTS_TEST_LINES)
  #   expected =
  #       [
  #           {:artist_id=>"AR002UA1187B9A637D", :artist_string=>"The Bristols"},
  #           {:artist_id=>"AR003FB1187B994355", :artist_string=>"The Feds"},
  #           {:artist_id=>"AR006821187FB5192B", :artist_string=>"Stephen Varcoe/Choir of King's College_ Cambridge/Sir David Willcocks"}
  #       ]
  #   assert_equal(expected, instance.parsed_lines)
  # end
  #
  #
  def test_with_training_data_lines
    instance = TrainingDataParser.new(TRAINING_TEST_LINES)
    expected = []
    assert_equal(expected, instance.parse)
  end

  # def test_with_ignore_lines
  #   lines = [
  #     "#comment<SEP>comment",
  #     "#comment",
  #     " # comment",
  #     " #comment",
  #     "       #   comment"
  #   ]
  #   options = {
  #     ignore: '#',
  #     header_sym: '%',
  #     header_separator: ',',
  #     header_schema: [nil, nil, :title_string]
  #   }
  #   instance = Parser.new(lines, :comments, '<SEP>', [:blah, :blah2], options)
  #   assert_equal([], instance.parsed_lines)
  # end

end
