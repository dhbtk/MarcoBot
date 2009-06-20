module Macros
	# Macrologic checks for macros on that message.
	# It returns an array with the trigger, the macro and the time since the last activation.
	# Is used by macrocheck() and check_for_macro().
	def macrologic(message) # Outputs an array[trigger,macro,time_since_last_activation]
		macros = []
		triggers = []
		outputarray = []
		for macro in @macros
			macro_split = macro.split(": ")
			if message.downcase.include?(macro_split[0].downcase) and macro_split[0] != " " then
				triggers.push macro_split[0]
			end
		end
		if !triggers.empty? and @yamlmacros[triggers.sort{ |x,y| y.length <=> x.length }[0]] != "" then
			triggers.sort! { |x,y| y.length <=> x.length }
			macro = @yamlmacros[triggers[0]]
			if @macrotime[triggers[0]] != nil then
				timeout = (Time.new - @macrotime[triggers[0]]).to_i
			else
				timeout = @configfile['macrotimeout'].to_i() + 1 # Obnoxiously large number
				@macrotime[triggers[0]] = @configfile['macrotimeout'].to_i() +1
			end
			return [triggers[0],macro,timeout]
		else
			return nil
		end
	end
	# Checks for a macro on the message. If found, and the timeout >= timeout set in
	# the settings file, it is outputted.
	def check_for_macro(message,target,user)
		macroarray = macrologic(message)
		if macroarray.class == Array then
			if macroarray[2] >= @configfile['macrotimeout'].to_i then
				puts "Acceptable macro found!"
				output = macroarray[1].chomp
				output.gsub!("$nick",user)
				output.gsub!("$NICK",user.upcase)
				if output.start_with?("/me") then
					output.sub!("/me ","")
					emote(target,output)
				else
					privmsg(target,output,0)
				end
				@macrotime[macroarray[0]] = Time.new
			end
		end
	end
	# Does the same as check_for_macro, but displays it only when asked for and
	# says the timeout time too. Rather neat.
	def macrocheck(message,target)
		message.sub!("#{@command_identifier}macrocheck ","") # Ugly hack
		macroarray = macrologic(message)
		if macroarray.class == Array then
			if macroarray[2] >= @configfile['macrotimeout'].to_i then
				privmsg(target,"The phrase \"#{message}\" triggers the macro \"#{macroarray[1].chomp}\".",0)
			else
				timeout = (((Time.new + @configfile['macrotimeout'].to_i).to_i - (Time.new - (Time.new - @macrotime[macroarray[0]])).to_i) - @configfile['macrotimeout'].to_i)*(-1) # I DON'T EVEN UNDERSTAND THIS ANYMORE
				privmsg(target,"The phrase \"#{message}\" will trigger the macro \"#{macroarray[1].chomp}\" in #{timeout.to_i} seconds.",0)
			end
		else
			privmsg(target,"The phrase \"#{message}\" doesn't trigger any macro.",0)
		end
	end
	def add_macro(channel,trigger,macro)
		trigger = trigger.sub("~macro ","")
		if macro != nil then macro.chomp!; end
		puts "DEBUG: channel: #{channel}, trigger: #{trigger}, macro: #{macro}"
		@macrofile = YAML::load(File.open("#{@basepath}macros"))
		if trigger.gsub(" ","").length >4 then
			if macro == nil then
				@macrofile.delete trigger.downcase
				privmsg(channel,"Macro removed.")
			else
				@macrofile[trigger.downcase.strip] = macro.strip
				privmsg(channel,"Macro added.")
			end
		else
			privmsg(channel,"Five chars or more, please.")
		end
		File.open("#{@basepath}macros","w") do |f|
			f << @macrofile.to_yaml
		end
		@macrofile = File.open("#{@basepath}macros","r")
		@yamlmacros = YAML::load(@macrofile)
		@macrofile.rewind
		@macros = @macrofile.readlines
	end
	def macro_trim()
		for a in @yamlmacros
			if a[1].strip == "" then
				@yamlmacros.delete(a[0])
			end
		end
	end
	def macro_save()
		File.open("#{@basepath}macros","w") do |f|
			f << @yamlmacros.to_yaml
		end
	end
end
