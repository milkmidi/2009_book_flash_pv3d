package{	
	import flash.display.MovieClip;	
	import flash.events.Event;	
	import org.papervision3d.view.BasicView;	
	public class PV3DSkeleton extends MovieClip {			
		private var view:BasicView;				
		public function PV3DSkeleton():void{
			this.addEventListener(Event.ADDED_TO_STAGE , onAdd2Stage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			init3DEngine();			
			init3DObject();
		}		
		private function onAdd2Stage(e:Event):void {
			//當被加入至場景上時, 才開始Event.ENTER_FRAME事件。			
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");				
			this.addChild(view);				
		}
		private function init3DObject():void{			
		}
		private function onEventRender3D(e:Event):void {			
			view.singleRender();			
		}
		private function onRemovedFromStage(e:Event):void {
			view.viewport.destroy();
			//Viewport3D物件有個destroy函式, 能移除所有PV3D裡的物件。
			//取消偵聽事件。
			this.removeEventListener(Event.ADDED_TO_STAGE , onAdd2Stage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, onEventRender3D);	
		}
	}
}