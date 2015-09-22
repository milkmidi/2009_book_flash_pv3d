package {
	import flash.display.MovieClip;
	import flash.events.Event;		
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.ColorMaterial;
	//匯入材質包裡的色彩材質。
	import org.papervision3d.objects.primitives.Plane
	//匯入基本物件包裡的Plane物件。
	public class A02_primitives_Plane extends MovieClip {		
		private var view		:BasicView;			
		private var plane		:Plane;
		//宣告plane變數, 型別為Plane。
		public function A02_primitives_Plane():void {
			init3DEngine();			
			initPV3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function initPV3DObject():void {			
			var colorMat:ColorMaterial = new ColorMaterial(0xA7C520, 1);			
			//建立色彩材質 new ColorMaterial(色碼:uint , 透明度:Number)。
			colorMat.doubleSided = true;
			//開啟材質的雙面模式, 預設為false。
			//如果沒開啟該模式, 當物件背對鏡頭時, 就會看不見。
			plane = new Plane(colorMat, 300, 300);
			//建立plane物件 new Plane(材質:Material ,寬:Number ,高:Number)
			view.scene.addChild(plane);
			//view.scene加入將plane物件。
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;
			//plane物件, rotationY每次加3。
			//以上程式可以寫成plane.rotationY = plane.rotationY +3;			
			view.singleRender();			
		}
	}
}