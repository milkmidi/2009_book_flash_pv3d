package{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import caurina.transitions.Tweener;
	
	public class Carousel3D extends Sprite {
		private var view		:BasicView;
		private var radius		:int = 500;							 //物件半徑
		private var itemOfNumber:int = 16;							 //物件數量
		private var angleUnit	:Number = Math.PI * 2 / itemOfNumber;//角度比例值
		private var currentIndex:int = 1;							 //目前的索引值
		private var currentObj	:DisplayObject3D = null; 			 //目前的物件
		private var isThumbClick:Boolean = false; 					 //是否小圖示被點擊		
		private var loaderMC	:MovieClip; 						 //場景上的loading動畫元件
		private var ldr			:Loader; 							 //載入大圖用的Loader
		public var cameraAngle	:Number = angleUnit; 				 //目前的鏡頭角度
		//EnterFrame 事件會一直抓取此角度值, 以計算 Camera 的座標,
		//當要使用 Tweener 來修改該值時, 需設定成 public 變數
		
		public function Carousel3D(){
			init3DEngine(); //建立PV3D世界
			init3DObject(); //建立3D物件
			initObject();	//建立其他物件
			startIntroAnimation();	//播放進場動畫。
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.viewport.buttonMode = true;
			view.camera.zoom = 20;
			//camera zoom值為鏡頭縮放參數。
			//就像使用相機一樣, 鏡頭裡的物件並沒有移動, 
			//透過zoom值的修改, 即可讓物件放大或是縮小
			view.camera.x = 10
			view.camera.y = 1000;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			for (var i:int = 0 ; i < itemOfNumber; i++ ) {
				var itemMC:MovieClip = new ItemMC();
				//建構ItemMC。
				itemMC.txtMC._txt.text = "." + (i + 1);
				//ItemMC下的txtMC物件下的_txt文字物件。
				itemMC.mouseChildren = false;
				//讓其容器裡的物件滑鼠感應失效。
				itemMC.addEventListener( MouseEvent.ROLL_OVER, onMouseEventRollOver );
				itemMC.addEventListener( MouseEvent.ROLL_OUT, onMouseEventRollOut );
				//因為是MovieClip類別, 所以是用MouseEvent事件。
				
				var loader:Loader = new Loader();
				//載入小圖用的Loader
				loader.load(new URLRequest("images/" + i + "s.jpg"));
				//載入
				loader.x = 5;
				loader.y = 5;
				itemMC.addChild(loader);
				//將小圖載入至itemMC物件裡。				
				
				var movieMat:MovieMaterial = new MovieMaterial(itemMC, false, true, true);
				//貼上MovieMaterial材質。
				movieMat.doubleSided = true;
				movieMat.interactive = true;
								
				var plane:Plane = new Plane(movieMat, 200, 300, 1, 1);
				
				var _radian:Number =  i * angleUnit;
				//弧度
				var _x	:Number = Math.cos(_radian) * radius;	
				var _y	:Number = 0;
				var _z	:Number = Math.sin(_radian) * radius;
				//透過三角函數算出x軸和z軸的位置。
				var _rx	:Number =0;
				var _ry	:Number = -_radian *  (180 / Math.PI);
				var _rz	:Number = 0;
				
				plane.name = "item" + i;
				//設定plane的實體名稱。
				plane.x = _x;
				plane.y = _y;
				plane.z = _z;
				plane.rotationX = _rx;
				plane.rotationY = _ry;
				plane.rotationZ = _rz;
				plane.extra =
				{
					id			: i,
					x			: _x,	
					y			: _y,
					z			: _z,
					rotationX 	: _rx,
					rotationY 	: _ry,
					rotationZ	: _rz
				};				
				//同時將屬性記錄在extra屬性裡。	
				//因為每個Plane物件被點擊時, 會有移動的效果。
				//也會需要移回原本設定的位置, 所以要先記錄下來。
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DEventPress);
				//偵聽。
				view.scene.addChild(plane);
			}
		}
		private function initObject():void{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//偵聽滾輪事件。
			right_btn.addEventListener(MouseEvent.CLICK, onMoveRight);
			//場景上的右鍵Button
			left_btn.addEventListener(MouseEvent.CLICK, onMoveLeft);
			//場景上的左鍵Button
			ldr = new Loader();
			//載入大圖用的Loader
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			//偵聽載入進度
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			//偵聽載入完成
		}
		private function startIntroAnimation():void{
			var _targetX:Number =  Math.cos(cameraAngle) * 700 + 30;
			var _targetY:Number = 300;
			var _targetZ:Number =  Math.sin(cameraAngle) * 700;
			//運算出camera的最終位置座標，
			//使用Tweener來產生動畫。
			Tweener.addTween(view.camera,
			{
				x			:_targetX,
				y			:_targetY,
				z			:_targetZ,
				rotationX 	:0,
				rotationY 	:0,
				rotationZ 	:0,
				time		:1.5,
				onComplete	:function()
				{
					isThumbClick = true;
					//當 Intro 動畫播放完畢後, 將 isThumbClick 變數設成 true
					//這樣可以避免和 onEventRender3D 裡的運算衝突
				}
			});
		}
		private function startLoadDetailIMG(p_id:int):void{
			loaderMC = new LoaderMC();
			//LoaderMC為Library裡設定的類別名稱。
			loaderMC.x = stage.stageWidth / 2;
			//x軸為整個場景寬的一半。
			loaderMC.y = stage.stageHeight / 2 + 165;
			this.addChild(loaderMC);
			var _imgURL:String = "images/" + p_id + ".jpg";
			ldr.load(new URLRequest(_imgURL));
			//載入大圖
		}
		private function onLoaderProgress(e:ProgressEvent):void{
			var _percentage:int = int (e.bytesLoaded / e.bytesTotal * 100);
			//已載入元位組除以總檔案元位組，再乘上一百，取整數，即可的到百分比值。
			loaderMC.gotoAndStop(_percentage);
			//loaderMC事先做好一百格的影格動畫,使用gotoAndStop來指定影格數。
		}
		private function onLoaderComplete(e:Event):void{
			ldr.x = stage.stageWidth/2 - ldr.width/2;
			ldr.y = stage.stageHeight/2 - ldr.height/2;
			//讓載入大圖用的 ldr 完全置中於場景
			ldr.alpha = 0;
			//alpha 屬性先設成 0, 再用 Tweener 製作 0 到 1 (從透明到不透明的淡入效果) 的動畫			
			Tweener.addTween(ldr,
			{
				alpha		:1,
				time		:1
			});
			this.removeChild(loaderMC);
			//從目前的容器將loaderMC物件移除。
			this.addChild(ldr);
			//將ldr加入至目前的容器裡。
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			//滾輪事件。
			if (e.delta > 0) {
				onMoveRight();
				//執行onMoveRight()函式
			}else {
				onMoveLeft();
			}
			/*
			 * ActionScript3
			 * function的參數值如果沒有設定預設值
			 * 就一定要傳送該參數
			 * 否則編譯器會發出 引數不合 的錯誤。
			 * */
		}
		private function onMoveRight(e:MouseEvent = null):void {
			//設定 e 參數的預設值為 null, 這樣就可以直接呼叫 onMoveRight() 函式, 且不需指定參數
			currentIndex++;
			//目前索引值加一;
			updata();
			//更新Camera座標。
		}
		private function onMoveLeft(e:MouseEvent = null):void{
			currentIndex--;
			//目前索引值減一;
			updata();
			//更新Camera座標。
		}
		private function updata():void {			
			Tweener.addTween(this, { cameraAngle:currentIndex * angleUnit, time:0.5 } );
		}
		private function onMouseEventRollOver(e:MouseEvent):void {
			//偵聽者函式偵聽MovieClip的MouseEvent.ROLL_OVER事件
			MovieClip(e.currentTarget).gotoAndPlay("over");
			//廣播者從over表籤開始播放。
		}
		private function onMouseEventRollOut(e:MouseEvent):void{
			MovieClip(e.currentTarget).gotoAndPlay("out");
			//廣播者從out表籤開始播放。			
		}
		private function on3DEventPress(e:InteractiveScene3DEvent):void{
			right_btn.visible = left_btn.visible = false;
			//隱藏場景上的riht_btn和left_btn。
			light_mc.gotoAndPlay("over");
			//場景上的light_mc,從over表籤開始播放。
			
			currentObj = e.displayObject3D;
			//將目前的廣播者記錄在currentObj變數裡。
			Tweener.addTween(currentObj,
			{
				x 			: 0,
				y			: 1000,
				z			: 0,
				rotationX 	: -90,
				rotationY 	: 360,
				rotationZ 	: 180,
				time		: 1,
				delay		: .5
			});
			//使用Tweener移動目前的Plane物件。
			
			view.camera.extra =
			{
				x		:view.camera.x,
				y		:view.camera.y,
				z		:view.camera.z
			};
			//把目前Camera的座標記錄下來。
			
			isThumbClick = false;
			//將isThumbClick設成false
			//這樣onEventRender3D就不會運算Camera座標
			//避免和Tweener產生衝突。
			
			Tweener.addTween(view.camera,
			{
				x			:0,
				y			:1200,
				z			:1,
				time		:1.6,
				onComplete	:function() :void
							{
								//Tweener完成時會執行該function一次
								stage.quality = StageQuality.HIGH;
								//將品質設成高
								stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
								//偵聽 MouseEvent.MOUSE_DOWN (按下滑鼠鈕) 事件
								startLoadDetailIMG(currentObj.extra.id);
								//載入大圖。
							}
			});
			//移動Camera的座標
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//取消偵聽滾輪事件。
			stage.quality = StageQuality.LOW;
			//將品質設成低。
		}
		private function onStageClick(e:MouseEvent):void {
			//當場景被點擊時，表示要Camera和目前的Plane要移回預設的座標。
			light_mc.gotoAndPlay("out");
			ldr.unload();
			//移除載入的大圖
			this.removeChild(ldr);
			//移除事入大圖的Loader物件
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			//取消偵聽stage的點車事件。
			
			Tweener.addTween(view.camera,
			{
				x		:view.camera.extra.x,
				y		:view.camera.extra.y,
				z		:view.camera.extra.z,
				time	:1.5,
				onComplete:function ():void
				{
					//Tweener完成。
					isThumbClick = true;
					//將isThumbClick設成true
					//讓onEventRender3D運算Camera的位置
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					//重新偵聽滾輪事件。
					right_btn.visible = left_btn.visible = true;
					//讓right_btn和left_btn重現。
				}
			});
			//使用Tweener將camera移回預設的座標
			
			Tweener.addTween(currentObj,
			{
				x			:currentObj.extra.x,
				y			:currentObj.extra.y,
				z			:currentObj.extra.z,
				rotationX 	:currentObj.extra.rotationX,
				rotationY 	:currentObj.extra.rotationY,
				rotationZ 	:currentObj.extra.rotationZ,
				time		:1
			});
			//使用Tweener將目前Plane物件移回預設的座標。
		}
		
		private function onEventRender3D(e:Event):void{
			if (isThumbClick) {
				view.camera.x = Math.cos(cameraAngle) * 700 + 30;
				view.camera.z = Math.sin(cameraAngle) * 700;
				//運算Camera的x軸和z軸。
			}
			view.singleRender();
		}
	}
	
}
