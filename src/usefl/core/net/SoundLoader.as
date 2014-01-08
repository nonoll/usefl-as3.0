package usefl.core.net
{
	import usefl.utils.DebugUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * SoundLoader
	 * @author nonoll
	 * @example
		import usefl.core.net.SoundLoader;
		import flash.events.Event;

		var sndLdr:SoundLoader = new SoundLoader();
		sndLdr.load( "snd" );
		sndLdr.addEventListener( Event.COMPLETE, onComplete );
		function onComplete( $e:Event ):void
		{
			trace( "total : " + sndLdr.totalTimes );
			trace( "cur : " + sndLdr.currentTime );
		}
		
	 */
	public class SoundLoader extends EventDispatcher
	{
		private var _sound							:Sound;
		private var _soundPosition					:Number = 0;
		private var _soundPlayFlag					:Boolean = true;
		private var _soundRepeat					:Number = 0;
		private var _soundFormat					:String = ".mp3";
		private var _soundChannel					:SoundChannel =  new SoundChannel();
		private var _soundTransForm					:SoundTransform;
		private var _soundLoadPercent				:Number;
		
		private var _className						:String = "SoundLoader - ";
		private var _debugUtil						:DebugUtil = new DebugUtil();
		
		/**
		 * SoundLoader	-	debug	-	디버깅 사용설정
		 */
		public function set debug( $b:Boolean ):void
		{
			_debugUtil._debugUsing = $b;
		}
		
		/**
		 * SoundLoader	-	init	-	초기 설정
		 * @param	$url		String	-	SoundPath
		 * @param	$sndFormat	String	-	SoundFormat
		 */
		public function init( $url:String = "", $sndFormat:String = ".mp3" ):void
		{
			_debugUtil._debugFrontMsg = _className + "init";
			_debugUtil.output( "$url : " + $url , " $sndFormat : " + $sndFormat );
			
			_soundFormat = $sndFormat;
			if ( $url != "" ) load( $url );
		}
		
		/**
		 * SoundLoader	-	load	-	사운드 로드
		 * @param	$url	String	-	SoundPath
		 * @param	$repeat	Number	-	SoundRepeat
		 */
		public function load( $url:String, $repeat:Number = 0 ):void
		{
			_soundRepeat = $repeat;			
			_soundPlayFlag = true;
			
			if( _sound != null )	_soundChannel.removeEventListener( Event.SOUND_COMPLETE, played );
			
			_sound = new Sound();
			_sound.load( new URLRequest( $url + _soundFormat ) );
			_sound.addEventListener( ProgressEvent.PROGRESS, loadProgress );
			_sound.addEventListener( Event.COMPLETE, loaded );
			_sound.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			
			_soundChannel = _sound.play( 0, _soundRepeat );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, played );
			
			_debugUtil._debugFrontMsg = _className + "load";
			_debugUtil.output( "$url : " + $url , " $repeat : " + $repeat );
		}
		
		/**
		 * SoundLoader	-	pause	-	사운드 일시정지
		 */
		public function pause():void
		{
			_soundChannel.stop();
			
			_soundPlayFlag = false;
			_soundPosition = soundPosition;
		}
		
		/**
		 * SoundLoader	-	resume	-	사운드 재실행
		 */
		public function resume():void
		{
			_soundPlayFlag = true;
			soundPosition = _soundPosition;
		}
		
		/**
		 * SoundLoader	-	playMode	-	재생여부 반환
		 * @return
		 */
		public function playMode():Boolean
		{
			return _soundPlayFlag;
		}
		
		/**
		 * SoundLoader	-	close	-	사운드 재생 종료
		 */
		public function close():void
		{			
			_soundChannel.stop();			
			_soundChannel.removeEventListener( Event.SOUND_COMPLETE, played );
			
			_sound = null;			
			_soundChannel = null;
		}
		
		/**
		 * SoundLoader	-	loadProgress	-	사운드 로드 프로그레스
		 * @param	$e	ProgressEvent	-	Sound Load Progress
		 */
		private function loadProgress( $e:ProgressEvent ):void 
		{
			_soundLoadPercent = ( ( $e.bytesLoaded / $e.bytesTotal ) * 100 );
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "loadProgress";
			_debugUtil.output( "percent : " + _soundLoadPercent , " $e.bytesLoaded : " + $e.bytesLoaded, " $e.bytesTotal : " + $e.bytesTotal );
		}
		
		/**
		 * SoundLoader	-	loadProgressPercent	-	사운드 로드 프로그레스 퍼센트
		 */
		public function get loadProgressPercent():Number
		{
			return _soundLoadPercent;
		}
		
		/**
		 * SoundLoader	-	loaded	-	사운드 로드 완료
		 * @param	$e
		 */
		private function loaded( $e:Event ):void 
		{
			dispatchEvent( $e );
			
			_sound.removeEventListener( ProgressEvent.PROGRESS, loadProgress );
			_sound.removeEventListener( Event.COMPLETE, loaded );
			_sound.removeEventListener( IOErrorEvent.IO_ERROR, loadError );
			
			_soundChannel = _sound.play( 0, _soundRepeat );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, played );
			
			_debugUtil._debugFrontMsg = _className + "loaded";
			_debugUtil.output( $e );
		}
		
		/**
		 * SoundLoader	-	loadError	-	사운드 로드 에러
		 * @param	$e	IOErrorEvent	-	Sound Load IOErrorEvent
		 */
		private function loadError( $e:IOErrorEvent ):void 
		{
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "loadError";
			_debugUtil.output( $e );
		}
		
		/**
		 * SoundLoader	-	played	-	사운드 재생 완료
		 * @param	$e	Event	-	Sound Play SOUND_COMPLETE
		 */
		private function played( $e:Event ):void
		{
			dispatchEvent( $e );
			
			_debugUtil._debugFrontMsg = _className + "played";
			_debugUtil.output( $e );
		}
		
		/**
		 * SoundLoader	-	volume	-	볼륨 수치 반환
		 */
		public function get volume():Number
		{
			return ( _soundChannel != null ) ? _soundChannel.soundTransform.volume : 0;
		}
		
		/**
		 * SoundLoader	-	volume	-	볼륨 수치 설정
		 */
		public function set volume( $value:Number ):void
		{
			if ( $value < 0 )			$value = 0;
			else if ( $value > 1 )		$value = 1;
			
			if ( _soundChannel == null ) return;
			
			_soundTransForm = new SoundTransform( $value );
			_soundChannel.soundTransform = _soundTransForm;
		}
		
		/**
		 * SoundLoader	-	soundLength	-	사운드 파일 길이값 반환
		 */
		public function get soundLength():Number
		{
			return ( _sound != null ) ? _sound.length : 0;
		}
		
		/**
		 * SoundLoader	-	soundPosition	-	사운드 재생 위치값 반환
		 */
		public function get soundPosition():Number
		{
			return ( _soundChannel != null ) ? _soundChannel.position : 0;
		}
		
		/**
		 * SoundLoader	-	soundPosition	-	사운드 재생 위치 설정
		 */
		public function set soundPosition( $value:Number ):void
		{
			if ( $value < 0 )					$value = 0;
			else if ( $value >= soundLength )	$value = soundLength - 0.1;
			
			_soundChannel.stop();
			_soundChannel.removeEventListener( Event.SOUND_COMPLETE, played );
			
			_soundChannel = new SoundChannel();	
			_soundChannel = _sound.play( $value, 0, _soundTransForm );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, played );
			
			_soundPlayFlag = true;
		}
		
		/**
		 * SoundLoader	-	currentTime	-	사운드 재생 시간 반환
		 */
		public function get currentTime():Number
		{
			return soundPosition / 1000;
		}
		
		/**
		 * SoundLoader	-	totatlTimes	-	사운드 전체 재생 시간 반환
		 */
		public function get totalTimes():Number
		{
			return soundLength / 1000;
		}
		
	}

}