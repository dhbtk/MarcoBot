require 'rubygems'
require 'hpricot'
require 'net/http'
require 'open-uri'
module Urbandict
	def urbandict_lookup(stuff)
		page = Hpricot(open("http://www.urbandictionary.com/define.php?term=#{stuff.gsub(" ","+")}"))
		definition = page.at("div.definition").inner_html.to_s.gsub("<br />","").gsub("<b>",2.chr).gsub("</b>",2.chr).gsub(/<a(.+?)>/,0x1F.chr).gsub("</a>",0x1F.chr).gsub(/<(.+?)>/,"").gsub("\n"," ").gsub("\r"," ").strip.gsub("&quot;","\"")
		puts "definition: #{definition}"
		return [definition]
	end
end
if __FILE__ == $0 then
	include Urbandict
	puts urbandict_lookup(ARGV[0])
end
