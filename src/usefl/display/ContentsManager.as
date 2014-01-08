package usefl.display 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ContentsManager
	 * @author nonoll
	 */
	public class ContentsManager extends EventDispatcher
	{
		private var _loader:Loader;
		
		public function ContentsManager()
		{
			
		}
		
        private function configureAddListeners( $dispatcher:EventDispatcher ):void
		{
            $dispatcher.addEventListener( Event.COMPLETE, loaded );
            $dispatcher.addEventListener( ProgressEvent.PROGRESS, progress );
			$dispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioError );
            $dispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
        }
		
		private function configureRemoveListeners( $dispatcher:EventDispatcher ):void
		{
            $dispatcher.removeEventListener( Event.COMPLETE, loaded );
            $dispatcher.removeEventListener( ProgressEvent.PROGRESS, progress );
			$dispatcher.removeEventListener( IOErrorEvent.IO_ERROR, ioError );
            $dispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
        }
		
		public function getInstance():Loader 
		{
			if ( _loader == null )		throw new Error( "Loader is NULL!!" );
			return _loader;
		}
		
		public function loader( $url:String ):void
		{
			_loader = new Loader();
			configureAddListeners( _loader.contentLoaderInfo );
			
			try
			{
				_loader.load( new URLRequest( $url ) );
			}
			catch( $error:Error )
			{
				trace( "Unable to load requested URL." );
			}
		}
		
		private function progress( $e:ProgressEvent ):void
		{
			trace( "progress" );
			dispatchEvent( $e );
		}
		
		private function loaded( $e:Event ):void
		{
			trace( "loaded" );
			dispatchEvent( $e );
			configureRemoveListeners( _loader.contentLoaderInfo );
		}
		
		private function ioError( $e:IOErrorEvent ):void
		{
			dispatchEvent( $e );
		}
		
		private function securityError( $e:SecurityErrorEvent ):void
		{
			dispatchEvent( $e );
		}
		
		public function unload():void
		{
			getInstance().unloadAndStop();
			_loader = null;
		}
		
		public function close():void
		{
			
		}
	}

}