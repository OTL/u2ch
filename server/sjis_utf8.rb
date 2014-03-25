# it is very difficult convert sjis -> utf8 in javascript.
# this server send http request and convert it to utf8

require 'net/http'
require 'sinatra'

get '/utf/*' do
  # i don't know whey, 'http://' is conveted to 'http:/' ???
  url = 'http://' + params[:splat][0].gsub(/http:\/+/, '')
  
  # if url then
  urlobj = URI.parse(url)
  req = Net::HTTP::Get.new(urlobj.path)
  res = Net::HTTP.start(urlobj.host, urlobj.port) {|http|
    http.request(req)
  }
  res.body.encode('utf-8', 'sjis', :invalid => :replace)
end
