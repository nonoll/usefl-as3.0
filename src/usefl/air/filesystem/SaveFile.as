package usefl.air.filesystem 
{
	import usefl.air.filesystem.events.SaveFileEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * SaveFile
	 * @author nonoll
	 * @playerversion	AIR 1.0
	 * @example
		//	파일 옵션
			Array
			[
				{
					url: 파일경로,
					path: 저장경로,
					name: 저장 파일명 및 확장자
				}
			]
		
		
		//	기본 파일 저장
		import usefl.air.filesystem.SaveFile;
		import usefl.air.filesystem.events.SaveFileEvent;
		import flash.events.ProgressEvent;
		import flash.events.Event;

		var _fileList:Array = [ { url:"http://podcastfile.sbs.co.kr/powerfm/2013/05/power-pc-20130522(14-02).mp3", path:"D:/02_nonoll/01_Android/97_FileSave", name: "temp.mp3"  } ];
		var _saveFile:SaveFile = new SaveFile();
		_saveFile.init( _fileList );
		_saveFile.addEventListener( ProgressEvent.PROGRESS, onProgress );
		_saveFile.addEventListener( Event.COMPLETE, onLoaded );
		_saveFile.addEventListener( SaveFileEvent.SAVE_END, onSaveEnd );
		_saveFile.start();

		function onSaveEnd( $e:SaveFileEvent ):void
		{
			trace( "모든 저장 완료" );
		}
		function onProgress( $e:ProgressEvent ):void
		{
			var per:int = int( ( $e.bytesLoaded/$e.bytesTotal ) * 100 );
			trace( _saveFile.saveLeng + " 중 " + _saveFile.saveIndex + "개 저장중 : " + per + "%" );
		}

		function onLoaded( $e:Event ):void
		{
			trace( _saveFile.saveLeng + " 중 " + _saveFile.saveIndex + "개 저장 완료" );
		}
	 */
	public class SaveFile extends EventDispatcher
	{
		private var _file							:File;
		private var _fileStream						:FileStream;
		private var _saveIndex						:int = 0;
		private var _savePath						:String = "";
		private var _saveAllFlag					:Boolean = true;
		private var _isApp							:Boolean = false;
		private var _saveFileList					:Array = [];
		private var _saveByteArray					:ByteArray;
		private var _saveFileLoader					:URLLoader = new URLLoader();
		
		/**
		 * SaveFile	-	init	-	저장 파일 설정
		 * @param	$file
		 * @param	$saveAllFlag
		 * @param	$savePath
		 */
		public function init( $file:Array, $saveAllFlag:Boolean = true, $savePath:String = "" ):void
		{
			_saveFileList = $file;
			_saveAllFlag = $saveAllFlag;
			_savePath = $savePath;
			
			if ( _savePath == "" && _saveFileList[ 0 ].path == null || _saveFileList[ 0 ].path == "" )
			{
				throw new Error( "저장 Path 설정 오류!!" );
			}
		}
		
		public function set isApp( $b:Boolean ):void
		{
			_isApp = $b;
		}
		
		/**
		 * SaveFile	-	start	-	저장시작
		 */
		public function start():void
		{
			_saveIndex = 0;
			save( _saveFileList[ _saveIndex ].url );
		}
		
		/**
		 * SaveFile	-	save	-	저장
		 * @param	$file	String
		 */
		public function save( $file:String ):void
		{
			_saveFileLoader = new URLLoader();			
			_saveFileLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_saveFileLoader.load( new URLRequest( $file ) );
			_saveFileLoader.addEventListener( ProgressEvent.PROGRESS, loadProgress );
			_saveFileLoader.addEventListener( Event.COMPLETE, loaded );
			_saveFileLoader.addEventListener( IOErrorEvent.IO_ERROR, loadError );
		}
		
		/**
		 * SaveFile	-	loadProgress	-	저장파일 로딩중
		 * @param	$e
		 */
		private function loadProgress( $e:ProgressEvent ):void 
		{
			dispatchEvent( $e );
		}
		
		/**
		 * SaveFile	-	loaded	-	저장파일 로드 완료 및 실제 저장
		 * @param	$e
		 */
		private function loaded( $e:Event ):void 
		{
			_saveByteArray = _saveFileLoader.data;
			
			var folderPath:String = ( _savePath == "" ) ? _saveFileList[ _saveIndex ].path : _savePath;
			var fileName:String = _saveFileList[ _saveIndex ].name;
			var regExp:RegExp = new RegExp( /\//g );
			folderPath = folderPath.replace( regExp, File.separator );
			
			if ( !_isApp )
			{
				_file = new File( folderPath + File.separator + fileName );
				if ( _file.exists )		_file.deleteFile();
				_file = new File( folderPath + File.separator + fileName );
			}
			else
			{
				_file = File.documentsDirectory.resolvePath( folderPath + File.separator + fileName );
				if ( _file.exists )		_file.deleteFile();
				_file = File.documentsDirectory.resolvePath( folderPath + File.separator + fileName );
			}
			
			_fileStream = new FileStream();
			_fileStream.open( _file, FileMode.WRITE );
			_fileStream.writeBytes( _saveByteArray );
			_fileStream.close();
			
			_saveIndex++;
			dispatchEvent( $e );
			
			if ( _saveAllFlag )
			{
				if ( _saveIndex >= saveLeng )	end();
				else							save( _saveFileList[ _saveIndex ].url );
			}
			else
			{
				end();
			}
		}
		
		/**
		 * SaveFile	-	loadError	-	파일 로드 오류
		 * @param	$e	IOErrorEvent
		 */
		private function loadError( $e:IOErrorEvent ):void 
		{
			dispatchEvent( $e );
		}
		
		/**
		 * SaveFile	-	end	-	모든 파일 저장 완료
		 */
		private function end():void 
		{
			var saveEvent:SaveFileEvent = new SaveFileEvent( SaveFileEvent.SAVE_END );
			dispatchEvent( saveEvent );
			
			_saveFileLoader.removeEventListener( ProgressEvent.PROGRESS, loadProgress );
			_saveFileLoader.removeEventListener( Event.COMPLETE, loaded );
			_saveFileLoader.removeEventListener( IOErrorEvent.IO_ERROR, loadError );
		}
		
		/**
		 * SaveFile	-	saveIndex	-	저장순번 반환
		 */
		public function get saveIndex():int
		{
			return _saveIndex;
		}
		
		/**
		 * SaveFile	-	saveIndex	-	저장순번 지정
		 */
		public function set saveIndex( $idx:int ):void
		{
			_saveIndex = $idx;
		}
		
		/**
		 * SaveFile	-	saveLeng	-	저장수량 반환
		 */
		public function get saveLeng():int
		{
			return _saveFileList.length;
		}
		
	}

}