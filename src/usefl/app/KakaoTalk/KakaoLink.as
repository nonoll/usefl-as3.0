package usefl.app.KakaoTalk 
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * KakaoTalk
	 * @author nonoll
	 * @see http://www.kakao.com/link/ko/api
			http://kakao.github.io/kakaolink-web/
	 * @exampleText
	 * Custom URL Scheme - URL LINK
	 * kakaolink://sendurl?msg=[message]&url=[url]&appid=[appid]&appver=[appver]
	 *
	 * Custom URL Scheme - APP LINK
	 * kakaolink://sendurl?msg=[message]&url=[url]&appid=[appid]&appver=[appver]&type=[type]&appname=[appname]&apiver=[apiver]&metainfo=[metainfo]
	 *
	 * @example
	 	//	카톡 링크 전송
		import usefl.app.KakaoTalk.KakaoLink;
		var _kakaoLink:KakaoLink = new KakaoLink();
		_kakaoLink.openKakaoLink( "http://www.merry-go.com", "메리고라운드\n플래시어플 카톡메시지테스트", "appid", "appver", "메리고라운드" );
		
		//	카톡 앱링크 전송
		import usefl.app.KakaoTalk.KakaoLink;
		var _kakaoLink:KakaoLink = new KakaoLink();
		_kakaoLink.setMetainfo( "android", "market://details?id=com.kakao.talk", "kakaoagit://testtest", "phone" );
		_kakaoLink.setMetainfo( "ios", "items://itunes.apple.com/us/app/kakaotalk/id362057947?mt=8", "kakaoagit://testtest" );
		_kakaoLink.openKakaoAppLink( "http://www.merry-go.com", "메리고라운드\n플래시어플 카톡메시지테스트", "appid", "appver", "메리고라운드" );		
		
		//	카톡 앱링크 전송 - 실사용
		import usefl.app.KakaoTalk.KakaoLink;
		var _kakaoLink:KakaoLink = new KakaoLink();
		_kakaoLink.setMetainfo( "android", "market://details?id=air.nonollTest", "air://nonollTest", "phone" );
		_kakaoLink.setMetainfo( "ios", "items://itunes.apple.com/us/app/kakaotalk/id362057947?mt=8", "kakaoagit://testtest" );
		_kakaoLink.openKakaoAppLink( "http://usefl.co.kr", "컬투쇼 어플\n어플 다운 카톡테스트", "air.nonollTest", "1.0.0", "nonoll" );
	 */
	public class KakaoLink 
	{
		private static const _kakaoLinkApiVersion			:String = "2.0";
		private static const _kakaoLinkURLBaseString		:String = "kakaolink://sendurl";
		private var _params									:String = "";
		private var _androidMeta							:String = "";
		private var _iosMeta								:String = "";
		
		/**
		 * KakaoLink	-	openKakaoLink	-	카톡 링크 전송
		 * @param	$url		String
		 * @param	$message	String
		 * @param	$appId		String
		 * @param	$appVer		String
		 * @param	$appName	String
		 */
		public function openKakaoLink( $url:String, $message:String, $appId:String, $appVer:String, $appName:String ):void
		{
			this._params = getBaseKakaoLinkUrl();

			appendParam( "url", $url );
			appendParam( "msg", $message );
			appendParam( "apiver", _kakaoLinkApiVersion );
			appendParam( "appid", $appId );
			appendParam( "appver", $appVer );
			appendParam( "appname", $appName );
			appendParam( "type", "link" );

			sendKakaoLink( this._params );
		}
		
		/**
		 * KakaoLink	-	openKakaoAppLink	-	카톡 앱링크 전송
		 * @param	$url		String
		 * @param	$message	String
		 * @param	$appId		String
		 * @param	$appVer		String
		 * @param	$appName	String
		 */
		public function openKakaoAppLink( $url:String, $message:String, $appId:String, $appVer:String, $appName:String ):void
		{
			this._params = getBaseKakaoLinkUrl();

			appendParam( "url", $url );
			appendParam( "msg", $message );
			appendParam( "apiver", _kakaoLinkApiVersion );
			appendParam( "appid", $appId );
			appendParam( "appver", $appVer );
			appendParam( "appname", $appName );
			appendParam( "type", "app" );
			appendParam( "metainfo", getMetainfo() );

			sendKakaoLink( this._params );
		}
		
		/**
		 * KakaoLink	-	appendParam	-	파라미터값 추가
		 * @param	$name
		 * @param	$value
		 */
		private function appendParam( $name:String, $value:String ):void
		{		
			this._params += $name + "=" + $value + "&";
		}
		
		/**
		 * KakaoLink	-	setMetainfo	-	meta 파라미터 값 추가 ( JSON 형태 )
		 * @param	$os			String
		 * @param	$installurl	String
		 * @param	$executeurl	String
		 * @param	$devicetype	String
		 */
		public function setMetainfo( $os:String = "android", $installurl:String = "" , $executeurl:String = "", $devicetype:String = "" ):void
		{
			var meta:String = "";
			meta = "{ os: '" + $os + "' , installurl: '" + $installurl + "' , executeurl : '" + $executeurl + "'";
			if ( $devicetype != "" )	meta += " , devicetype: '" + $devicetype + "'";
			meta += "}";
			
			if ( $os == "android" )		_androidMeta = meta;
			else						_iosMeta = meta;
		}
		
		/**
		 * KakaoLink	-	setMetainfo	-	meta 파라미터 값 반환 ( JSON 형태 )
		 * @return	String
		 */
		private function getMetainfo():String
		{
			var returnStr:String = "{metainfo : [ ";
			returnStr += _androidMeta
			if ( _androidMeta != "" && _iosMeta != "" )	returnStr += " , ";
			returnStr += _iosMeta + " ] }";
			return returnStr;
		}
		
		/**
		 * KakaoLink	-	sendKakaoLink	-	링크 실행
		 * @param	$params	String
		 */
		private static function sendKakaoLink( $params:String ):void
		{
			trace( "sendKakaoLink : " + $params );
			navigateToURL( new URLRequest( $params ) );
		}
		
		/**
		 * KakaoLink	-	getBaseKakaoLinkUrl	-	기본 베이스 url 반환
		 * @return	String
		 */
		private static function getBaseKakaoLinkUrl():String
		{
			return _kakaoLinkURLBaseString + "?";
		}
	}

}