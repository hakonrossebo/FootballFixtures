using Log4MonkeyC as Log;

module Constants {
	enum  {
		env_Production,
		env_Development,
		env_Debug,
		env_OfflineTesting
	} 
	var current_environment = env_Debug;

	var leagueTeams = { 57 => "Arsenal",1044 => "Bournemouth",328 => "Burnley",61 => "Chelsea",354 => "Crystal",62 => "Everton",338 => "Foxes",322 => "Hull",64 => "Liverpool",65 => "ManCity",66 => "ManUtd",343 => "Middlesbrough",340 => "Southampton",73 => "Spurs",70 => "Stoke",71 => "Sunderland",72 => "Swans",346 => "Watford",74 => "West Bromwich",563 => "West Ham" };

  	
  	
  	
  	function getGlobalLoggerConfig() {
  	var conf = new Log.Config();
  		if (Constants.current_environment >= Constants.env_Debug) {
  			conf.setLogLevel(Log.DEBUG);
  		}
  		else {
  			conf.setLogLevel(Log.WARN);
  		}
	return conf;
	}
}