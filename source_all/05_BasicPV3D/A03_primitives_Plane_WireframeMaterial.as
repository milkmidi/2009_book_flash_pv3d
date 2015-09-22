package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.WireframeMaterial;
	//匯入材質包裡的線框材質。
	import org.papervision3d.objects.primitives.Plane	
	public class A03_primitives_Plane_WireframeMaterial extends MovieClip {		
		private var view		:BasicView;			
		private var plane		:Plane;		
		public function A03_primitives_Plane_WireframeMaterial():void {
			init3DEngine();			
			init3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DObject():void {			
			var wireMat:WireframeMaterial = new WireframeMaterial(0xA7C520, 1);
			//建立線框材質 new WireframeMaterial(色碼:uint , alpha:uint)
			wireMat.doubleSided = true;
			//開啟材質的雙面模式。
			plane = new Plane(wireMat, 300, 300, 3, 3);						
			//建立plane物件 plane(材質:Material ,寬:Number ,高:Number)
			view.scene.addChild(plane);			
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;
			view.singleRender();			
		}
	}
}