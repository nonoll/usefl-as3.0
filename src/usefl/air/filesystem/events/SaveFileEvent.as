package usefl.air.filesystem.events 
{
	import flash.events.Event;
	
	/**
	 * SaveFileEvent
	 * @author nonoll
	 */
	public class SaveFileEvent extends Event
	{
		
		public static const SAVE_END:String = "saveEnd";
		
		public function SaveFileEvent( $type:String, $bubbles:Boolean = false, $cancelable:Boolean = false )
		{
			super( $type, $bubbles, $cancelable );
		}
		
	}

}