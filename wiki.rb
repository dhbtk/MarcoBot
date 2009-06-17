require 'net/http'
require 'rubygems'
require 'hpricot'
module Wiki
	# Returns the first paragraph of a MediaWiki wiki article
	def mediawiki_lookup(address,path,article, limit = 10)
		article = article.strip.gsub(" ","_")
		Net::HTTP.start(address,80) do |wiki|
			req = Net::HTTP::Get.new("#{path}#{article}")
			reply = wiki.request(req)
			case reply.message
				when "Moved Temporarily"
					mediawiki_lookup(address,path,article,limit-1)
				when "OK"
					# OK, we have an article
					art = Hpricot(reply.body)
					paragraph = art.at("p").to_s
					paragraph = paragraph.sub("<p>","").sub("</p>","").gsub("\n"," ").gsub("<b>",2.chr).gsub("</b>",2.chr).gsub(/<a(.+?)>/,0x1F.chr).gsub("</a>",0x1F.chr).gsub(/<(.+?)>/,"")
					# Splitting 'n stuff
					if paragraph.length >= 400 then
						split_paragraph = paragraph.scan(/.{1,400}/)
						return split_paragraph
					else
						return [paragraph]
					end
				else
					return ["Not Found"]
			end
		end
	end
	# Looks up an article on Wikipedia. Somewhat useful, although buggy
	def find_wiki(target,article,user)
		# Threading
		Thread.new do
			output = mediawiki_lookup("en.wikipedia.org","/wiki/",article)
			for item in output
				privmsg(target,item,2)
			end				
		end
	end
	def find_faidwiki(target,article,user)
		# Threads for safety
		Thread.new do
			output = mediawiki_lookup("faidwiki.niexs.net","/index.php/",article)
			for item in output
				privmsg(target,item,2)
			end
		end
	end
end
