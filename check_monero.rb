require 'httparty'
require 'nokogiri'
require 'tty-spinner'
require 'sinatra'
require 'uri'

url = 'https://monerohash.com/api/stats_address?address=45f25xoWSUvPdvDXCQjmEv7ihEceXF6nsVeyNtbavtmFQPgoUAtnKpDgX5w4jHV9dLizRVXLEkuGwBnaTMjDFwq4NTwgkM4&longpoll=true'
stats = HTTParty.get(url)
#Setting variables.
balance = (stats['stats']['balance'].to_f)/1000000000000
hash_rate=(stats['stats']['hashrate'])
#Getting current price of Monero by parsing worldcoinindex website.
price_stats = HTTParty.get('https://www.worldcoinindex.com/coin/monero')
dom = Nokogiri::HTML(price_stats.body)
price = dom.css('.coinprice')[0].text
price = price.gsub(/\r\n?/, "").delete(' ').tr('$','').to_f
pending_balance = price * balance

set(:bind, "0.0.0.0")

get("/") do
  @balance = "#{balance}"
  @pending_balance = "#{pending_balance}"
  @hash_rate = "#{hash_rate}"
  erb(:index)
end
