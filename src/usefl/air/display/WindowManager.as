package usefl.air.display 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author nonoll
	 */
	public class WindowManager
	{
		private static const _windowMargin					:Object = { width: 16, height: 38 };
		
		public function WindowManager() 
		{
		}
		
		public function BasicWindow( $width:int = 400, $height:int = 300, $title:String = "New Window" )
		{
			var initOptions:NativeWindowInitOptions = createInitOptions();
			var window:NativeWindow = new NativeWindow( initOptions );
			
			window.width = $width + _windowMargin.width;
			window.height = $height + _windowMargin.height;
			window.title = $title;
			
			window.stage.align = StageAlign.TOP_LEFT;
			window.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			return window;
		}
		
		protected function createInitOptions():NativeWindowInitOptions
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			return options;
		}
		
	}

}