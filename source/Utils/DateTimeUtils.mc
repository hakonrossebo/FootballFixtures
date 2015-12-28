using Toybox.Time as Time;
using Log4MonkeyC as Log;



module DateTimeUtils {

    function parseISO8601DateToMoment(dateStr)
    {
    	var	logger = Log.getLogger("DateTimeUtils.parseISO8601DateToMoment" );
    
    	// example - 2015-12-28T17:30:00Z
		try
		{
			var year = dateStr.substring(0, 4).toNumber();
			var month = dateStr.substring(5, 7).toNumber();
			var day = dateStr.substring(8, 10).toNumber();
			var hour = dateStr.substring(11, 13).toNumber();
			var minute = dateStr.substring(14, 16).toNumber();
			var dateTime = Time.Gregorian.moment({:year=>year,:month=>month,:day=>day, :hour=>hour,:minute=>minute,:second=>0});
			return dateTime;
		}
		catch (ex)
		{
			logger.error("Error - defaulting time to now");
			return Time.now();
		}
    }


}