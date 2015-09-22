package {	
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.events.InteractiveScene3DEvent;	
	import caurina.transitions.Tweener;
	//匯入Tweener類別。
	public class A11_plane_camera_Tweener extends MovieClip{
		private var view		:BasicView;
		private var plane		:Plane;
		private var sphere		:Sphere;
		public function A11_plane_camera_Tweener():void{
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.viewport.buttonMode = true;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			var colorMat:ColorMaterial = new ColorMaterial(0x345676, 1, true);
			colorMat.doubleSided = true;
			colorMat.interactive = true;
			//所有的材質類別, 都有interactive互動屬性。
			
			plane = new Plane(colorMat, 300, 300);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DClick);
			view.scene.addChild(plane);
			
			var wireMat:WireframeMaterial = new WireframeMaterial(0x112233, 1, 2);
			sphere = new Sphere(wireMat, 100, 16, 16);
			sphere.x = 350;
			view.scene.addChild(sphere);
		}
		private function on3DClick(e:InteractiveScene3DEvent):void {
			//偵聽者偵聽到指定的事件後, 會執行該函式。
			//Camera物件是在view下的屬性
			//使用view.camera即可得到camera。
			Tweener.addTween(view.camera,{
				x	:1000,//修改camera的x軸屬性。
				y	:300,//修改camera的y軸屬性。
				time:2//在2秒鐘內完成。
			})
		}
		private function onEventRender3D(e:Event):void{
			sphere.rotationY += 3;
			//球體物件旋轉。
			view.singleRender();
		}
	}
}
