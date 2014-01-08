package usefl.component.clock.events 
{
	import flash.events.Event;
	
	/**
	 * DefaultMouseEvent
	 * @author hkroh
	 */
	public class ClockEvent extends Event
	{
		
		public static const RENDER_CLOCK:String = "renderClock";
		
		public function ClockEvent( $type:String, $bubbles:Boolean = false, $cancelable:Boolean = false )
		{
			super( $type, $bubbles, $cancelable );
		}
		
	}

}
