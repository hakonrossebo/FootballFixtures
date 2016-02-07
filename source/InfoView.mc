using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Log4MonkeyC as Log;

class InfoView extends Ui.View {
    hidden var logger;
    hidden var infoText = Ui.loadResource(Rez.Strings.MainLoading);
	hidden var propertyHandler;
	hidden var selectedItem;
	
    function initialize(propertyHandler, selectedItem) {
        logger = Log.getLogger("InfoView");
        logger.debug("Start InfoView init");
        self.selectedItem = selectedItem;
        self.propertyHandler = propertyHandler;
        //View.initialize();
        logger.debug("InfoView init ok");
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    function onInfoUpdated(info)
    {
        logger.debug("Inside info updated: " + info);
        infoText = info;
        Ui.requestUpdate();
	}


    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
        logger.debug("Start on show");
        var mModel = new FootballTeamModel(propertyHandler, method(:onInfoUpdated),selectedItem);
    }



    //! Update the view
    function onUpdate(dc) {
        logger.debug("Start on show");
        // Call the parent onUpdate function to redraw the layout
        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/4, G.FONT_MEDIUM, infoText, G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
