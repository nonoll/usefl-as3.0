package usefl.utils 
{
	import flash.display.DisplayObject;
	
	/**
	 * NumberUtil
	 * @author nonoll
	 */
	public class NumberUtil 
	{
		
		/**
		 * NumberUtil	-	objIndex	-	객체의 인덱스값 추출 반환
		 * @param	$obj		DisplayObject
		 * @param	$idx		Number
		 * @param	$split		String
		 * @return	Number
		 */
		public function objIndex( $obj:DisplayObject, $idx:Number = 1, $delim:String = "_" ):Number
		{
			return Number( DisplayObject( $obj ).name.split( $delim )[ $idx ] );
		}
		
		/**
		 * NumberUtil	-	randomRange	-	최대 최소값 사이의 랜덤 값 추출
		 * @param	$min	Number	-	최소값
		 * @param	$max	Number	-	최대값
		 * @return	Number
		 * @example	최소값 1과 최대값 5사이의 랜덤값 추출 > randomRange( 1, 5 );
		 */
		public function randomRange( $min:Number, $max:Number ):Number
		{
			return Math.floor( Math.random() * ( $max - $min + 1 ) ) + $min;
		}
		
		/**
		 * NumberUtil	-	randomRangeArr	-	최대 최소값 사이의 일정수량내의 랜덤 값 추출
		 * @param	$min	Number	-	최소값
		 * @param	$max	Number	-	최대값
		 * @param	$leng	Number	-	구할 수량
		 * @return	Array
		 * @example	최소값 1과 최대값 9사이의 5개의 랜덤값 추출 > randomRangeArr( 1, 9, 5 );
		 */
		public function randomRangeArr( $min:Number, $max:Number, $leng:Number ):Array
		{
			var temp:Array = new Array();
			var rtn:Array = new Array();			
			for ( var i:int = $min; i <= $max; i++ )			temp[ i ] = i;
			for ( var i2:int = 0; i2 < $leng; i2++ )
			{
				var idx:Number = notUndefined( temp );
				if( !temp[ idx ] )		idx = Math.floor( Math.random() * temp.length );
				rtn.push( temp[ idx ] );
				temp.splice( idx, 1 );
			}			
			return rtn;
		}
		
		/**
		 * NumberUtil	-	notUndefined	-	빈 값이 아닌 값만 반환
		 * @param	$arr	Array
		 * @return	Number
		 */
		private function notUndefined( $arr:Array ):Number
		{
			var rtn:Number = Math.floor( Math.random() * $arr.length );
			if ( !$arr[ rtn ] )	
			{
				for ( var i:int = 0; i < $arr.length; i++ )
				{
					if ( !$arr[ i ] )
					{
						rtn = i;
						break;
					}
				}
			}
			return rtn;
		}
		
	}

}