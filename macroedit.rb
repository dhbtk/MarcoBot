require 'rubygems'
require 'ncurses'
require 'logger'
#require 'ver/keyboard'
require 'rbcurse'
require 'rbcurse/rcombo'
require 'rbcurse/rtable'
require 'rbcurse/celleditor'
#require 'rbcurse/table/tablecellrenderer'
require 'rbcurse/comboboxcellrenderer'
require 'rbcurse/action'

if $0 == __FILE__ then
	include RubyCurses
	include RubyCurses::Utils
	
	VER::start_ncurses
	
	@window = VER::Window.root_window
	
	colors = Ncurses.COLORS
	@form = Form.new @window
	@window.printstring(0,30,"OHMYGAWDITWORKS",$datacolor)
	while ch = @window.getchar() != ?\C-q
		@form.repaint
		@window.wrefresh
	end
	@window.destroy
	VER::stop_ncurses
end
	
	
