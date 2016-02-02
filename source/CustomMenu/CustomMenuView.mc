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
	var width=0;
	var height=0;

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
		logger.debug ("Finished init custom menu");
		
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    function onShow() {
    }

    function onUpdate(dc) {
		width = dc.getWidth();
        height = dc.getHeight();
        var centerY = height / 2;
        var centerX = width / 2;
        var topPosY = 2 * height  / 9;
        var bottomPosY = 7 * height  / 9;
            
		logger.debug ("Start on update custommenu");
		
        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();
        
        dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT );
        dc.drawText( centerX, topPosY, Gfx.FONT_MEDIUM, getMenuItemByOffset(0), Gfx.TEXT_JUSTIFY_CENTER );
        
        dc.setColor( Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT );
        dc.drawText( centerX, centerY, Gfx.FONT_LARGE, getMenuItemByOffset(1), Gfx.TEXT_JUSTIFY_CENTER );
        
        dc.setColor( Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT );
        dc.drawText( centerX, bottomPosY, Gfx.FONT_MEDIUM, getMenuItemByOffset(2), Gfx.TEXT_JUSTIFY_CENTER );
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
