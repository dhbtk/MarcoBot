module Debugging
	def start_debug_window()
		# Main window holding stuff
		@mainwindow = Gtk::Window.new
		@mainwindow.set_size_request(640,480)
		@mainwindow.title = "MarcoBot's debug"
		# Scrolled window holding the textarea
		@scrollwin = Gtk::ScrolledWindow.new
		@scrollwin.border_width = 5
		@scrollwin.set_policy(Gtk::POLICY_AUTOMATIC,Gtk::POLICY_ALWAYS)
		# Debug window
		@debugwindow = Gtk::TextView.new()
		@debugwindow.modify_font(Pango::FontDescription.new("Monospace 10"))
		@debugwindow.editable = false
		@debugwindow.cursor_visible = false
		# Adding textarea to scrolled window
		@scrollwin.add(@debugwindow)
		# Adding scrolled window to debug window
		@mainwindow.add(@scrollwin)
		@mainwindow.show_all
	end
	def puts(message)
		@debug = @debug + "#{timestamp(Time.new)} #{message.to_s.chomp}\n"
		if @debugwindow != nil then
			@debugwindow.buffer.text = @debug
			end_mark = @debugwindow.buffer.create_mark(nil,@debugwindow.buffer.end_iter,false)
			@debugwindow.scroll_to_mark(end_mark,0.0,true,0.0,1.0)
		end
		Kernel.puts message
	end
end
