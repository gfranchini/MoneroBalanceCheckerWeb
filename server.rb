require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'uri'

class Monero
  attr_reader(:url, :stats, :balance, :hash_rate, :price, :worth)

  def initialize
    @url = 'https://monerohash.com/api/stats_address?address=45f25xoWSUvPdvDXCQjmEv7ihEceXF6nsVeyNtbavtmFQPgoUAtnKpDgX5w4jHV9dLizRVXLEkuGwBnaTMjDFwq4NTwgkM4&longpoll=true'
    @stats = HTTParty.get(url)
    @balance = (@stats['stats']['balance'].to_f)/1000000000000
    @hash_rate = (@stats['stats']['hashrate'])
    price_stats = HTTParty.get('https://www.worldcoinindex.com/coin/monero')
    dom = Nokogiri::HTML(price_stats.body)
    price = dom.css('.coinprice')[0].text
    @price = price.gsub(/\r\n?/, "").delete(' ').tr('$','').to_f
    @worth = @price * @balance
  end
end

set(:bind, "0.0.0.0")

get("/") do
  a = Monero.new
  @balance = a.balance
  @worth = a.worth
  @hash_rate = a.hash_rate
  erb(:index)
end
