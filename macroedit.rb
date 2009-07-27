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
require 'yaml'

module Macroedit
	def macroage()
		include RubyCurses
		include RubyCurses::Utils
		
		VER::start_ncurses
		$log = Logger.new("view.log")
		$log.level = Logger::DEBUG
		@window = VER::Window.root_window
		
		colors = Ncurses.COLORS
		@form = Form.new(@window)
		@window.printstring(0,30,"Macros",$datacolor)
		macros = YAML::load(File.open(Etc.getpwuid.dir+'/.marcobot/macros')).to_a
		colnames = ['Trigger','Macro']
		macrotable = Table.new(@form) do
			name("macrotable")
			row(1)
			col(30)
			width(78)
			height(15)
			cell_editing_allowed(true)
			editing_policy(:EDITING_AUTO)
			set_data(macros,colnames)
		end
		sel_col = Variable.new(0)
		sel_col.value = 0
		table_col_model = macrotable.get_table_column_model
		selcolname = macrotable.get_col_name
		while ch = @window.getchar() != ?\C-q
			@form.repaint
			@window.wrefresh
		end
		@window.destroy
		VER::stop_ncurses
	end
end
if __FILE__ == $0 then
	include Macroedit
	macroage()
end
