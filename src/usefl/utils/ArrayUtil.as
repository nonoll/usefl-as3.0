package usefl.utils 
{
	/**
	 * ArrayUtil
	 * @author nonoll
	 */
	public class ArrayUtil
	{
		
		/**
		 * 배열을 랜덤으로 섞어서 반환
		 * @param	$array	Array
		 * @return	Array
		 */
		public function arrayRandom( $array:Array ):Array
		{
			var return_array:Array = new Array();
			var lengthNum:Number = $array.length;
			for ( var i:Number = 0; i < lengthNum; i++ )
			{
				var index:Number = Math.floor( Math.random()*$array.length );
				return_array.push( $array[index] );
				$array.splice( index, 1 );
			}
			return return_array;
		}
		
		/**
		 * 배열 A B의 값 매칭
		 * @param	$arr1	Array
		 * @param	$arr2	Array
		 * @return	Boolean
		 */
		public function arraysAreEqual( $arr1:Array, $arr2:Array ):Boolean
		{
			if ( $arr1.length != $arr2.length )	return false;
			
			var len:Number = $arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if ( $arr1[i] != $arr2[i] )	return false;
			}			
			return true;
		}
		
	}

}