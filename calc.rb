module Calc
	def sanitize(expr)
		# Stripping spaces
		expr.gsub!(" ","")
		# Turning square roots into something more easily identified
		# Parensed square roots
		roots = expr.match(/sqrt\([0-9.^+-\/A-Z]+\)/)
		if roots != nil then
			roots = roots.to_a
			for root in roots
				expr.sub!(root,root.gsub(/(\(|\))/,""))
			end
		end
		expr.gsub!("sqrt","&")
		# Constants
		expr.gsub!("PI",Math::PI.to_s)
		expr.gsub!("E",Math::E.to_s)
		# Stripping out other stuff
		expr.gsub!(/[a-z]+|[A-Z]+/,"")
		# Turning ^ into ** (exponents)
		expr.gsub!("^","**")
		# Square roots and stuff
		roots = expr.match(/&[0-9.^+-\/A-Z]+/)
		if roots != nil then
			roots = roots.to_a
			roots.each do |root|
				expr.sub!(root,"Math.sqrt(#{root.sub("&","")})")
			end
		end
		begin
			return "#{eval expr}"
		rescue Exception
			return "INVALID ARGUMENTS< CORRECT SOURCE AND RESUBNIT"
		end
	end
end
