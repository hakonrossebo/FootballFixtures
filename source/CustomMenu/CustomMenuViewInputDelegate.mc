using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;

class CustomMenuViewInputDelegate extends Ui.InputDelegate
{
	hidden var keyUpHandler;
	hidden var keyDownHandler;
    hidden var logger;

    function initialize(keyUpHandler, keyDownHandler){
    	self.keyUpHandler = keyUpHandler;
    	self.keyDownHandler = keyDownHandler;
    	
      	logger = Log.getLogger("CustomMenuViewInputDelegate");
    }

    function onKey(key) {
      logger.debug("key pressed :" +key.getKey() );
        if(key.getKey() == Ui.KEY_ENTER || key.getKey() == Ui.KEY_MENU) {
        	logger.debug("Pressed enter or menu");
        	//Ui.pushView( new PickerChooser(), new PickerChooserDelegate(propertyHandler), Ui.SLIDE_IMMEDIATE );
        	//Ui.pushView( new Rez.Menus.MainMenu(), new MainMenuDelegate(propertyHandler), Ui.SLIDE_UP );
        }
        if(key.getKey() == Ui.KEY_UP ) {
        	logger.debug("Pressed up");
        	keyUpHandler.invoke();
        }
        if(key.getKey() == Ui.KEY_DOWN ) {
        	logger.debug("Pressed down");
        	keyDownHandler.invoke();
        }
    }

}
