using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PickerChooser extends Ui.Picker {

    function initialize() {
        var title = new Ui.Text({:text=>"Select team", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var factory = new WordFactory(["Liverpool","ManU","Chelsea"],[64,66,61], {:font=>Gfx.FONT_SMALL});
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
//        Ui.popView(Ui.SLIDE_IMMEDIATE);
//        Ui.popView(Ui.SLIDE_IMMEDIATE);
        
	        var mView = new FootballTeamView();
	        var mModel = new FootballTeamModel(mView.method(:onInfoReady),values[0]);
	        Ui.pushView(mView, new FootballTeamViewInputDelegate(), Ui.SLIDE_IMMEDIATE);
//        if(values[0] == Rez.Strings.pickerChooserColor) {
//            Ui.pushView(new ColorPicker(), new ColorPickerDelegate(), Ui.SLIDE_IMMEDIATE);
//        }
    }
}
