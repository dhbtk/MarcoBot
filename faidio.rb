module Faidio
	def faidio(target)
		# Threads!
		Thread.new do
		Net::HTTP.start("theqcontinuum.net",8001) do |http|
			req = Net::HTTP::Get.new("/admin/stats.xml")
			req.basic_auth("admin","854600")
			reply = http.request(req)
			$xmlfile = reply.body
		end
#		puts @xmlfile
		$xmlfile = REXML::Document.new $xmlfile
		@root = $xmlfile.root
#		xmlfile.elements.each("icestats/sources") { |sources| $sources_num = sources.text.to_i }
		if @root.elements["sources"].text.to_i >= 1 then
			privmsg(target,"Streams:")
			$xmlfile.elements.each("icestats/source") do |source|
				mountpoint = source.attributes["mount"]
				listeners_plus_peak = source.elements["listeners"].text+"/"+source.elements["listener_peak"].text
				artist_title = source.elements["artist"].text+" - "+source.elements["title"].text
				name_description = source.elements["server_name"].text+" ("+source.elements['server_description'].text+")"
				if source.elements["listenurl"] != nil then
					listen_url = source.elements["listenurl"].text
				else
					listen_url = ""
				end
				samplerate = source.elements["audio_samplerate"].text
				if source.elements["ice-channels"] != nil then
					channels = (source.elements["ice-channels"].text.to_i>1 ? "Stereo" : "Mono")
				elsif source.elements["audio_channels"] != nil then
					channels = (source.elements["audio_channels"].text.to_i>1 ? "Stereo" : "Mono")
				else
					channels = "unknown"
				end
				genre = source.elements["genre"].text
				subtype = source.elements["subtype"].text
				output = name_description+" at "+listen_url+"; Genre is "+genre+"; "+listeners_plus_peak+" listeners. Streaming in "+channels+" at "+samplerate+" Hz using "+subtype+". Now playing: "+artist_title
				privmsg(target,output,2)
			end
				
		else
			privmsg(target,"No one is streaming.",2)
		end
	end
	end
end
