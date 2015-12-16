using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PickerChooser extends Ui.Picker {

    function initialize() {
        var title = new Ui.Text({:text=>Ui.loadResource(Rez.Strings.MainMenuSelectTeam), :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var factory = new WordFactory(globalTeams.values(), globalTeams.keys(), {:font=>Gfx.FONT_SMALL});
        Picker.initialize({:title=>title, :pattern=>[factory]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class PickerChooserDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
   		Sys.println("selected: " + values[0] );
        
        var mModel = new FootballTeamModel(mainView.method(:onInfoReady),values[0]);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
