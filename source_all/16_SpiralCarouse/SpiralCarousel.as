package {		
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import caurina.transitions.Tweener;
	public class SpiralCarousel extends MovieClip	{
		private var view				:BasicView;
		private var loadedNumber		:int = 0;  //已載入的圖片數量。
		private var itemOfNumber		:int = 24; //物件數量
		private var numberOfRotations	:int = 2;  //旋轉多少圈
		private var radius				:int = 3200; //半徑
		private var angleUnit			:Number = (Math.PI * 2 * numberOfRotations) / itemOfNumber;
		//單元弧度
		private var glow				:GlowFilter;
		//高光濾鏡
		private var cameraTargetObj3D	:DisplayObject3D;
		//Camera3D的目標物件。
		private var loaderMC			:MovieClip;		
		private var currentPlane		:Plane;
		//用來暫存被點擊的plane物件。
		private var ldr					:Loader = new Loader();
		//載入大圖用的Loader物件。
		public function SpiralCarousel(){
			init3DEngine();
			init3DObject();
			initObject();
		}	
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.viewport.buttonMode = true;
			view.camera.z = -3200;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			var _ypos:int = -1200;
			//設定_ypos變數, 用來遞減用。
			for (var i:int = 0; i < itemOfNumber; i++) {
				var bmpMat:BitmapFileMaterial = new BitmapFileMaterial("images/" + i + "s.jpg", true);
				//點陣圖材質, 來源是外部的圖檔。
				bmpMat.addEventListener(FileLoadEvent.LOAD_COMPLETE, onMaterialLoadComplete);
				//偵聽FileLoadEvent.LOAD_COMPLETE載入完成事件。
				bmpMat.doubleSided = true;
				//雙面模式。
				bmpMat.interactive = true;
				//互動模式。
				var plane:Plane = new Plane(bmpMat, 500, 375, 2, 2);				
				//建構Plane物件。
				plane.name = "plane" + i;				
				plane.useOwnContainer = true;
				//獨立容器模式。			
				
				plane.extra = new Object();				
				plane.extra.id = i;
				//為每個plane物件指定一個唯一的變數值。
				plane.x = plane.extra.x = Math.cos(i * angleUnit) * 1500;
				plane.y = plane.extra.y = _ypos;
				plane.z = plane.extra.z = Math.sin(i * angleUnit) * 1500;				
				//螺旋形排列, 一樣使用sin和cos。
				//只要將y軸不斷的遞增即可。							
				plane.rotationY = plane.extra.rotationY = ( -i * angleUnit) * (180 / Math.PI) + 270;
				//rotationY屬性值。
				//rotation過後, plane的軸心也轉向, 				
				plane.moveBackward(5000);
				//plane物件以目前的軸心往後移5000				
				plane.alpha = 0;
				//透明度為0				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, on3DRelease);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				//偵聽事件。				
				view.scene.addChild(plane);
				//加入至scene物件。
				_ypos += 90;
				//y軸遞增。
			}
			cameraTargetObj3D = new DisplayObject3D();
			view.camera.target = cameraTargetObj3D;
			//讓camera的目標物件設定為cameraTargetObj3D
			//只要cameraTargetObj3D移動, camera就會自動轉向該物件的座標方向
		}
		private function initObject():void {
			glow = new GlowFilter(0xeeeeee, 1, 16, 16, 3);
			//建構高光類別。			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			//載入大圖用的Loader物件, 偵聽Event.COMPLETE事件
		}
		private function onMaterialLoadComplete(e:FileLoadEvent):void {			
			loadedNumber++;
			//當材質載入成功時，讓載入的變數加一。
			//直到載入的圖片數量等於總圖片數量時
			//播放進場的動畫。
			load_txt.text = "LOADING " + loadedNumber + "/" + itemOfNumber;
			//場景上的load_txt文字物件，用來顯示目前已載入多少張照片。
			if (loadedNumber >= itemOfNumber ) {
				startIntroAnimation();
			}
		}
		private function startIntroAnimation():void {
			this.removeChild(load_txt);
			//移除場景上的load_txt文字物件。
			for (var i:int = 0; i < itemOfNumber; i++) {
				var plane:Plane = view.scene.getChildByName("plane" + i) as Plane;
				Tweener.addTween(plane,	{
					x		 :plane.extra.x,
					y 		 :plane.extra.y,
					z 	     :plane.extra.z,
					rotationY:plane.extra.rotationY,
					alpha	 :1,
					delay	 :i * 0.02,
					time 	 :2
				} );
			}
			//使用回圈來指定plane物件的屬性。
			//目標值為建構時，將其值寫入至其extra屬性。
		}
		
		private function on3DOver(e:InteractiveScene3DEvent):void {
			//滑入感應區時，增加高光濾鏡。
			e.displayObject3D.filters = [glow];
		}
		private function on3DOut(e:InteractiveScene3DEvent):void {
			//移除濾鏡。
			e.displayObject3D.filters = [];
		}
		private function on3DRelease(e:InteractiveScene3DEvent):void {
			//點擊plane物件時。
			currentPlane = e.displayObject3D as Plane;
			//將廣播者物件指派到currentPlane變數裡。			
			currentPlane.filters = [];
			//取消濾鏡。
			
			var _empty:DisplayObject3D = new DisplayObject3D();
			//建構一個空白的DisplayObject3D物件。
			_empty.copyTransform(currentPlane);
			//復製座標屬性。
			_empty.moveBackward(500);
			//往後移動500。
			Tweener.addTween(view.camera, {
				//移動camera座標。
				x	:_empty.x,
				y	:_empty.y,
				z	:_empty.z,
				time:3
			} );
			Tweener.addTween(cameraTargetObj3D, {
				//移動camera的目標點。
				x	:currentPlane.x,
				y	:currentPlane.y,
				z	:currentPlane.z,
				time:3,
				onComplete:onTweenerComplete
			});
			
		}
		private function onTweenerComplete():void {
			//Tweener完成時。
			ldr.load(new URLRequest("images/" + currentPlane.extra.id + ".jpg"));
			//Loader載入圖片。
			loaderMC = new LoaderMC();
			//建構LoaderMC物件，來源是元件庫設定的類別名稱。
			loaderMC.x = stage.stageWidth / 2;
			loaderMC.y = stage.stageHeight / 2;
			//置中。
			this.addChild(loaderMC);
			//加入此目前的容器的。
			bg_mc.addEventListener(MouseEvent.CLICK, onBackGroundClick);
			//偵聽場景上bg_mc物件的MouseEvent.CLICK事件。
		}
		
		private function onLoaderComplete(e:Event):void {
			//大圖示載入完成時。
			this.removeChild(loaderMC);
			//移除載入動畫。			
			var _bitmap:Bitmap = ldr.content as Bitmap;
			//Loader類別載入圖檔後，其內容物為Bitmap類別。
			var _bmp:BitmapData = _bitmap.bitmapData;
			//Bitmap類別使用bitmapData屬性, 可以得到BitmapData類別
			var _bmpMat:BitmapMaterial = new BitmapMaterial(_bmp, true);
			//建構BitmapMaterial類別。
			//new BitmapData(點陣圖來源,精準模式)。
			_bmpMat.interactive = true;
			//開啟互動模式。
			_bmpMat.doubleSided = true;
			currentPlane.material = _bmpMat;
			//置換currentPlane物件材質。
		}
		private function onBackGroundClick(e:MouseEvent):void {
			//當場景上的bg_mc被點擊時，
			//讓Camera回到原本的位置。			
			Tweener.addTween(cameraTargetObj3D, {
				//移動Camera目標點。
				x	:0,
				y	:0,
				z	:0,
				time:2
			});
			
			var _empty:DisplayObject3D = new DisplayObject3D();			
			_empty.copyTransform(currentPlane);
			_empty.moveBackward(2000);
			//復製物件的座標。
			Tweener.addTween(view.camera, {
				//移動Camera座標。
				x	:_empty.x,
				y	:0,
				z	:_empty.z,
				time:2
			} );
			bg_mc.removeEventListener(MouseEvent.CLICK, onBackGroundClick);
			//取消偵聽。
		}
		private function onEventRender3D(e:Event):void	{
			view.singleRender();			
		}
	}
}
