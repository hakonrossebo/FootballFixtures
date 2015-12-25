using Log4MonkeyC as Log;

class PropertyHandler {
	hidden const OLD_SETTINGS_IDENTITY = "TeamFixtureInfoJson";
	hidden var logger;

	// Constructor
	function initialize() {
		logger = Log.getLogger("PropertyHandler" );
	}


}
