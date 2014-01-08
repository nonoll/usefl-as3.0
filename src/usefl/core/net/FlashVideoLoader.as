package usefl.core.net
{
	import usefl.utils.DebugUtil;
	import flash.display.DisplayObjectContainer;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.media.Video;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * videoLoader
	 * @author nonoll
	 * @example
		import usefl.core.net.videoLoader;
		import flash.events.Event;

		var sndLdr:videoLoader = new videoLoader();
		sndLdr.load( "snd" );
		sndLdr.addEventListener( Event.COMPLETE, onComplete );
		function onComplete( $e:Event ):void
		{
			trace( "total : " + sndLdr.totalTimes );
			trace( "cur : " + sndLdr.currentTime );
		}
		
	 */
	public class FlashVideoLoader extends EventDispatcher
	{
		private var _video							:Video;
		private var _videoContainer					:DisplayObjectContainer;
		private var _videoPosition					:Number = 0;
		private var _videoLength					:Number = 0;
		private var _videoPlayFlag					:Boolean = true;
		private var _videoRepeat					:Number = 0;
		private var _videoFormat					:String = ".flv";
		private var _videoSndChannel				:SoundChannel =  new SoundChannel();
		private var _videoSndTransForm				:SoundTransform;
		private var _videoLoadPercent				:Number;
		private var _videoNetConnection				:NetConnection;
		private var _videoNetStream					:NetStream;
		private var _videoNetStreamClient			:Object;
		
		private var _className						:String = "FlashVideoLoader - ";
		private var _debugUtil						:DebugUtil = new DebugUtil();
		
		public function FlashVideoLoader( $videoContainer:DisplayObjectContainer )
		{
			_videoContainer = $videoContainer;
			
			_videoNetConnection = new NetConnection();
            _videoNetConnection.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
            _videoNetConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            _videoNetConnection.connect( null );
		}
		
		private function netStatusHandler( $e:NetStatusEvent ):void
		{
            switch ( $e.info.code )
			{
                case "NetConnection.Connect.Success":
                    break;
                case "NetStream.Play.StreamNotFound":
                    break;
				case "NetStream.Seek.Notify":
					break;
				case "NetStream.Buffer.Full":
					break;
				case "NetStream.Buffer.Empty":
					break;
            }
        }

        private function securityErrorHandler( $e:SecurityErrorEvent ):void
		{
            trace( "securityErrorHandler: " + $e );
        }
		
		/**
		 * videoLoader	-	debug	-	디버깅 사용설정
		 */
		public function set debug( $b:Boolean ):void
		{
			_debugUtil._debugUsing = $b;
		}
		
		/**
		 * videoLoader	-	init	-	초기 설정
		 * @param	$url		String	-	videoPath
		 * @param	$sndFormat	String	-	videoFormat
		 */
		public function init( $url:String = "", $videoFormat:String = ".flv" ):void
		{
			_debugUtil._debugFrontMsg = _className + "init";
			_debugUtil.output( "$url : " + $url , " $videoFormat : " + $videoFormat );
			
			_videoFormat = $videoFormat;
			if ( $url != "" ) load( $url );
		}
		
		/**
		 * videoLoader	-	load	-	사운드 로드
		 * @param	$url	String	-	videoPath
		 * @param	$repeat	Number	-	videoRepeat
		 */
		public function load( $url:String, $repeat:Number = 0 ):void
		{
			_videoRepeat = $repeat;
			
			_videoPlayFlag = true;
			
			_videoNetStreamClient = new Object();
			_videoNetStreamClient.onMetaData = this.onMetaData;
			_videoNetStreamClient.onCuePoint = this.onCuePoint;
			
			
            _videoNetStream = new NetStream( _videoNetConnection );
            _videoNetStream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			_videoNetStream.client = _videoNetStreamClient
			_videoNetStream.bufferTime = 0;
			_videoNetStream.inBufferSeek = true;
			_videoNetStream.bufferTimeMax = 0;
			
			_videoContainer.addChild( video );
			_video.width = _videoContainer.width;
			_video.height = _videoContainer.height;
			_video.attachNetStream( _videoNetStream );
            _videoNetStream.play( $url );
			
			this.addEventListener( Event.ENTER_FRAME, onPlayCheck );
			
			_debugUtil._debugFrontMsg = _className + "load";
			_debugUtil.output( "$url : " + $url , " $repeat : " + $repeat );
		}
		
		private function onPlayCheck( $e:Event ):void
		{
			if ( _videoNetStream.time - 0.1 >= _videoLength )
			{
				this.removeEventListener( Event.ENTER_FRAME, onPlayCheck );
				played( null );
			}
		}
		
		public function onMetaData( info:Object ):void
		{
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			_videoLength = info.duration;
		}
		public function onCuePoint( info:Object ):void
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		/**
		 * videoLoader	-	pause	-	사운드 일시정지
		 */
		public function pause():void
		{
			_videoNetStream.pause();
			
			_videoPlayFlag = false;
			_videoPosition = videoPosition;
		}
		
		/**
		 * videoLoader	-	resume	-	사운드 재실행
		 */
		public function resume():void
		{
			_videoPlayFlag = true;
			videoPosition = _videoPosition;
		}
		
		/**
		 * videoLoader	-	playMode	-	재생여부 반환
		 * @return
		 */
		public function playMode():Boolean
		{
			return _videoPlayFlag;
		}
		
		/**
		 * videoLoader	-	close	-	사운드 재생 종료
		 */
		public function close():void
		{			
			_videoNetStream.close();
		}
		
		/**
		 * videoLoader	-	played	-	사운드 재생 완료
		 * @param	$e	Event	-	video Play video_COMPLETE
		 */
		private function played( $e:Event ):void
		{
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "played";
			_debugUtil.output( $e );
		}
		
		/**
		 * videoLoader	-	volume	-	볼륨 수치 반환
		 */
		public function get volume():Number
		{
			return ( _videoNetStream != null ) ? _videoNetStream.soundTransform.volume : 0;
		}
		
		/**
		 * videoLoader	-	volume	-	볼륨 수치 설정
		 */
		public function set volume( $value:Number ):void
		{
			if ( $value < 0 )			$value = 0;
			else if ( $value > 1 )		$value = 1;
			
			if ( _videoSndChannel == null ) return;
			
			_videoSndChannel = new SoundChannel( $value );
			_videoNetStream.soundTransform = _videoTransForm;
		}
		
		/**
		 * videoLoader	-	videoLength	-	사운드 파일 길이값 반환
		 */
		public function get videoLength():Number
		{
			return ( _video != null ) ? _videoLength : 0;
		}
		
		/**
		 * videoLoader	-	videoPosition	-	사운드 재생 위치값 반환
		 */
		public function get videoPosition():Number
		{
			return ( _videoChannel != null ) ? _videoChannel.position : 0;
		}
		
		/**
		 * videoLoader	-	videoPosition	-	사운드 재생 위치 설정
		 */
		public function set videoPosition( $value:Number ):void
		{
			if ( $value < 0 )					$value = 0;
			else if ( $value >= videoLength )	$value = videoLength - 0.1;
			
			_videoNetStream.seek( $value );
			_videoNetStream.resume();
			
			_videoPlayFlag = true;
		}
		
		/**
		 * videoLoader	-	currentTime	-	사운드 재생 시간 반환
		 */
		public function get currentTime():Number
		{
			return videoPosition / 1000;
		}
		
		/**
		 * videoLoader	-	totatlTimes	-	사운드 전체 재생 시간 반환
		 */
		public function get totalTimes():Number
		{
			return videoLength / 1000;
		}
		
		
	}

}