package{
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import caurina.transitions.Tweener;
	public class A12_plane_FreeCamera_Tweener extends MovieClip{
		private var view		:BasicView;
		private var plane		:Plane;
		private var sphere		:Sphere;
		public function A12_plane_FreeCamera_Tweener():void{
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Free");			
			view.viewport.buttonMode = true;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			var colorMat	:ColorMaterial = new ColorMaterial(0x345676, 1, true);
			colorMat.doubleSided = true;
			colorMat.interactive = true;
			
			plane = new Plane(colorMat, 300, 300);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DClick);
			view.scene.addChild(plane);
			
			var wireMat:WireframeMaterial = new WireframeMaterial(0x112233, 1, 2);
			sphere = new Sphere(wireMat, 100, 16, 16);
			sphere.x = 350;
			
			view.scene.addChild(sphere);
		}
		private function on3DClick(e:InteractiveScene3DEvent):void {
			Tweener.addTween(view.camera,{
				x	:300,
				y	:300,
				time:2
			});
		}
		private function onEventRender3D(e:Event):void{
			sphere.rotationY += 3;
			view.singleRender();
		}
	}
}
