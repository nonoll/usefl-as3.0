package usefl.component.clock 
{
	import usefl.component.clock.events.ClockEvent;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Clock
	 * @author nonoll
	 * @example
		//	기본 날짜 표현
		import usefl.component.clock.Clock;

		var _clock:Clock = new Clock();
		trace( _clock.year, _clock.month, _clock.date, _clock.day );	// 2013 5 21 3
		trace( _clock.yearStr, _clock.monthStr, _clock.dateStr, _clock.dayStr );	// 2013년 5월 21일 화요일

		_clock.displayString = _clock.DISPLAY_ENG_FULL;								// 영문 표기( 풀 )
		trace( _clock.yearStr, _clock.monthStr, _clock.dateStr, _clock.dayStr );	// 2013 May 21 TuesDay

		_clock.displayString = _clock.DISPLAY_ENG_SHORT;							//	영문 표기( 짧은형태 )
		trace( _clock.yearStr, _clock.monthStr, _clock.dateStr, _clock.dayStr );	// 2013 May 21 Tue
		
		
		//	기본 시간 표현
		import usefl.component.clock.Clock;
		import usefl.component.clock.events.ClockEvent;
		import flash.display.MovieClip;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;

		var date_tf:TextField = new TextField();
		date_tf.autoSize = TextFieldAutoSize.LEFT;
		date_tf.selectable = false;
		addChild( date_tf );
		
		var _clock:Clock = new Clock();
		_clock.addEventListener( ClockEvent.RENDER_CLOCK, onClockRender );
		
		function onClockRender( $e:ClockEvent ):void
		{
			trace( _clock.hours, _clock.minutes, _clock.seconds, _clock.milliseconds );
			date_tf.text = "현재 시간 > " + _clock.hours + " : " + _clock.minutes + " : " + _clock.seconds + " : " + _clock.milliseconds;
		}

		
		
		//	아날로그 시계
		//	각 시, 분, 초, 밀리세컨드 에 해당하는 무비클립 설정
		import usefl.component.clock.Clock;
		import flash.display.MovieClip;

		var _clock:Clock = new Clock();
		var hour_mc:MovieClip = this.hour_mc;
		var min_mc:MovieClip = this.min_mc;
		var sec_mc:MovieClip = this.sec_mc;
		var mmin_mc:MovieClip = this.mmin_mc;
		_clock.analogClock( hour_mc, min_mc, sec_mc, mmin_mc );
		_clock.pause();		// 일시정지
		_clock.resume();	// 재실행
		
		
		//	아날로그 시계2
		//	각 시, 분, 초 에 해당하는 무비클립 설정
		import usefl.component.clock.Clock;
		import usefl.component.clock.events.ClockEvent;
		import flash.display.MovieClip;
		import flash.display.SimpleButton;
		import flash.events.MouseEvent;

		var _clock:Clock = new Clock();
		var hour_mc:MovieClip = this.hour_mc;
		var min_mc:MovieClip = this.min_mc;
		var sec_mc:MovieClip = this.sec_mc;
		var mmin_mc:MovieClip = this.mmin_mc;
		var pause_btn:SimpleButton = this.pause_btn;
		var resume_btn:SimpleButton = this.resume_btn;

		pause_btn.addEventListener( MouseEvent.CLICK, onPause );
		resume_btn.addEventListener( MouseEvent.CLICK, onResume );

		function onPause( $e:MouseEvent ):void
		{
			_clock.pause();
		}

		function onResume( $e:MouseEvent ):void
		{
			_clock.resume();
		}
		_clock.pause();		// 일시정지
		_clock.resume();	// 재실행
	 */
	public class Clock extends EventDispatcher
	{
		private var _clockDate						:Date;
		private var _clockDateMargin				:int = 0;
		private var _clockRenderTimer				:Timer
		private var _clockMonth						:Array = [
																{ kor: "1월",	engFull: "January",		engShort: "Jan" },
																{ kor: "2월",	engFull: "Febrary",		engShort: "Feb" },
																{ kor: "3월",	engFull: "March",		engShort: "Mar" },
																{ kor: "4월",	engFull: "April",		engShort: "Apr" },
																{ kor: "5월",	engFull: "May",			engShort: "May" },
																{ kor: "6월",	engFull: "June",		engShort: "Jun" },
																{ kor: "7월",	engFull: "July",		engShort: "Jul" },
																{ kor: "8월",	engFull: "August",		engShort: "Aug" },
																{ kor: "9월",	engFull: "September",	engShort: "Sept" },
																{ kor: "10월",	engFull: "October",		engShort: "Oct" },
																{ kor: "11월",	engFull: "November",	engShort: "Nov" },
																{ kor: "12월", 	engFull: "December",	engShort: "Dec" }
															];
		private var _clockDay						:Array = [
																{ kor: "일요일",	engFull: "Sunday",		engShort: "Sun" },
																{ kor: "월요일",	engFull: "Monday",		engShort: "Mon" },
																{ kor: "화요일",	engFull: "TuesDay",		engShort: "Tue" },
																{ kor: "수요일",	engFull: "Wednesday",	engShort: "Wed" },
																{ kor: "목요일",	engFull: "Thursday",	engShort: "Thr" },
																{ kor: "금요일",	engFull: "Friday",		engShort: "Fri" },
																{ kor: "토요일",	engFull: "Saturday",	engShort: "Sat" }
															];
		private var _clockDisplayStr				:String = "kor";
		private var _analogHour						:MovieClip = null;
		private var _analogMin						:MovieClip = null;
		private var _analogSec						:MovieClip = null;
		private var _analogMilSec					:MovieClip = null;
		public var DISPLAY_KOR						:String = "kor";
		public var DISPLAY_ENG_FULL					:String = "engFull";
		public var DISPLAY_ENG_SHORT				:String = "engShort";
		
		/**
		 * Clock	- 생성자	-	기본 date 값에 추가할 수치 지정
		 * @param	$clockDateMargin	int
		 */
		public function Clock( $clockDateMargin:int = 1, $renderTimer:Number = 20 )
		{
			_clockDate = new Date();
			_clockDateMargin = $clockDateMargin;
			
			_clockRenderTimer = new Timer( $renderTimer );
			_clockRenderTimer.addEventListener( TimerEvent.TIMER, render );
			_clockRenderTimer.start();
		}
		
		/**
		 * Clock	-	analogClock	-	아날로그 시계설정
		 * @param	$hour_mc	MovieClip
		 * @param	$min_mc		MovieClip
		 * @param	$sec_mc		MovieClip
		 */
		public function analogClock( $hour_mc:MovieClip = null, $min_mc:MovieClip = null, $sec_mc:MovieClip = null, $milSec_mc:MovieClip = null ):void
		{
			_analogHour = $hour_mc;
			_analogMin = $min_mc;
			_analogSec = $sec_mc;
			_analogMilSec = $milSec_mc;
		}
		
		/**
		 * Clock	-	renderAnalogClock	-	아날로그 시계 렌더링
		 */
		private function renderAnalogClock():void
		{
			if ( _analogHour != null )		_analogHour.rotation = hoursRot;
			if ( _analogMin != null )		_analogMin.rotation = minutesRot;
			if ( _analogSec != null )		_analogSec.rotation = secondsRot;
			if ( _analogMilSec != null )	_analogMilSec.rotation = millisecondsRot;
		}
		
		/**
		 * Clock	-	render	-	시간 동기화 렌더링
		 * @param	$e	TimerEvent
		 */
		private function render( $e:TimerEvent ):void
		{
			_clockDate = new Date();
			renderAnalogClock();
			
			var renderEvent:ClockEvent = new ClockEvent( ClockEvent.RENDER_CLOCK );
			dispatchEvent( renderEvent );
		}
		
		/**
		 * Clock	-	pause	-	정지
		 */
		public function pause():void
		{
			_clockRenderTimer.stop();
		}
		
		/**
		 * Clock	-	resume	-	실행
		 */
		public function resume():void
		{
			_clockRenderTimer.start();
		}
		
		/**
		 * Clock	-	displayString	-	표현할 문자 형태 지정
		 */
		public function set displayString( $displayStr:String ):void
		{
			_clockDisplayStr = $displayStr;
		}
		
		/**
		 * Clock	-	year	-	년도 반환
		 * @return	Number
		 */
		public function get year():Number
		{
			return _clockDate.fullYear;
		}
		
		/**
		 * Clock	-	yearStr	-	년도 문자화 반환
		 * @return	String
		 */
		public function get yearStr():String
		{
			var rtn:String = String( year );
			return ( _clockDisplayStr == DISPLAY_KOR ) ? rtn + "년" : rtn;
		}
		
		/**
		 * Clock	-	month	-	월 반환
		 * @return	Number
		 */
		public function get month():Number
		{
			return _clockDate.month + _clockDateMargin;
		}
		
		/**
		 * Clock	-	monthStr	-	월 문자화 반환
		 * @return	String
		 */
		public function get monthStr():String
		{
			return _clockMonth[ month - _clockDateMargin ][ _clockDisplayStr ]; 
		}
		
		/**
		 * Clock	-	date	-	일 반환
		 * @return	Number
		 */
		public function get date():Number
		{
			return _clockDate.date;
		}
		
		/**
		 * Clock	-	dateStr	-	일 문자화 반환
		 * @return	String
		 */
		public function get dateStr():String
		{
			var rtn:String = String( date );
			return ( _clockDisplayStr == DISPLAY_KOR ) ? rtn + "일" : rtn;
		}
		
		/**
		 * Clock	-	day	-	요일 반환
		 * @return	Number
		 */
		public function get day():Number
		{
			return _clockDate.day + _clockDateMargin;
		}
		
		/**
		 * Clock	-	dayStr	-	요일 문자화 반환
		 * @return	String
		 */
		public function get dayStr():String
		{
			return _clockDay[ day - _clockDateMargin ][ _clockDisplayStr ]; 
		}
		
		/**
		 * Clock	-	hours	-	시 반환
		 * @return	Number
		 */
		public function get hours():Number
		{
			return _clockDate.hours;
		}
		
		/**
		 * Clock	-	hoursRot	-	시 각도 반환
		 * @return	Number
		 */
		public function get hoursRot():Number
		{
			var rot:Number = 360 / 12;
			return rot * hours;
		}
		
		/**
		 * Clock	-	minutes	-	분 반환
		 * @return	Number
		 */
		public function get minutes():Number
		{
			return _clockDate.minutes;
		}
		
		/**
		 * Clock	-	minutesRot	-	분 각도 반환
		 * @return	Number
		 */
		public function get minutesRot():Number
		{
			var rot:Number = 360 / 60;
			return rot * minutes;
		}
		
		/**
		 * Clock	-	seconds	-	초 반환
		 * @return	Number
		 */
		public function get seconds():Number
		{
			return _clockDate.seconds;
		}
		
		/**
		 * Clock	-	secondsRot	-	초 각도 반환
		 * @return	Number
		 */
		public function get secondsRot():Number
		{
			var rot:Number = 360 / 60;
			return rot * seconds;
		}
		
		/**
		 * Clock	-	milliseconds	-	밀리 세컨드 반환
		 * @return	Number
		 */
		public function get milliseconds():Number
		{
			return _clockDate.milliseconds;
		}
		
		/**
		 * Clock	-	millisecondsRot	-	밀리 세컨드 각도 반환
		 * @return	Number
		 */
		public function get millisecondsRot():Number
		{
			var rot:Number = 360 / 1000;
			return rot * milliseconds;
		}
		
		/**
		 * Clock	-	time	-	시간 반환
		 * @return	Number
		 */
		public function get time():Number
		{
			return _clockDate.time;
		}
		
	}

}