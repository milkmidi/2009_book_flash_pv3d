package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.BitmapFileMaterial;
	//匯入材質包下的點陣圖材質。
	import org.papervision3d.objects.primitives.Plane	
	public class A08_primitives_Plane_BitmapFileMaterial extends MovieClip {		
		private var view		:BasicView;			
		private var plane		:Plane;		
		public function A08_primitives_Plane_BitmapFileMaterial():void {
			init3DEngine();			
			init3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DObject():void {			
			var bmpMat:BitmapFileMaterial = new BitmapFileMaterial("demo.jpg", true);
			//建立點陣圖檔案材質, new BitmapFileMaterial(圖片路徑:String , 精準模式:Boolean)
			bmpMat.doubleSided = true;						
			plane = new Plane(bmpMat, 550, 550);			
			view.scene.addChild(plane);			
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;
			view.singleRender();			
		}
	}
}