package usefl.core.net 
{
	import usefl.utils.DebugUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * XmlLoader
	 * @author nonoll
	 * @example
		import usefl.core.net.XmlLoader;
		import flash.events.Event;
		import flash.events.ProgressEvent;
		import flash.events.IOErrorEvent;

		var _xmlLoader:XmlLoader = new XmlLoader();
		var _xml:XML;
		_xmlLoader.load( "http://wizard2.sbs.co.kr/w3/podcast/V0000328482.xml" );
		_xmlLoader.addEventListener( Event.COMPLETE, loaded );
		_xmlLoader.addEventListener( ProgressEvent.PROGRESS, loadProgress );
		_xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, loadError );
		XML.ignoreWhitespace = true;

		function loadError( $e:IOErrorEvent ):void
		{
			trace( "loadError : " + $e );
		}
		function loadProgress( $e:ProgressEvent ):void
		{
			trace( _xmlLoader.loadProgressPercent );
		}
		function loaded( $e:Event ):void
		{
			_xml = _xmlLoader.XMLData;
			trace( _xml );
		}
		
	 */
	public class XmlLoader extends EventDispatcher
	{
		private var _xmlLoader						:URLLoader;
		private var _xmlData						:XML;
		private var _xmlLoadPercent					:Number;
		private var _className						:String = "XmlLoader - ";
		private var _debugUtil						:DebugUtil = new DebugUtil();
		
		/**
		 * XmlLoader	-	debug	-	디버깅 사용설정
		 */
		public function set debug( $b:Boolean ):void
		{
			_debugUtil._debugUsing = $b;
		}
		
		/**
		 * XmlLoader	-	load	-	xml 로드
		 * @param	$url	String	-	xmlPath
		 */
		public function load( $url:String ):void
		{
			_xmlLoader = new URLLoader();
			_xmlLoader.load( new URLRequest( $url ) );
			_xmlLoader.addEventListener( Event.COMPLETE, loaded );
			_xmlLoader.addEventListener( ProgressEvent.PROGRESS, loadProgress );
			_xmlLoader.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			
			_debugUtil._debugFrontMsg = _className + "load";
			_debugUtil.output( "$url : " + $url );
		}
		
		/**
		 * XmlLoader	-	loadError	-	xml 로드 에러
		 * @param	$e	IOErrorEvent	-	xml Load IOErrorEvent
		 */
		private function loadError( $e:IOErrorEvent ):void 
		{
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "loadError";
			_debugUtil.output( $e );
		}
		
		/**
		 * XmlLoader	-	loadProgress	-	xml 로드 프로그레스
		 * @param	$e		ProgressEvent	-	xml Load Progress
		 */
		private function loadProgress( $e:ProgressEvent ):void 
		{
			_xmlLoadPercent = ( ( $e.bytesLoaded / $e.bytesTotal ) * 100 );
			
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "loadProgress";
			_debugUtil.output( "percent : " + _xmlLoadPercent , " $e.bytesLoaded : " + $e.bytesLoaded, " $e.bytesTotal : " + $e.bytesTotal );
		}
		
		/**
		 * XmlLoader	-	loaded	-	xml 로드 완료
		 * @param	$e		Event		xml Load Event
		 */
		private function loaded( $e:Event ):void 
		{
			_xmlData = new XML( $e.target.data );
			
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "loaded";
			_debugUtil.output( $e );
		}
		
		/**
		 * XmlLoader	-	XMLData	-	로드된 xmlData
		 */
		public function get XMLData():XML
		{
			return _xmlData;
		}
		
		/**
		 * XmlLoader	-	loadProgressPercent	-	xml 로드 프로그레스 퍼센트
		 */
		public function get loadProgressPercent():Number
		{
			return _xmlLoadPercent;
		}
		
	}

}