package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.BitmapAssetMaterial;
	//匯入材質包下的點陣資產材質。
	import org.papervision3d.objects.primitives.Plane	
	public class A07_primitives_Plane_BitmapAssetMaterial extends MovieClip {		
		private var view		:BasicView;			
		private var plane		:Plane;		
		public function A07_primitives_Plane_BitmapAssetMaterial() {
			init3DEngine();			
			init3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DObject():void {			
			var bmpMat:BitmapAssetMaterial = new BitmapAssetMaterial("BitmapMat", true);
			/*
			建立點陣圖資產材質。
			new BitmapAssetMaterial(
				元件庫裡設定的類別	:String , 
				精準模式			:Boolean
				)
			*/
			bmpMat.doubleSided = true;
			//開啟材質的雙面模式。
			bmpMat.smooth = true;
			//開啟材質的平滑模式。			
			plane = new Plane(bmpMat, 550, 550);
			//建立plane物件 plane(材質:Material ,寬:Number ,高:Number)
			view.scene.addChild(plane);
			//將plane物件加入至view.scene物件
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;			
			view.singleRender();			
		}
	}
}