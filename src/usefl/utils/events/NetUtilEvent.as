package usefl.utils.events 
{
	import flash.events.Event;
	
	/**
	 * NetUtilEvent
	 * @author nonoll
	 */
	public class NetUtilEvent extends Event
	{
		
		public static const GET_IP					:String = "getIP";
		public static const GET_INFORMATION			:String = "getInformation";
		public static const GET_ONLINE				:String = "getOnline";
		
		private var _data:Object;
		
		public function NetUtilEvent( $type:String, $data:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false )
		{
			super( $type, $bubbles, $cancelable );
			_data = $data;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data( $data:Object ):void
		{
			_data = $data;
		}
	}

}