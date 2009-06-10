require "net/http"
require 'rubygems'
require 'hpricot'
module Lyrics
	def get_lyrics(band,song)
		band=band.downcase.strip.gsub(" ","-")
		song=song.downcase.strip.gsub(" ","-").gsub(/(\,|\!|\?|\"|\.|\')/,"")
		puts band
		puts song
		Net::HTTP.start("vagalume.uol.com.br",80) do |http|
			req = Net::HTTP::Get.new("/#{band}/#{song}.html")
			$request = http.request(req)
		end
		if $request.message == "Not Found" then
			return "Not found"
		elsif $request.message == "OK" then
			doc = Hpricot($request.body)
			lyrics = doc.search("div.tab_original").to_s
			lyrics = lyrics.gsub("<br />","").gsub(/<(.+?)>/,"")
			newstanzas = []
			stanzas = lyrics.split("\n\n")
			for stanza in stanzas
				newstanzas.push stanza.split("\n").join(" / ")
			end
			return newstanzas
		end
	end
end
#include Lyrics
#get_lyrics(ARGV[0],ARGV[1])
