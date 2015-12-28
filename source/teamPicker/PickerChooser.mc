using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

class PickerChooser extends Ui.Picker {
	hidden var logger;
    function initialize() {
		logger = Log.getLogger("PickerChooser" );
		logger.debug("Started picker chooser");
        var title = new Ui.Text({:text=>Ui.loadResource(Rez.Strings.MainMenuSelectTeam), :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var factory = new WordFactory(Constants.leagueTeams.values(), Constants.leagueTeams.keys(), {:font=>Gfx.FONT_SMALL});
        Picker.initialize({:title=>title, :pattern=>[factory]});
		logger.debug("picker chooser initialized");
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}
