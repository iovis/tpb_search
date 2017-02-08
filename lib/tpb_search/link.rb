require 'cgi'
require 'httparty'

module TpbSearch
  ##
  # Object that contains the info for a torrent file
  class Link
    attr_reader :filename, :size, :magnet, :seeders, :leechers

    def initialize(filename: nil, size: nil, magnet: nil, seeders: nil, leechers: nil)
      @filename = filename
      @size = size
      @magnet = magnet
      @seeders = seeders.tr(',', '').to_i
      @leechers = leechers.tr(',', '').to_i
    end

    def <=>(other)
      @seeders <=> other.seeders
    end

    def to_s
      "#{@filename} (#{@size}) - [#{@seeders.to_s.green}/#{@leechers.to_s.red}]"
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    private

    def extract_hash
      # Extract magnet properties to a Hash and then parse the sha1 info hash
      raw_hash = magnet[/(xt.*?)&/, 1]  # extract the xt property
      raw_hash.split(':').last.downcase
    end
  end
end
