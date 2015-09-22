package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Sphere
	//匯入基本物件包裡的Sphere球體物件。
	public class A04_primitives_Sphere extends MovieClip {		
		private var view		:BasicView;			
		private var sphere		:Sphere;
		//宣告sphere變數, 型別為Sphere。
		public function A04_primitives_Sphere():void {
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
			sphere = new Sphere(wireMat, 320, 12, 8);			
			//Sphere球體物件, new Sphere(材質:Material,半徑:Number,垂直切面數:int ,水平切面數:int)									
			view.scene.addChild(sphere);			
		}
		private function onEventRender3D(e:Event):void {
			sphere.rotationY += 3;			
			view.singleRender();			
		}
	}
}