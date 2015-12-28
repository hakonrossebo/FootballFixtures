using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Log4MonkeyC as Log;

class InfoView extends Ui.View {
    hidden var logger;
    hidden var infoText = Ui.loadResource(Rez.Strings.MainLoading);

    function initialize() {
        logger = Log.getLogger("InfoView");
        View.initialize();
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
    }



    //! Update the view
    function onUpdate(dc) {
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
