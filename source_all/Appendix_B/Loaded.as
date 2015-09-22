package  {		
	import flash.display.Sprite;
	import flash.events.Event;	
	public class Loaded extends Sprite{		
		public function Loaded() {
			this.addEventListener(Event.ENTER_FRAME, onEventEnterFrame);
		}				
		private function onEventEnterFrame(e:Event):void {
			trace(e);
		}		
	}	
}