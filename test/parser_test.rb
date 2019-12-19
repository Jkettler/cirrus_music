require "test/unit"
require_relative "../lib/parse/parser"
require_relative "../lib/parse/msd_artists_parser"
require_relative "../lib/parse/training_data_parser"

class TestParser < Test::Unit::TestCase


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
