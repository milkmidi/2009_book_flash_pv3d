package {	
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import org.papervision3d.view.BasicView;

	public class LoadModel extends Sprite{
		private var view		:BasicView;
		private var dae			:DAE;//DAE物件

		public function LoadModel(){
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
			//建構DAE類別。
			/*new DAE(
			是否自動播放動畫:Boolean ,
			實體名稱:String ,
			是否循環播放動畫:Boolean
			)*/
			dae.load("dae/miniBottle.dae");					
			//載入dae模型。
			//dae.load("dae/miniBottleAni.dae");			
			//動畫格式的dae模型。
			
			dae.scale = 10;
			//使用DAE類別載入模型時, 通常模型會很小一個
			//我們將其大小放大10倍。
			view.scene.addChild(dae);
		}		
		private function onEventRender3D(e:Event):void{
			dae.rotationY += 2;
			view.singleRender();
		}
	}
}
