package usefl.air.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	/**
	 * NetAirUtil
	 * @author nonoll
	 * @playerversion	AIR 2
	 * @example
		// 기본 네트워크 상태 체크 - NETWORK_CHANGE 를 통해 변경 상태를 계속 체크 가능
		import usefl.air.net.NetAirUtil;
		import flash.events.Event;

		var _netAirUtil:NetAirUtil = new NetAirUtil();
		NativeApplication.nativeApplication.addEventListener( Event.NETWORK_CHANGE, onChangeNetwork );
		function onChangeNetwork( $e:Event = null ):void
		{
			trace( "isWifi : " + _netAirUtil.isWifi );
			trace( "isMobile : " + _netAirUtil.isMobile );
			trace( "isMacAddress : " + _netAirUtil.isMacAddress );
		}
		onChangeNetwork();
	 */
	public class NetAirUtil extends EventDispatcher
	{
		public static const NET_WIFI					:String = "wifi";
		public static const NET_MOBILE					:String = "mobile";
		private var _interfaces							:Vector.< NetworkInterface >;
		
		/**
		 * NetAirUtil	-	isWifi	-	Wi-Fi 설정 판단
		 */
		public function get isWifi():Boolean
		{
			_interfaces = NetworkInfo.networkInfo.findInterfaces();
			
			for( var i:uint = 0; i < _interfaces.length; i++ )
			{
				if( _interfaces[ i ].name.toLowerCase() == NET_WIFI && _interfaces[ i ].active )	return true;
			}
			return false;
		}
		
		
		/**
		 * NetAirUtil	-	isMobile	-	데이터 네트워크 설정 판단
		 */
		public function get isMobile():Boolean
		{
			_interfaces = NetworkInfo.networkInfo.findInterfaces();
			
			for( var i:uint = 0; i < _interfaces.length; i++ )
			{
				if( _interfaces[ i ].name.toLowerCase() == NET_MOBILE && _interfaces[ i ].active )	return true;
			}
			return false;
		}
		
		/**
		 * NetAirUtil	-	isMacAddress	-	MacAdress 반환
		 */
		public function get isMacAddress():String
		{
			_interfaces = NetworkInfo.networkInfo.findInterfaces();
			
			for( var i:uint = 0; i < _interfaces.length; i++ )
			{
				//if( _interfaces[ i ].hardwareAddress != null && _interfaces[ i ].active )	return _interfaces[ i ].hardwareAddress;
				if( _interfaces[ i ].hardwareAddress != "" )	return _interfaces[ i ].hardwareAddress;
			}
			return "MacAddress not found";
		}
		
	}

}