package {	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.URLRequest;	
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import caurina.transitions.Tweener
	public class MiniCarousel extends MovieClip{
		private var view		:BasicView;
		private var rootNode	:DisplayObject3D;
		//DisplayObject3D物件，可以想像是PV3D裡的空白MovieClip。
		//本身是個容器,可以透過addChild加入任何繼承DisplayObject3D的物件。
		private var itemOfNumber:int = 12;//物件數量
		private var radius		:Number = 650;//半徑
		private var angleUnit	:Number = (Math.PI * 2) / itemOfNumber;
		//360徑度 = Math.PI * 2 弧度
		//除以數量即可得到單位弧度。
		//也就是每次rootNode要旋轉的量。
		private var currentIndex:Number = 0;//目前的圖片索引值
		private var ldr			:Loader;	//載入大圖用的Loader。
		public function MiniCarousel(){
			init3DEngine();
			init3DObject();
			initObject();			
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.camera.y = 400;
			view.camera.z = -1400;
			view.viewport.buttonMode = true;
			//PV3D物件預設都不會有滑鼠指標手示，
			//viewport是繼承Sprite，
			//所以可以開啟buttonMode屬性。
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			//建立一個DisplayObject3D物件
			view.scene.addChild(rootNode);
			//加入至scene。
			for (var i:int = 0; i < itemOfNumber; i++) {
				var _bmpMat:BitmapFileMaterial = new BitmapFileMaterial("images/" + i +"s.jpg");
				_bmpMat.doubleSided = true; //雙面模式
				_bmpMat.smooth = true; // 平滑化
				_bmpMat.interactive = true; //互動模式
				var _plane	:Plane = new Plane(_bmpMat, 200, 150, 2, 2);
				var _radian	:Number = i * angleUnit;
				_plane.x = Math.cos(_radian) * radius;
				_plane.z = Math.sin(_radian) * radius;
				//透過三角函數來排列。
				_plane.rotationY = 270 - (_radian * 180 / Math.PI) ;
				//旋轉plane, 因為使用的單位是徑度, 要將弧度轉成徑度。
				_plane.useOwnContainer = true;			
				//當開啟useOwnContainer屬性，
				//即可對物件修改alpha值和增加濾鏡。
				_plane.name = "plane" + i;
				_plane.extra = { id:i };
				//PV3D所有的物件都不是動態類別,不能任意的新增屬性或方法。
				//DisplayObject3D類別下有個extra的屬性,型別為Object, 本身是個動態類別。
				//Plane是繼承至DisplayObject3D
				//所以可以使用plane.extra = new Object();
				//plane.extra.id = i;
				//或是直接寫成一行plane.extra = { id:i };
				//當plane被按下時,偵聽者可以得到發出事件的Plane物件
				//再透過其extra.id即可得到唯一的id值。				
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				_plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, on3DPress);
				//偵聽
				rootNode.addChild(_plane);
				//把plane加入至rootNode物件，
				//這樣就只要針對rootNode物件做旋轉。
			}
		}
		private function initObject():void{
			right_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			left_btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			//場景上的right_btn和left_btn元件。
			this.addChild(right_btn);
			this.addChild(left_btn);
			//要更改物件深度至最上層，
			//只需要重新addChild即可。
			ldr = new Loader();
			//載入大圖用的Loader
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			//偵聽Event.COMPLETE事件。
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
			//偵聽MouseEvent.MOUSE_WHEEL事件。
		}
		
		private function onStageMouseWheel(e:MouseEvent):void {
			//MouseEvent類別, delta屬性可以得到滑鼠滾輪的值
			//e.dalta如果大於0,表示滾輪向上,小於0表示向下。	
			if (e.delta >0) {
				currentIndex++;
			}else {
				currentIndex--;
			}
			updateRootNodeTransform();
		}
		
		private function onLoaderComplete(e:Event):void {
			//載入完畢,希望圖片能對齊場景的正中間
			ldr.x = stage.width/2 - ldr.width/2;
			//Loader物件的x屬性 = 場景寬的一半, 減去Loader物件的寬一半。
			ldr.y = stage.height / 2 - ldr.height / 2;
			//高度也是一樣的計算方法。
			ldr.alpha = 0;
			Tweener.addTween(ldr, { alpha:1, time:1 } );
			//使用Tweener,來製作alpha進場的效果。
			this.addChild(ldr);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			//只有Stage類別是全域的感應範圍。
		}
		
		private function onStageClick(e:MouseEvent):void{
			ldr.unload();
			//移除Loader載入的物件。
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			//取消偵聽。
			right_btn.visible = left_btn.visible = true;
			//讓左、右Button看的見。
		}
		private function on3DOver(e:InteractiveScene3DEvent):void {			
			//當滑鼠進入感應區時，修改廣播者scale屬性，放大1.2倍。
			e.displayObject3D.scale = 1.2;			
		}
		private function on3DOut(e:InteractiveScene3DEvent):void {
			//當滑鼠離開感應區時，回復原本的大小。
			e.displayObject3D.scale = 1;			
		}
		private function on3DPress(e:InteractiveScene3DEvent):void{
			var _id:int = e.displayObject3D.extra.id;
			//e.displayObject3D可以得到廣播者,型別為DisplayObject3D
			//其extra屬性下有我們事先定義的id變數。
			ldr.load(new URLRequest("images/" + _id + ".jpg"));
			//載入大圖路徑。
			right_btn.visible = left_btn.visible = false;
			//隱藏左、右Button鍵。
		}
		private function onButtonClick(e:Event):void {
			if(e.currentTarget == right_btn){
				currentIndex++;
				//如果廣播者是right_btn,就讓目前的索引值加一
				//currentIndex++也可寫成
				//currentIndex += 1或是
				//currentIndex = currentIndex+1
			}else{
				currentIndex--;
			}
			updateRootNodeTransform();
		}
		private function updateRootNodeTransform():void {
			//更新rootNode的rotationY值
			Tweener.addTween(rootNode,
			{
				rotationY   :currentIndex * angleUnit * 180 / Math.PI,
				//目前的currentIndex值，乘上單位弧度
				//rotation用的單位是徑度,所以要將弧度轉換成徑度。				
				time		:0.5
			} );
		}
		private function onEventRender3D(e:Event):void {			
			for (var i:int = 0; i < itemOfNumber; i++) {
				var _plane:Plane = rootNode.getChildByName("plane" + i) as Plane;
				//抓取rootNode其容器裡的3D物件, 同時將轉別轉成Plane類別。
				var _blur:int = _plane.screenZ / 500;
				//Plane物件其screenZ可以得到該物件距離螢幕的數值。
				//如果距離螢幕越遠，Blur值就越高。
				_plane.filters = [new BlurFilter(_blur, _blur)];				
				//增加Blur濾鏡效果。
			}
			view.singleRender();
			//運算。
		}
	}
}
