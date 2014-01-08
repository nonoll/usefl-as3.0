package usefl.utils 
{
	/**
	 * DebugUtil
	 * @author nonoll
	 */
	public class DebugUtil
	{
		/** Debug Front Message									*/
		public var _debugFrontMsg							:String = ">> Debug : ";
		/** Debug Using Flag									*/
		public var _debugUsing								:Boolean = true;
		
		/**
		 * DebugUtil	-	output ( debugging )
		 * @param	...arguments
		 */
		public function output( ...arguments ):void
		{
			if ( !_debugUsing ) return;
			
			if ( arguments.length < 1 )			trace( _debugFrontMsg + " >>>" );
			else								trace( _debugFrontMsg + " >>> \n    -  " + arguments );
		}
	}

}
