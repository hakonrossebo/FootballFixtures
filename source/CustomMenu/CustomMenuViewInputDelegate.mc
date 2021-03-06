using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;

class CustomMenuViewInputDelegate extends Ui.InputDelegate
{
	hidden var propertyHandler;
    hidden var logger;
    hidden var mView;
    hidden var onSelectedTeamHandler;

    function initialize(mView, onSelectedTeamHandler,  propertyHandler){
		self.propertyHandler = propertyHandler;
		self.onSelectedTeamHandler = onSelectedTeamHandler;
		self.mView = mView;
      	logger = Log.getLogger("CustomMenuViewInputDelegate");
    }


    function onKey(key) {
      logger.debug("key pressed :" +key.getKey() );
        if(key.getKey() == Ui.KEY_ENTER || key.getKey() == Ui.KEY_MENU) {
        	logger.debug("Pressed enter or menu");

			var selectedItem = mView.getCurrentSelection();
      		logger.debug("selectedItem :" + selectedItem );
      		onSelectedTeamHandler.invoke(selectedItem);	
			Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
        if(key.getKey() == Ui.KEY_UP ) {
        	logger.debug("Pressed up");
        	mView.scrollMenuUp();
	        return true;
        }
        if(key.getKey() == Ui.KEY_DOWN ) {
        	logger.debug("Pressed down");
        	mView.scrollMenuDown();
	        return true;
        }
        return true;
    }

	function onTap(evt) {
    	var location = evt.getCoordinates();
    	var yPos = location[1];
    	var width = mView.width;
    	var height = mView.height;
    	if (yPos < height/3)
    	{
        	logger.debug("Pressed up");
        	mView.scrollMenuUp();
    	}
    	if (yPos > 2*height/3)
    	{
        	logger.debug("Pressed down");
        	mView.scrollMenuDown();
    	}
    	return true;	
	}
}
