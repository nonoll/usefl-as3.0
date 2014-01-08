package usefl.utils 
{
	import flash.utils.ByteArray;
	
	/**
	 * StringUtil
	 * @author nonoll
	 */
	public class StringUtil 
	{
		public static const CHARSET_EUC_KR					:String = "euc_kr";
		public static const CHARSET_UTF_8					:String = "utf-8";
		
		/**
		 * StringUtil	-	getStrBytes	-	문자열 바이트 반환
		 * @param	$str	String
		 * @return	Number
		 * @example
			//	기본 문자열 바이트 체크
			import usefl.utils.StringUtil;

			var _strUtil:StringUtil = new StringUtil();
			trace( _strUtil.getStrBytes( "한글 eng 바이트 체크!" ) );	//	21
			
			
			//	UTF-8 문자열 바이트 체크
			import usefl.utils.StringUtil;

			var _strUtil:StringUtil = new StringUtil();
			trace( _strUtil.getStrBytes( "한글 eng 바이트 체크!", _strUtil.CHARSET_UTF_8 ) );	//	28
		 */
		public function getStrBytes( $str:String, $charSet:String = "euc-kr" ):Number
		{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte( $str, $charSet );
			byte.position = 0;
			
			return byte.bytesAvailable;
		}
		
		/**
		 * StringUtil	-	getStrIsKOR	-	문자열 한글 체크
		 * @param	$str			String
		 * @param	$startIndex		Number
		 * @param	$endIndex		Number
		 * @param	$chkIndex		int		자른 문자열에서 몇번째 문자를 체크할것인지
		 * @return	Boolean
		 * @example
			import usefl.utils.StringUtil;

			var _strUtil:StringUtil = new StringUtil();
			trace( _strUtil.getStrIsKOR( "한e", 0, 1, 0 ) );	//	true
			trace( _strUtil.getStrIsKOR( "한e", 1, 1, 0 ) );	//	false
		 */
		public function getStrIsKOR( $str:String, $startIndex:Number = 0, $endIndex:Number = 1, $chkIndex:int = 0 ):Boolean
		{
			var chkStr:String = $str.substr( $startIndex, $endIndex );
			if( chkStr.charCodeAt( $chkIndex ) >= 12593 )		return true;
			else												return false;
		}
		
		/**
		* StringUtil	-	getRestrictBytes	-	문자열 말줄임
		* @param	$str		String
		* @param	$bytes		int
		* @param	$eventFnc	Function
		* @param	$replaceStr	String
		* @param	$charSet	String
		* @example
			import usefl.utils.StringUtil;

			var _strUtil:StringUtil = new StringUtil();
			trace( _strUtil.getRestrictBytes( "이렇게 긴 문자열을 알아서" ) );	//	이렇게 긴 문자열을 ...
		*/
		public function getRestrictBytes( $str:String, $bytes:int = 20, $eventFnc:Function = null, $replaceStr:String = "...", $charSet:String = "euc-kr" ):String
		{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte( $str, $charSet );
			byte.position = 0;
			
			/**	$str이 $bytes에 미달시 $str 반환		*/
			if( byte.bytesAvailable < $bytes )	return $str;
			
			var restrictedByte:ByteArray = new ByteArray();
			byte.readBytes( restrictedByte, 0, $bytes );
			restrictedByte.position = 0;
			
			var rtn:String = restrictedByte.readMultiByte( restrictedByte.length, $charSet );
			
			/**	한글 반환시 2바이트 미만시 "?" 값 오류 설정	*/
			rtn = ( rtn.indexOf( "?" ) == rtn.length - 1 ) ? rtn.substr( 0, rtn.length - 1 ) : rtn;
			
			if( $str != rtn )
			{
				rtn += $replaceStr;
				if( $eventFnc != null )		$eventFnc();
			}			
			return rtn;
		}
		
		/**
		 * StringUtil	-	replace	-	문자열 치환( 기본 String.replace 와 다름 )
		 * @param	$str		String
		 * @param	$oldStr		String
		 * @param	$newStr		String
		 * @return	String
		 */
		public function replace( $str:String, $oldStr:String, $newStr:String ):String
		{
			return $str.split( $oldStr ).join( $newStr );
		}
		
	}

}