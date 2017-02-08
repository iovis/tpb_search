require 'erb'
require 'open-uri'
require 'nokogiri'
require 'yaml'

module TpbSearch
  ##
  # Extract a list of results from your search
  # TpbSearch::Search.new("Suits s05e16")
  class Search
    NUMBER_OF_LINKS = 5
    BASE_URL = 'https://thepiratebay.org'.freeze

    attr_accessor :url

    def initialize(search)
      @url = "#{BASE_URL}/search/#{ERB::Util.url_encode(search)}/0/7/200"
    end

    def results_found?
      @results_found ||= page.at(':contains("No hits. Try adding an asterisk in you search phrase.")').nil?
    rescue OpenURI::HTTPError
      @results_found = false
    end

    def links
      @links ||= generate_links
    end

    private

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def generate_links
      links = []
      return links unless results_found?

      link_nodes = page.css('#searchResult tr:not(.header)')
      link_nodes.each { |link| links << crawl_link(link) }

      links.first(NUMBER_OF_LINKS)
    end

    def crawl_link(link)
      cells = link.css('td')

      Link.new(
        filename: cells[1].at('a').text,
        size: cells[1].at('.detDesc').text[/\d+\.\d+ MiB|GiB/],
        magnet: cells[1].at('a[href^=magnet]')['href'],
        seeders: cells[2].text,
        leechers: cells[3].text
      )
    end
  end
end
