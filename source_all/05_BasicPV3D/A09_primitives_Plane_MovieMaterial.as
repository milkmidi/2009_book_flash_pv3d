package {
	import flash.display.MovieClip;
	import flash.events.Event;	
	import org.papervision3d.materials.MovieMaterial;
	//匯入材質類別包下的影片片段材質。
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.objects.primitives.Plane	
	public class A09_primitives_Plane_MovieMaterial extends MovieClip {		
		private var view		:BasicView;			
		private var plane		:Plane;		
		public function A09_primitives_Plane_MovieMaterial():void {
			init3DEngine();			
			init3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DObject():void {			
			var movie:MovieClip = new MaterialMC();
			//先在元件庫裡，設定MaterialMC類別。
			//宣告變數movie，建構MaterialMC類別。
			var movieMat:MovieMaterial = new MovieMaterial(movie, true, true, true);
			//建立Movie材質 new MovieMaterial(MovieClip物件 ,是否透明:Boolean , 是否播放動畫:Boolean,精準模式:Boolean)
			movieMat.doubleSided = true;
			//開啟材質的雙面模式。			
			plane = new Plane(movieMat, 550, 550);			
			view.scene.addChild(plane);			
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;
			view.singleRender();			
		}
	}
}