# Adds/takes karma points from someone
module Karma
	# Loads the karma from the karmafile and stores it in a global var.
	def karma_init()
		file_path = "#{@basepath}karma"
		@karmafile = YAML::load(File.open(file_path))
		@karmatimeouts = Hash.new
	end
	# Saves stuff to the Karma file
	def karma_save()
		File.open("#{@basepath}karma","w") do |file|
			file << @karmafile.to_yaml
		end
	end
	# Checks for (<3/$user++ or </3/$user-- in a message), and adds/subtracts
	# from the target's karma if he hasn't voted in TIMEOUT seconds, and his/her
	# username isn't in a blacklist.
	def check_for_karma(message,user,channel)
		usermask = user
		user = usermask.split("!")[1].downcase
		actualuser = usermask.split("!")[0].downcase
		if message.start_with?("<3 ") or message[-2..-1] == "++" then
			puts "Adding karma"
			if message.start_with?("<3 ") then
				target = message.sub("<3 ","").strip.downcase
			else
				target = message.strip[0..message.strip.size-3].downcase
			end
			coefficient = 1
			if @configfile['debugmode'] == 'yes' then
				puts "MESSAGE ENDS IN NEWLINE LOLOLOL" if message.end_with?("\n")
				puts "Var/class/value"
				puts "message/#{message.class}/#{message}"
				puts "user/#{user.class}/#{user}"
				puts "actualuser/#{actualuser.class}/#{actualuser}"
				puts "target/#{target.class}/#{target}"
				puts "coefficient/#{coefficient.class}/#{coefficient}"
			end
		elsif message.start_with?("</3 ") or message[-2..-1] == "--" then
			puts "subtracting karma"
			if message.start_with?("</3 ") then
				target = message.sub("</3 ","").strip.downcase
			else
				target = message.strip[0..message.strip.size-3].downcase
			end
			coefficient = -1
			if @configfile['debugmode'] == 'yes' then
				puts "MESSAGE ENDS IN NEWLINE LOLOLOL" if message.end_with?("\n")
				puts "Var/class/value"
				puts "message/#{message.class}/#{message}"
				puts "user/#{user.class}/#{user}"
				puts "actualuser/#{actualuser.class}/#{actualuser}"
				puts "target/#{target.class}/#{target}"
				puts "coefficient/#{coefficient.class}/#{coefficient}"
			end
		end
		# Magical stuff
		if target != nil and actualuser.downcase != target and @users[channel.downcase].include?(target.downcase.strip) and !@configfile['blacklistnicks'].downcase.split(",").include?(actualuser.downcase) and coefficient != 0 then

			if @karmatimeouts["#{user}/#{target}"] == nil or (Time.new - @karmatimeouts[user+'/'+target]) >= @configfile['karmatimeout'].to_i() and coefficient == 1 then
				puts "Truly adding karma"
				if @karmafile[target] == nil then
					@karmafile[target] = 0
				end
				@karmafile[target] += 1
				if @configfile['karma_slow'] == 'yes' then
					karma_save()
				end
				@karmatimeouts[user+'/'+target] = Time.new
				privmsg(channel,"Adding karma") if @configfile['karmadebug'] == 'yes'		
			elsif @karmatimeouts["#{user}/#{target}"] == nil or (Time.new - @karmatimeouts	[user+'/'+target]) >= @configfile['karmatimeout'].to_i() and coefficient == -1 then
				if @karmafile[target] == nil then
					@karmafile[target] = 0
				end
				@karmafile[target] -= 1
				if @configfile['karma_slow'] == 'yes' then
					karma_save()
				end
				@karmatimeouts[user+'/'+target] = Time.new
				puts "Removing karma"
				privmsg(channel,"Removing karma") if @configfile['karmadebug'] == 'yes'
			else
				privmsg(channel,"On cooldown.") if @configfile['karmadebug'] == 'yes'
			end
			coefficient = 0
		end		
	end
	# Gets a target's karma.
	def get_karma(target,person)
		if @karmafile[person.downcase] == nil then
			privmsg(target,"#{person} has no karma yet.")
		else
			privmsg(target,"#{person}'s karma is #{@karmafile[person.downcase]}.")
		end
	end
end
