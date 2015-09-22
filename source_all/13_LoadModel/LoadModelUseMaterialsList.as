package {	
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import org.papervision3d.view.BasicView;

	public class LoadModelUseMaterialsList extends Sprite{
		private var view		:BasicView;
		private var dae			:DAE;//DAE物件

		public function LoadModelUseMaterialsList(){
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.camera.y = 200;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			dae = new DAE(true, "dae", true);	
			dae.y = -100;
			//建構DAE類別。						
			var ml:MaterialsList = new MaterialsList(
			{
				BodyMaterial	:new BitmapFileMaterial("milkmidiBOX/body.jpg"),
				TopMaterial		:new BitmapFileMaterial("milkmidiBOX/top.jpg"),
				MediumMaterial	:new BitmapFileMaterial("milkmidiBOX/medium.jpg"),
				downMaterial	:new BitmapFileMaterial("milkmidiBOX/down.jpg")
			})			
			dae.load("milkmidiBOX/milkmidiBOX_Ani.dae",ml);					
			//載入dae模型。
			dae.scale = 10;			
			dae.rotationX = -90;
			view.scene.addChild(dae);
		}		
		private function onEventRender3D(e:Event):void {			
			dae.rotationY += 2;
			view.singleRender();
		}
	}
}
