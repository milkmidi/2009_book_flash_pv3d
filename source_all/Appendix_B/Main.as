package  {			
	import flash.display.*;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;	
	public class Main extends Sprite {				
		private var _ldr:Loader
		public function Main() {
			_ldr = new Loader();
			//Loader物件。
			//_ldr.load(new URLRequest("Loaded.swf"));			
			//載入Loaded.swf。
			_ldr.load(new URLRequest("LoadedAddRemoveEvent.swf"));	
			//_ldr.load(new URLRequest("PV3DSkeleton.swf"));				
			this.addChild(_ldr);				
			//將Loader物件加入至目前的可視物件容器。
			unload_mc.buttonMode = true;		
			unload_mc.addEventListener(MouseEvent.CLICK, onUnloaderMCClick);			
			//偵聽。
		}				
		private function onUnloaderMCClick(e:MouseEvent):void {
			trace("unLoad()");
			_ldr.unload();
			//取消載入。
		}		
	}	
}