module Wiki
	def find_wiki(target,article,user)
		# Threading
		Thread.new do
		# cocks cocks cocks
		puts article
#		article[0..0] = article[0..0].upcase
		wiki = Net::HTTP.new("en.wikipedia.org",80)
		wiki.read_timeout= 10
		article[0..0] = article[0..0].upcase
		article = article.gsub(" ","_")
		reply = wiki.get("/wiki/#{article}",nil)
		puts reply.message
		if reply.message == "Moved Temporarily" then
			article = reply.header["location"].sub("http://en.wikipedia.org","")
#			reply = wiki.get(article,nil)
			article = article.gsub(" ","_").sub("/wiki/")
			puts article
			reply = wiki.get("/wiki/#{article}",nil)
			privmsg(target,"Article: #{2.chr}#{article.sub("/wiki/","").gsub("_"," ")}#{2.chr}",2)
		end
		puts reply.message
		if reply.message != "OK" then
			privmsg(target,"No Such Article, Try Again",2)
		else
			outgoing = reply.body.scan(/\<\p\>(.+?)\<\/p\>$/i).uniq[0][0]
#			outgoing = outgoing.gsub("<b>","").gsub("</b>","")
#			outgoing = outgoing.gsub("<i>","").gsub("</i>","")
#			outgoing = outgoing.gsub(/\s(.+?)=\"(.+?)\"/,"").gsub(/(>+)/,">") #Doesn't work
#			puts outgoing
			outgoing = outgoing.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
			outgoing = outgoing.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
#			outgoing = outgoing.gsub("<a>",0x1F.chr.to_s).gsub("</a>",0x1F.chr.to_s) # Doesn't work
			outgoing = outgoing.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
			if outgoing[-1..-1] == ":" then
				listofthings = reply.body.scan(/\<\li\>(.+?)\<\/li\>$/i)
				listofthings = listofthings.join(", ")
#				listofthings = listofthings.gsub("<b>","").gsub("</b>","")
#				outgoing = outgoing.gsub("<i>","").gsub("</i>","")
				listofthings = listofthings.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
				listofthings = listofthings.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
				listofthings = listofthings.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
				outgoing = outgoing + " " + listofthings + "."
			elsif outgoing[0,12] == "Coordinates:"
				outgoing = reply.body.scan(/\<\p\>(.+?)\<\/p\>$/i).uniq[1][0] # Doesn't work. TODO: Make it work
				outgoing = outgoing.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
				outgoing = outgoing.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
				outgoing = outgoing.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
			end
			if outgoing.length >400 then
#				privmsg(target,"P long, sending a PM.")
#				outgoing1 = outgoing[0..419]
#				outgoing2 = outgoing[420..outgoing.length-1]
#				if outgoing2[0,1] == " " then
#					outgoing2[0,1] = ""
#				end
#				privmsg(target,outgoing1)
#				privmsg(target,outgoing2)
				outgoing_array = outgoing.unpack("A400A400A400A400A400A400A400A400A400") # Not cool, not funny, not a good way to do things.
				for item in outgoing_array
					if item == "" then
						outgoing_array.delete(item)
#						puts 1 + "cocks" + nil # haha
					end
				end
				puts outgoing_array.count
#				if outgoing_array.count <= 2 then
#					target = target
#				else
#					privmsg(target,"Sending a PM for long.")
#					target = user
#				end
				for outgoing in outgoing_array
					
					privmsg(target,outgoing.strip.gsub("&#160;"," "),2)
					sleep 0.4
				end
			else
				privmsg(target,outgoing.strip.gsub("&#160;"," "),2)
			end
		end
	end
	end
	def find_faidwiki(target,article,user)
		# Threading
		Thread.new do
		# cocks cocks cocks
		puts article
#		article[0..0] = article[0..0].upcase
		wiki = Net::HTTP.new("faidwiki.niexs.net",80)
		wiki.read_timeout= 10
		article[0..0] = article[0..0].upcase
		article = article.gsub(" ","_")
		reply = wiki.get("/index.php/#{article}",nil)
		puts reply.message
		if reply.message == "Moved Temporarily" then
			article = reply.header["location"].sub("http://faidwiki.niexs.net","")
#			reply = wiki.get(article,nil)
			article = article.gsub(" ","_").sub("/index.php/")
			puts article
			reply = wiki.get("/index.php/#{article}",nil)
			privmsg(target,"Article: #{2.chr}#{article.sub("/wiki/","").gsub("_"," ")}#{2.chr}",2)
		end
		puts reply.message
		if reply.message != "OK" then
			privmsg(target,"No Such Article, Try Again",2)
		else
			outgoing = reply.body.scan(/\<\p\>(.+?)\<\/p\>$/i).uniq[0][0]
#			outgoing = outgoing.gsub("<b>","").gsub("</b>","")
#			outgoing = outgoing.gsub("<i>","").gsub("</i>","")
#			outgoing = outgoing.gsub(/\s(.+?)=\"(.+?)\"/,"").gsub(/(>+)/,">") #Doesn't work
#			puts outgoing
			outgoing = outgoing.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
			outgoing = outgoing.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
#			outgoing = outgoing.gsub("<a>",0x1F.chr.to_s).gsub("</a>",0x1F.chr.to_s) # Doesn't work
			outgoing = outgoing.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
			if outgoing[-1..-1] == ":" then
				listofthings = reply.body.scan(/\<\li\>(.+?)\<\/li\>$/i)
				listofthings = listofthings.join(", ")
#				listofthings = listofthings.gsub("<b>","").gsub("</b>","")
#				outgoing = outgoing.gsub("<i>","").gsub("</i>","")
				listofthings = listofthings.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
				listofthings = listofthings.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
				listofthings = listofthings.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
				outgoing = outgoing + " " + listofthings + "."
			elsif outgoing[0,12] == "Coordinates:"
				outgoing = reply.body.scan(/\<\p\>(.+?)\<\/p\>$/i).uniq[1][0] # Doesn't work. TODO: Make it work
				outgoing = outgoing.gsub("<b>",2.chr.to_s).gsub("</b>",2.chr.to_s)
				outgoing = outgoing.gsub("<i>",0x1F.chr.to_s).gsub("</i>",0x1F.chr.to_s)
				outgoing = outgoing.gsub(/<(\/|\s)*[^(b)][^>]*>/,'')
			end
			if outgoing.length >400 then
#				privmsg(target,"P long, sending a PM.")
#				outgoing1 = outgoing[0..419]
#				outgoing2 = outgoing[420..outgoing.length-1]
#				if outgoing2[0,1] == " " then
#					outgoing2[0,1] = ""
#				end
#				privmsg(target,outgoing1)
#				privmsg(target,outgoing2)
				outgoing_array = outgoing.unpack("A400A400A400A400A400A400A400A400A400") # Not cool, not funny, not a good way to do things.
				for item in outgoing_array
					if item == "" then
						outgoing_array.delete(item)
#						puts 1 + "cocks" + nil # haha
					end
				end
				puts outgoing_array.count
#				if outgoing_array.count <= 2 then
#					target = target
#				else
#					privmsg(target,"Sending a PM for long.")
#					target = user
#				end
				for outgoing in outgoing_array
					
					privmsg(target,outgoing.strip.gsub("&#160;"," "),2)
					sleep 0.4
				end
			else
				privmsg(target,outgoing.strip.gsub("&#160;"," "),2)
			end
		end
	end
	end
end
