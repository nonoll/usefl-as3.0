package usefl.utils 
{
	/**
	*	<b>S-LOG 데이터의 표현을 관리</b></p>
	*	
	*	[ 세부기능 ]</p>
	*	1. 1000 > 1,000 "원 단위" 포맷으로 반환</p>
	*
	*	2. flag 옵션에 따른 1000 > 0시간16분40초 , 0:16:40 시간데이터 표현</p>
	*/
	import flash.globalization.CurrencyFormatter;
	
	/**
	 * DebugUtil
	 * @author nonoll
	 */
	public class CurrencyFormat 
	{
		
		public var _timeArr				:Array = [ "초", "분", "시간", "일", "개월", "년" ];
		
		/**	빈 생성자	*/
		public function CurrencyFormat()	{		}
		
		/**
		*	수치를 원화 단위로 변환 ( ex : 1000 > 1,000 )
		*
		*	@param	$money		변환할 수치
		*	@param	$flag		단위 표현 삭제 여부
		*	@param	$localID	변환할 단위
		*	@return	String
		*/
		public function getCurrencyToString( $money:Number, $flag:Boolean=true, $localID="kr-KOR" ):String
		{			
			var formatter:CurrencyFormatter = new CurrencyFormatter( $localID );
			var rtValue:String = formatter.format( $money );
			var chkStr:String = "";
			
			if( $flag )
			{
				switch( $localID )
				{
					case	"kr-KOR"	:						
						chkStr = "KRW";
						rtValue = rtValue.substr( chkStr.length, rtValue.length ); 
						break;
					
					default:						
				}				
			}
			
			return rtValue;
		}
		
		/**
		*	수치를 시간화 반환
		*	@param 	$time	변환할 수치
		*	@return	String
		*/
		public function getTimeToString( $time:Number, $flag:Boolean = false ):String
		{
			// 시 분 초 
			//123456			
			var cs:Number = $time;
			var cm:Number = Math.floor( $time/60 );
			var ch:Number = Math.floor( $time/3600 );
			
			var ss:String
			var sm:String
			var sh:String
			
			if( cs >= 60 )	ss = addZero( cs % 60 );			
			else			ss = addZero( cs );
			
			if( cm >= 60 )	sm = addZero( cm % 60 );
			else			sm = addZero( cm );
			
			sh = addZero( ch );
			
			sh = getCurrencyToString( Number( sh ) );
			
			if( $flag )		return sh + ":" + sm + ":" + ss;
			else			return sh + "시간" + sm + "분" + ss + "초";
		}
		
		/**
		*	수치를 시간화 반환 , 트랜드 범례에 사용
		*	@param 	$time	변환할 수치
		*	@param	$max	최대 변환 단위, 기본 3 ( " 일 " )
		*	@return	Object	{ value : ' ' , time: ' ' }
		*/
		public function restrictTime( $time:Number, $max:Number = 3 ):Object
		{
			var rtObj:Object = new Object();
			var rValue:Number = 0;
			var index:Number = 0;
			
			var cs:Number = $time;
			var cm:Number = Math.round( $time/60 );
			var ch:Number = Math.round( $time/3600 );
			var cd:Number = Math.round( $time/ ( 3600 * 24 ) );
			
			rValue = cs;
			
			if( cs >= 60 )	
			{
				index += 1;
				rValue = cm;
			}
			
			if( cm >= 60 )	
			{
				index += 1;
				rValue = ch;
			}
			
			if( ch >= 24 )	
			{
				index += 1;
				rValue = cd;
			}
			
			if( index > $max )	index = $max;
			
			rtObj = { value: rValue , time: _timeArr[ index ] };
			
			return rtObj; 			
		}
				
		/**
		*	수치를 디지털화
		*	@param	$num	변환할 수치
		*	@return	String
		*/
		public function addZero( $num:Number ):String
		{
			var rtValue:String = "0";
			
			$num = Math.floor( $num );
			
			if( $num < 10 )			return rtValue + String( $num );
			
			return	String( $num );
		}
		
	}

}