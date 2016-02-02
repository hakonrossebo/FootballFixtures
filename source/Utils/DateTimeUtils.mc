using Toybox.Time as Time;
using Log4MonkeyC as Log;
using Toybox.WatchUi as Ui;


module DateTimeUtils {
	var	logger = Log.getLogger("DateTimeUtils" );

    function parseISO8601DateToMoment(dateStr)
    {
    
    	// example - 2015-12-28T17:30:00Z
		try
		{
			var year = dateStr.substring(0, 4).toNumber();
			var month = trimLeadingZeros(dateStr.substring(5, 7)).toNumber();
			var day = trimLeadingZeros(dateStr.substring(8, 10)).toNumber();
			var hour = trimLeadingZeros(dateStr.substring(11, 13)).toNumber();
			var minute = trimLeadingZeros(dateStr.substring(14, 16)).toNumber();
			var dateTime = Time.Gregorian.moment({:year=>year,:month=>month,:day=>day, :hour=>hour,:minute=>minute,:second=>0});
			return dateTime;
		}
		catch (ex)
		{
			logger.error("Error - defaulting time to now");
			return Time.now();
		}
    }
    
	function trimLeadingZeros(source)
	{
	    for (var i = 0; i < source.length(); i++)
	    {
	        var c = source.substring(i, i+1);
	        logger.debug(c);
	        if (!c.equals("0")) {
	            return source.substring(i, source.length());
	        }
	    }
	    return source;
	}    
    
    
	function formatDurationToDDHHMM(seconds) {
		var sign = "";
		if (seconds < 0)
		{
			sign = "-";
			seconds = seconds * -1;
		}
		try
		{
			var days = seconds / 86400;
			days = days.toLong();
			seconds -= days * 86400;
			var hours = seconds / 3600;
			hours = hours.toLong() % 24;
			seconds -= hours * 3600;
			var minutes = seconds / 60;
			minutes = minutes.toLong() % 60;
		    return Toybox.Lang.format(Ui.loadResource(Rez.Strings.MainMatchIn) + "$1$$2$:$3$:$4$", [sign,days, hours.format("%02d"), minutes.format("%02d")]);
		}
		catch (ex)
		{
			logger.error("Error in date formatting");
			return "0:0:0";
		}
	}
    function getFormattedDateDDMMHHmm(dateTime)
    {
    	var shortDate = Time.Gregorian.info(dateTime, Toybox.Time.FORMAT_SHORT);
    	return Toybox.Lang.format("$1$/$2$ $3$:$4$", [shortDate.day, shortDate.month, shortDate.hour.format("%02d"), shortDate.min.format("%02d")]);
    }

}