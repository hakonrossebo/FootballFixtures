using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Log4MonkeyC as Log;

class CustomMenuView extends Ui.View {
    hidden var logger;
    hidden var menuItems;
    hidden var menuItemsValues;
    hidden var menuItemsKeys;
    hidden var menuItemsCount = 0;
    hidden var currentMenuItem = 0;


    function initialize(menuItems) {
    	self.menuItems = menuItems;
    	logger = Log.getLogger("CustomMenuView");
    	menuItemsKeys = menuItems.keys();
    	menuItemsValues = menuItems.values();
    	menuItemsCount = menuItems.size();
	
		for (var index = 0;index < menuItemsValues.size() ;index ++)
		{
			logger.debug(menuItemsValues[index] + " - " + menuItemsKeys[index]);
		}
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.CustomMenuLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	//scrollMenuUp();
    }

    //! Update the view
    function onUpdate(dc) {
    	var TeamNamePrev = View.findDrawableById("TeamNamePrev");
    	var TeamNameCurrent = View.findDrawableById("TeamNameCurrent");
    	var TeamNameNext = View.findDrawableById("TeamNameNext");
        TeamNamePrev.setText(getMenuItemByOffset(0));
        TeamNameCurrent.setText(getMenuItemByOffset(1));
        TeamNameNext.setText(getMenuItemByOffset(2));
    
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
    
    function scrollMenuUp(){
    	currentMenuItem --;
    	updateMenuItems();
    }
    function scrollMenuDown(){
    	currentMenuItem ++;
    	updateMenuItems();
    }
    
    function updateMenuItems() {
    	if (menuItemsCount > 0) {
			if (currentMenuItem < 0) 
			{
				currentMenuItem = menuItemsCount - 1;
			}
			getCurrentSelection();
    		Ui.requestUpdate();
    	}
    }
    
    
    function getCurrentSelection() {
		var virtualIndex = currentMenuItem + 1;
		var realIndex = virtualIndex % menuItemsCount;
		logger.debug ("Current team:" + menuItemsValues[realIndex] + " - Current teamId:" + menuItemsKeys[realIndex]);
		return menuItemsKeys[realIndex];
    }
    
	function getMenuItemByOffset(offset) {
		logger.debug ("Offset: " + offset);
		var virtualIndex = currentMenuItem + offset;
		var realIndex = virtualIndex % menuItemsCount;
		logger.debug ("RealIndex: " + realIndex);
		return menuItemsValues[realIndex];
	}

}
