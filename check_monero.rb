require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'tty-spinner'
require 'uri'

#Pulling data from API
spinner = TTY::Spinner.new("[:spinner] Gathering data ...", format: :classic)
url = 'https://monerohash.com/api/stats_address?address=45f25xoWSUvPdvDXCQjmEv7ihEceXF6nsVeyNtbavtmFQPgoUAtnKpDgX5w4jHV9dLizRVXLEkuGwBnaTMjDFwq4NTwgkM4&longpoll=true'
stats = nil
spinner.run('Done!') do
  stats = HTTParty.get(url)
end
#Setting variables.
balance = (stats['stats']['balance'].to_f)/1000000000000
hash_rate=(stats['stats']['hashrate'])
#Getting current price of Monero by parsing worldcoinindex website.
price_stats = HTTParty.get('https://www.worldcoinindex.com/coin/monero')
dom = Nokogiri::HTML(price_stats.body)
price = dom.css('.coinprice')[0].text
price = price.gsub(/\r\n?/, "").delete(' ').tr('$','').to_f
pending_balance = price * balance
payments = (stats['payments'][0].split(":").map(&:strip)[1].to_f)/1000000000000



set(:bind, "0.0.0.0")

get("/") do
  @balance = "#{balance}"
  @pending_balance = "#{pending_balance}"
  @hash_rate = "#{hash_rate}"
  @payments = "#{payments}"
  erb(:index)
end
