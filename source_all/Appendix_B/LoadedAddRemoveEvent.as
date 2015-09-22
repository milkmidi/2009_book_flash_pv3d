package  {		
	import flash.display.Sprite;
	import flash.events.Event;	
	public class LoadedAddRemoveEvent extends Sprite{		
		public function LoadedAddRemoveEvent() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			//當可視物件被加入至場景後, 會發出的事件。
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);			
			//當可視物件被移除後至場景, 會發出的事件。
		}			
		private function onRemovedFromStage(e:Event):void {
			//物件被移除, 所有有偵聽的事件也要手動取消掉。			
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, onEventEnterFrame);
		}		
		private function onAdd2Stage(e:Event):void {
			this.addEventListener(Event.ENTER_FRAME, onEventEnterFrame);
		}
		private function onEventEnterFrame(e:Event):void {
			trace(e);
		}		
	}	
}