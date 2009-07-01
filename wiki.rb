require 'net/http'
require 'rubygems'
require 'hpricot'
require 'open-uri'
module Wiki
	# Returns the first paragraph of a MediaWiki wiki article
	def mediawiki_lookup(address,path,article, limit = 10)
		if limit > 0 then
			puts "LOOKING UP MEDIAWIKI ARTICLE"
			puts "address+path: #{address}#{path}"
			article = article.strip.gsub(" ","_")
			puts "Article: #{article}"
					
			Net::HTTP.start(address,80) do |wiki|
				puts "Requesting..."
				req = Net::HTTP::Get.new("#{path}#{article}")
				reply = wiki.request(req)
				puts "Wiki reply messsage: #{reply.message}"
				case reply.message
					when "Moved Temporarily"
						mediawiki_lookup(address,path,reply.header['location'].sub(/(.+?)\:\/\//,"").sub(address+path,""),limit-1)
					when "Moved Permanently"
						mediawiki_lookup(address,path,reply.header['location'].sub(/(.+?)\:\/\//,"").sub(address+path,""),limit-1)
					when "OK"
						# OK, we have an article
						artpath = address+path+article
						art = Hpricot(reply.body)
						paragraph = art.at("p").to_s	
						puts "Paragraph:"
						puts paragraph
						puts "Stripped paragraph:"
						paragraph = paragraph.sub("<p>","").sub("</p>","").gsub("\n"," ").gsub("<b>",2.chr).gsub("</b>",2.chr).gsub(/<a(.+?)>/,0x1F.chr).gsub("</a>",0x1F.chr).gsub(/<(.+?)>/,"")
						puts paragraph
						if paragraph[-1..-1] == ":" then
							puts "Is list! Lists:"
							lists = art.search("li").to_a
							puts lists.join(", ")
							if lists.count <7 then
								puts "List is <7! Adding it all."
								paragraph = paragraph + lists.join("; ")
							else
								puts "List is longer than 7! Adding the first 7."
								i = 0
								while i <= 6
									puts "Added list: #{lists[i]}"
									paragraph = paragraph + "; " + lists[i].to_s
									puts "Added paragraph"
									i = i + 1
									puts "incremented counter"
									
								end
							end
							paragraph = paragraph + "."
							puts "Result:"
							puts paragraph
						elsif paragraph.start_with?("#{0x1F.chr}Coordinates#{0x1F.chr}:") then
							paragraph = art.search("p").to_a[1].to_s
						end
						paragraph = paragraph.sub("<p>","").sub("</p>","").gsub("\n"," ").gsub("<b>",2.chr).gsub("</b>",2.chr).gsub(/<a(.+?)>/,0x1F.chr).gsub("</a>",0x1F.chr).gsub(/<(.+?)>/,"")
						# Splitting 'n stuff
						if paragraph.length >= 400 then
							split_paragraph = paragraph.scan(/.{1,400}/)
							return ["Article: http://#{artpath}"] + split_paragraph
						else
							return ["Article: http://#{artpath}"] + [paragraph]
						end
					else
						return ["Not Found"]
				end
			end
		else
			return ['Redirect loop detected, aborting']
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
	
	def search_wiki(target,article,wiki)
		doc = Hpricot(open("http://www.google.com/search?q=site:#{wiki}+#{article.gsub(" ","+")}"))
		address = doc.at("li.g a")
		if address != nil then
			address = address['href']
			address = address.sub(/(.+?)\:\/\//,"")
			site = address.split("/")[0]
			path = address.sub(address.split("/")[0],"").sub(address.split("/")[-1],"")
				if path[-1].chr != "/" then path = path + "/"; end
			article = address.split("/")[-1]
			
			wiki = mediawiki_lookup(site,path,article)
			
			for item in wiki
				privmsg(target,item,2)
			end
		else
			privmsg(target,"Not found. Search harder.")
		end
	end	
end
