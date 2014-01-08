package usefl.utils 
{
	import usefl.utils.events.NetUtilEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * NetUtil
	 * @author nonoll
	 */
	public class NetUtil extends EventDispatcher
	{
		private static const IE_CHECK_JS					:String = "function() {if(document.all) return 1; else return 0;}";
		private static const IE_OPEN_JS						:String = "window.open";
		private static const IP_INFORMATION					:String = "http://xml.utrace.de/?query=";
		private static const IP_CHECK_PHP					:String = "http://en.utrace.de/ip-address/";
		/*
		private static final var IP_CHECK_PHP			:String = "http://www.usefl.co.kr/php/net/getIP.php";
		* @exampleText
			PHP CODE
			<?php
				$ip = $_SERVER[ "REMOTE_ADDR" ];
				echo $ip;
			?>
		*/
		private static var _ipCheckLoader				:URLLoader = new URLLoader();
		private static var _ipInfoLoader				:URLLoader = new URLLoader();
		private static var _domainInfoLoader			:URLLoader = new URLLoader();
		private static var _pingCheckLoader				:URLLoader = new URLLoader();
		
		
		/**
		 * NetUtil	-	openWin	-	새창으로 url 열기
		 * @param	$url		*
		 * @param	$target		String
		 */
		public function openWin( $url:*, $target:String = "_blank" ):void
		{
			var request:URLRequest = ( $url is String ) ? new URLRequest( $url ) : $url;
			
			if( !ExternalInterface.available )
			{
				navigateToURL( request, $target );
				return;
			}
			
			var isIE:Boolean = Boolean( ExternalInterface.call( IE_CHECK_JS ) );
			
			if( isIE )		ExternalInterface.call( IE_OPEN_JS, request.url );
			else			navigateToURL( request, $target );
		}
		
		/**
		 * NetUtil	-	getIP	-	IP 확인 ( 기본적으로 http://en.utrace.de/ 사이트를 통하여 확인 )
		 * @see		http://en.utrace.de/
		 * @example
			import usefl.utils.NetUtil;
			import usefl.utils.events.NetUtilEvent;

			var _netUtil:NetUtil = new NetUtil();
			_netUtil.getIP();
			_netUtil.addEventListener( NetUtilEvent.GET_IP, onGetIP );
			function onGetIP( $e:NetUtilEvent ):void
			{
				trace( $e.data );
			}
		 */
		public function getIP():void
		{
			_ipCheckLoader.load( new URLRequest( IP_CHECK_PHP ) );
			_ipCheckLoader.addEventListener( Event.COMPLETE, onIpCheckLoaded );
		}
		
		/**
		 * NetUtil	-	onIpCheckLoaded	-	IP 확인 완료
		 * @param	$e	Event
		 */
		private function onIpCheckLoaded( $e:Event ):void
		{
			var htmlStr:String = String( $e.target.data );
			var checkStr:String = 'The IP address "';
			var frontIdx:Number = htmlStr.indexOf( checkStr ) + checkStr.length;
			var parsingStr:String = htmlStr.substr( frontIdx, 20 );
			parsingStr = parsingStr.substr( 0, parsingStr.indexOf( '"' ) );
			
			var netUtilEvent:NetUtilEvent = new NetUtilEvent( NetUtilEvent.GET_IP, parsingStr );
			dispatchEvent( netUtilEvent );
		}
		
		/**
		 * NetUtil	-	getIP_infomation	-	IP 주소 정보 확인
		 * @param	$ip	String
		 * @see		http://en.utrace.de/api.php
		 * @example
			//	IP 주소 입력하여 정보 확인
			import usefl.utils.NetUtil;
			import usefl.utils.events.NetUtilEvent;

			var _netUtil:NetUtil = new NetUtil();
			_netUtil.getIP_infomation( "112.218.38.140" );
			_netUtil.addEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );

			function onGetInfo( $e:NetUtilEvent ):void
			{
				var xml:XML = new XML( $e.data );
				var xmlList:XMLList = xml.result;
				
				trace( "IP_INFORMATION : " + "\n" + xmlList + "\n" );
				trace( "IP_INFORMATION Parsing :" );
				trace( "ip : " + xmlList.ip );
				trace( "host : " + xmlList.host );
				trace( "org : " + xmlList.org );
				trace( "region : " + xmlList.region );
				trace( "countrycode : " + xmlList.countrycode );
				trace( "latitude : " + xmlList.latitude );
				trace( "longitude : " + xmlList.longitude );
				trace( "queries : " + xmlList.queries );
				
				_netUtil.removeEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );
			}

			//	IP 주소 체크 및 정보 확인
			import usefl.utils.NetUtil;
			import usefl.utils.events.NetUtilEvent;

			var _netUtil:NetUtil = new NetUtil();
			_netUtil.getIP();
			_netUtil.addEventListener( NetUtilEvent.GET_IP, onGetIP );
			function onGetIP( $e:NetUtilEvent ):void
			{
				trace( "IP : " + $e.data + "\n" );
				_netUtil.getIP_infomation( String( $e.data ) );
				
				_netUtil.removeEventListener( NetUtilEvent.GET_IP, onGetIP );
				_netUtil.addEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );
			}

			function onGetInfo( $e:NetUtilEvent ):void
			{
				var xml:XML = new XML( $e.data );
				var xmlList:XMLList = xml.result;
				
				trace( "IP_INFORMATION : " + "\n" + xmlList + "\n" );
				trace( "IP_INFORMATION Parsing :" );
				trace( "ip : " + xmlList.ip );
				trace( "host : " + xmlList.host );
				trace( "org : " + xmlList.org );
				trace( "region : " + xmlList.region );
				trace( "countrycode : " + xmlList.countrycode );
				trace( "latitude : " + xmlList.latitude );
				trace( "longitude : " + xmlList.longitude );
				trace( "queries : " + xmlList.queries );
				
				_netUtil.removeEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );
			}
		 */
		public function getIP_infomation( $ip:String ):void
		{
			_ipInfoLoader.load( new URLRequest( IP_INFORMATION + $ip ) );
			_ipInfoLoader.addEventListener( Event.COMPLETE, onIPnDomainChecked );
		}
		
		/**
		 * NetUtil	-	getDomain_infomation	-	도메인 주소 정보 확인
		 * @param	$domain	String
		 * @see		http://en.utrace.de/api.php
		 * @example
			//	도메인 주소 입력하여 정보 확인
			import usefl.utils.NetUtil;
			import usefl.utils.events.NetUtilEvent;

			var _netUtil:NetUtil = new NetUtil();
			_netUtil.getDomain_infomation( "naver.com" );
			_netUtil.addEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );

			function onGetInfo( $e:NetUtilEvent ):void
			{
				var xml:XML = new XML( $e.data );
				var xmlList:XMLList = xml.result;
				
				trace( "DOMAIN_INFORMATION : " + "\n" + xmlList + "\n" );
				trace( "DOMAIN_INFORMATION Parsing :" );
				trace( "ip : " + xmlList.ip );
				trace( "host : " + xmlList.host );
				trace( "org : " + xmlList.org );
				trace( "region : " + xmlList.region );
				trace( "countrycode : " + xmlList.countrycode );
				trace( "latitude : " + xmlList.latitude );
				trace( "longitude : " + xmlList.longitude );
				trace( "queries : " + xmlList.queries );
				
				_netUtil.removeEventListener( NetUtilEvent.GET_INFORMATION, onGetInfo );
			}
		 */
		public function getDomain_infomation( $domain:String ):void
		{
			_domainInfoLoader.load( new URLRequest( IP_INFORMATION + $domain ) );
			_domainInfoLoader.addEventListener( Event.COMPLETE, onIPnDomainChecked );
		}
		
		/**
		 * NetUtil	-	onIPnDomainChecked	-	IP & 도메인 정보 확인 완료
		 * @param	$e	Event
		 */
		private function onIPnDomainChecked( $e:Event ):void
		{
			var netUtilEvent:NetUtilEvent = new NetUtilEvent( NetUtilEvent.GET_INFORMATION, $e.target.data );
			dispatchEvent( netUtilEvent );
		}
		
		/**
		 * NetUtil	-	getOnlie	-	인터넷 상태 체크
		 * @example
			//	인터넷 상태 체크 ( onLine = true , offLine = false );
			import usefl.utils.NetUtil;
			import usefl.utils.events.NetUtilEvent;

			var _netUtil:NetUtil = new NetUtil();
			_netUtil.getOnline();
			_netUtil.addEventListener( NetUtilEvent.GET_ONLINE, onGetInfo );

			function onGetInfo( $e:NetUtilEvent ):void
			{
				trace( $e.data );
				_netUtil.removeEventListener( NetUtilEvent.GET_ONLINE, onGetInfo );
			}
		 */
		public function getOnline():void
		{
			var pingReq:URLRequest = new URLRequest();
			pingReq.url = "http://www.google.com";
			
			_pingCheckLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onPingStatus );
			_pingCheckLoader.load( pingReq );
		}
		
		/**
		 * NetUtil	-	onPingStatus	-	인터넷상태 체크 완료
		 * @param	$e	HTTPStatusEvent
		 */
		private function onPingStatus( $e:HTTPStatusEvent ):void
		{
			var data:Boolean = ( $e.status == 0 ) ? false : true;
			var netUtilEvent:NetUtilEvent = new NetUtilEvent( NetUtilEvent.GET_ONLINE, data );
			dispatchEvent( netUtilEvent );
		}
		
	}
	
}