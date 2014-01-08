package usefl.core.ui
{	
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	
	/**
	 * ContextMenuMRG
	 * @author nonoll
	 * @example
		//	기본 컨텍스트 메뉴
	 	import usefl.core.ui.ContextMenuMRG;

		var _contextMenuMRG:ContextMenuMRG = new ContextMenuMRG( this );
		_contextMenuMRG.addFileName( "Design by Merry Go Round.", true );
		_contextMenuMRG.addCopyRight();
		
		
		//	프로젝트명 추가
		import usefl.core.ui.ContextMenuMRG;

		var _contextMenuMRG:ContextMenuMRG = new ContextMenuMRG( this );
		_contextMenuMRG.addVersion( "Project Name", "Ver 1.0.0", true );
		_contextMenuMRG.addFileName( "Design by Merry Go Round.", true );
		_contextMenuMRG.addCopyRight();
		
		
		//	링크 이동 미사용
		import usefl.core.ui.ContextMenuMRG;

		var _contextMenuMRG:ContextMenuMRG = new ContextMenuMRG( this );
		_contextMenuMRG.addVersion( "Project Name", "Ver 1.0.0", true );
		_contextMenuMRG.addFileName( "Design by Merry Go Round.", true );
		_contextMenuMRG.addCopyRight( _contextMenuMRG.DEFAULT_COPY, "" );
		
		
		//	커스텀 컨텍스트 메뉴 활용
		import usefl.core.ui.ContextMenuMRG;
		import flash.ui.ContextMenuItem;
		import flash.events.ContextMenuEvent;

		var _contextMenuMRG:ContextMenuMRG = new ContextMenuMRG( this );
		var _addCustomItem:ContextMenuItem = new ContextMenuItem( "addCustomItem" );
		_addCustomItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, addCustomItemSelect );
		function addCustomItemSelect( $e:ContextMenuEvent ):void
		{
			trace( "addCustomItemSelect" );
		}
		_contextMenuMRG.addCustomMenuItems( _addCustomItem );
	 */
	public class ContextMenuMRG
	{
		private var _parentMenu						:ContextMenu;
		private var _copyItem						:ContextMenuItem;
		private var _fileName						:ContextMenuItem;
		private var _versionItem					:ContextMenuItem;
		private var _copyURL						:String;
		public static const DEFAULT_COPY			:String = "COPYRIGHT 2013 MERRY GO GROUND ALL RIGHTS RESERVED.";
		public static const DEFAULT_COPY_URL		:String = "http://www.merry-go.com";
		
		/**
		 * ContextMenuMRG
		 * @param $this
		 */	
		public function ContextMenuMRG( $this )
		{	
			_parentMenu = new ContextMenu();
			
			_parentMenu.hideBuiltInItems();
			$this.contextMenu = _parentMenu;
		}
		
		/**
		 * ContextMenuMRG	-	removeDefaultItems	-	기본 컨텍스트메뉴 비활성화
		 */
		public function removeDefaultItems():void
		{
			_parentMenu.hideBuiltInItems();
		}
		
		/**
		 * ContextMenuMRG	-	addCopyRight	-	컨텍스트메뉴 카피 설정
		 * @param $copy		String	문구
		 * @param $url		String	링크
		 * @param $flag		Boolean	활성화유무
		 */
		public function addCopyRight( $copy:String = "COPYRIGHT 2013 MERRY GO GROUND ALL RIGHTS RESERVED.", $url:String = "http://www.merry-go.com", $flag:Boolean = true ):void
		{
			_copyItem = new ContextMenuItem( $copy, false, $flag );
			addCustomMenuItems( _copyItem );
			
			if ( $url.length > 1 )
			{
				_copyURL = $url;
				_copyItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, selectHandler );
			}
		}
		
		/**
		 * ContextMenuMRG	-	selectHandler	-	컨텍스트메뉴 카피 클릭 이벤트
		 * @param $e		ContextMenuEvent
		 */
		public function selectHandler( $e:ContextMenuEvent ):void
		{
			navigateToURL( new URLRequest( _copyURL ) , "_blank" );
		}
		
		/**
		 * ContextMenuMRG	-	addFileName	-	컨텍스트메뉴 파일명 설정
		 * @param $file		String	파일명
		 * @param $flag		Boolean	활성화유무
		 */
		public function addFileName( $file:String, $flag:Boolean = false ):void
		{
			_fileName = new ContextMenuItem( $file, false, $flag );
			addCustomMenuItems( _fileName );
		}
		
		/**
		 * ContextMenuMRG	-	addVersion	-	컨텍스트메뉴 버전정보 설정
		 * @param $file	파일명
		 * @param $version	버전정보
		 * @param $flag	활성화유무
		 */
		public function addVersion( $file:String = "", $version:String = "Ver", $flag:Boolean = false ):void
		{
			var str:String;
			
			if ( $file.length > 1 )		str = $file + " - " + $version;
			else						str = $version;
			
			_versionItem = new ContextMenuItem( str, false, $flag );
			addCustomMenuItems( _versionItem );
		}
		
		/**
		 * ContextMenuMRG	-	addCustomMenuItems	-	컨텍스트메뉴 아이템 등록
		 */
		public function addCustomMenuItems( $item ):void 
		{
			_parentMenu.customItems.push( $item );
		}
		
	}
}