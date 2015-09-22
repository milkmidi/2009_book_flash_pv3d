package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.events.InteractiveScene3DEvent;
	//匯入3D互動事件類別
	public class A10_primitives_Plane_Interactive extends MovieClip {
		private var view		:BasicView;
		private var plane		:Plane;
		public function A10_primitives_Plane_Interactive():void {
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			//BasicView建構時, 第四個參數需要設成true,才可以捕抓到滑鼠事件。
			view.viewport.buttonMode = true;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			var colorMat:ColorMaterial = new ColorMaterial(0xA7C520, 1);
			colorMat.doubleSided = true;
			colorMat.interactive = true;
			//開啟材質的互動模式。
			plane = new Plane(colorMat, 550, 550);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DClick);
			//偵聽者on3DClick,偵聽plane物件所發出來的InteractiveScene3DEvent.OBJECT_CLICK事件。
			view.scene.addChild(plane);
		}
		private function on3DClick(e:InteractiveScene3DEvent):void{
			trace(e);
			//將值輸出至輸出面版, 做個測試。
		}
		private function onEventRender3D(e:Event):void {
			plane.rotationY += 3;
			view.singleRender();
		}
	}
}
