package usefl.display 
{
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * DrawLine
	 * @author nonoll
	 * @example
		//	기본 설정값 - 펜 스타일
	 	import usefl.display.DrawLine;

		var _draw:DrawLine = new DrawLine( this.stage );
		
		
		//	펜 스타일 미사용
		import usefl.display.DrawLine;

		var _draw:DrawLine = new DrawLine( this.stage );
		_draw.penLineStyle = false;
		
		
		//	설정 가능한 사항들
		import usefl.display.DrawLine;

		var _draw:DrawLine = new DrawLine( this.stage );
		_draw.penAlpha = 1;
		_draw.penColor = 0x000000;
		_draw.penColorRandom = false;
		_draw.penLineStyle = true;
		_draw.penSize = 3;
	 */
	public class DrawLine 
	{
		private var _drawStage						:*;
		private var _drawBoard						:Sprite;
		private var _drawClip						:Sprite;
		private var _penSize						:Number = 3;
		private var _penColor						:uint = 0x000000;
		private var _penColorRandom					:Boolean = false;
		private var _penAlpha						:Number = 1;
		private var _penStartX						:Number = 0;
		private var _penStartY						:Number = 0;
		private var _penPressTime					:Number = 0;
		private var _penStyle						:Boolean = true;
		
		/**
		 * DrawLine
		 * @param	$displayStage	DisplayObject
		 * @param	$penSize		Number
		 * @param	$penColor		uint
		 * @param	$penAlpha		Number
		 */
		public function DrawLine( $displayStage:*, $penSize:Number = 3, $penColor:uint = 0x000000, $penAlpha:Number = 1 )
		{
			_drawStage = $displayStage;
			_penSize = $penSize;
			_penColor = $penColor;
			_penAlpha = $penAlpha;
			
			init();
		}
		
		/**
		 * DrawLine	-	init	-	드로우 이벤트 설정
		 */
		private function init():void
		{
			_drawBoard = new Sprite();
			_drawClip = new Sprite();
			
			_drawBoard.addChild( _drawClip );
			_drawStage.addChild( _drawBoard );
			
			_drawStage.addEventListener( MouseEvent.MOUSE_DOWN, onDrawStageDown );
			_drawStage.addEventListener( MouseEvent.MOUSE_UP, onDrawStageUp );
			_drawStage.addEventListener( MouseEvent.ROLL_OUT, onDrawStageUp );
		}
		
		/**
		 * DrawLine	-	onDrawStageDown	-	마우스 다운 이벤트
		 * @param	$e	MouseEvent
		 */
		private function onDrawStageDown( $e:MouseEvent ):void
		{
			_penPressTime = getTimer();
			
			_drawClip.graphics.lineStyle( _penSize, _penColor, _penAlpha );
			_drawClip.graphics.moveTo( _drawStage.mouseX, _drawStage.mouseY );
			_drawStage.addEventListener( MouseEvent.MOUSE_MOVE, onDrawStageMove );
		}
		
		/**
		 * DrawLine	-	onDrawStageUp	-	마우스 업 & 롤아웃 이벤트
		 * @param	$e	MouseEvent
		 */
		private function onDrawStageUp( $e:MouseEvent ):void
		{
			_drawStage.removeEventListener( MouseEvent.MOUSE_MOVE, onDrawStageMove );
		}
		
		/**
		 * DrawLine	-	onDrawStageMove	-	마우스 무브 이벤트
		 * @param	$e	MouseEvent
		 */
		private function onDrawStageMove( $e:MouseEvent ):void
		{
			_drawClip.graphics.lineTo( _drawStage.mouseX, _drawStage.mouseY );
			
			//	설정에 따른 펜글씨 효과 설정
			if ( _penStyle )
			{
				if ( Math.abs( _penStartX - _drawStage.mouseX ) < 10 && Math.abs( _penStartY - _drawStage.mouseY ) < 10 )
				{
					_penSize++;
					if ( _penSize >= 10 ) _penSize = 10;
				}
				else if ( Math.abs( _penStartX - _drawStage.mouseX ) < 50 && Math.abs( _penStartY - _drawStage.mouseY ) < 50 )
				{
					_penSize--;
					if ( _penSize <= 0 ) _penSize = 1;
				}
			}
			
			//	설정에 따른 랜덤색상 효과 설정
			if ( _penColorRandom )	randomColor();
			_drawClip.graphics.lineStyle( _penSize, _penColor, _penAlpha );
			
			_penStartX = _drawClip.mouseX;
			_penStartY = _drawClip.mouseY;
		}
		
		/**
		 * DrawLine	-	randomColor	-	랜덤 색상 값 추출
		 */
		private function randomColor():void
		{
			_penColor = argbTohex( 255, minMaxRange(0, 255), minMaxRange(0, 255), minMaxRange(0, 255) );
		}
		
		/**
		 * DrawLine	-	argbTohex	-	rgb값 설정
		 * @param	$a	Number
		 * @param	$r	Number
		 * @param	$g	Number
		 * @param	$b	Number
		 * @return	uint
		 */
		private function argbTohex( $a:Number, $r:Number, $g:Number, $b:Number ):uint
		{
			return	( $a<<24 | $r<<16 | $g<<8 | $b );
		}
		
		/**
		 * DrawLine	-	minMaxRange	-	드로우용 랜덤값 추출
		 * @param	$min	int
		 * @param	$max	int
		 * @return	int
		 */
		private function minMaxRange( $min:int, $max:int ):int
		{
			return int( Math.random() * $max ) + $min;
		}
		
		/**
		 * DrawLine	-	penLineStyle	-	드로잉 펜 스타일 설정
		 */
		public function set penLineStyle( $b:Boolean ):void
		{
			_penStyle = $b;
		}
		
		/**
		 * DrawLine	-	penAlpha	-	드로잉 펜 알파값 설정
		 */
		public function set penAlpha( $alpha:Number ):void
		{
			_penAlpha = $alpha;
		}
		
		/**
		 * DrawLine	-	penColor	-	드로잉 펜 색상값 설정
		 */
		public function set penColor( $color:uint ):void
		{
			_penColor = $color;
		}
		
		/**
		 * DrawLine	-	penColorRandom	-	드로잉 펜 랜덤색상 설정
		 */
		public function set penColorRandom( $b:Boolean ):void
		{
			_penColorRandom = $b;
		}
		
		/**
		 * DrawLine	-	penSize	-	드로잉 펜 사이즈 설정
		 */
		public function set penSize( $size:Number ):void
		{
			_penSize = $size;
		}
		
	}

}
