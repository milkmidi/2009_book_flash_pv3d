package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.materials.utils.MaterialsList;
	//匯入材質列表類別。
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Cube;
	//匯入基本物件包裡的Cube方塊物件。
	public class A05_primitives_Cube extends MovieClip {		
		private var view		:BasicView;			
		private var cube		:Cube;
		//宣告cube變數, 型別為Cube。
		public function A05_primitives_Cube():void {
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
			var ml		:MaterialsList = new MaterialsList( { all:wireMat } );
			//宣告ml變數, 型別為MaterialsList, 在建構時, 如果要六面都貼一樣的材質
			//使用all即可。
			cube = new Cube(ml, 400, 400, 400);						
			//建立Cube方塊物件  new Cube(材質列表:MaterialsList,寬:Number,高:Number,深:Number)			
			view.scene.addChild(cube);			
		}
		private function onEventRender3D(e:Event):void {
			cube.rotationY += 3;
			cube.rotationX += 3;
			view.singleRender();			
		}
	}
}