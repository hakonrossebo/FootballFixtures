using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class PickerChooser extends Ui.Picker {

    function initialize() {
        var title = new Ui.Text({:text=>Ui.loadResource(Rez.Strings.MainMenuSelectTeam), :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var factory = new WordFactory(["Arsenal","Aston Villa","Bournemouth","Chelsea","Crystal","Everton","Foxes","Liverpool","ManCity","ManU","Newcastle","Norwich","Southampton","Spurs","Stoke","Sunderland","Swans","Watford","West Bromwich","West Ham"],[57,58,1044,61,354,62,338,64,65,66,67,68,340,73,70,71,72,346,74,563], {:font=>Gfx.FONT_SMALL});
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
        
        //var mView = new FootballTeamView();
        var mModel = new FootballTeamModel(mainView.method(:onInfoReady),values[0]);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Ui.popView(Ui.SLIDE_IMMEDIATE);


//			Ui.switchToView(mainView, new FootballTeamViewInputDelegate(), Ui.SLIDE_IMMEDIATE);
//        	if(values[0] == Rez.Strings.pickerChooserColor) {
//            	Ui.pushView(new ColorPicker(), new ColorPickerDelegate(), Ui.SLIDE_IMMEDIATE);
//        	}
    }
}
