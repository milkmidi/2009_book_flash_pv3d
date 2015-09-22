package{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	public class TiltViewer extends MovieClip{
		private var view		:BasicView;
		private var itemOfNumber:int = 25;
		public function TiltViewer(){
			FilterShortcuts.init();
			//Tweener類別可以開啟許多快速鍵。
			//FilterShortcuts類別是專門在處理濾鏡。
			//FilterShortcuts.init();	啟動濾鏡快速鍵。
			init3DEngine();
			init3DObject();
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Free");
			view.viewport.buttonMode = true;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);			
		}
		private function init3DObject():void{
			for (var i:int = 0; i < itemOfNumber; i++){
				var bmpMat:BitmapFileMaterial = new BitmapFileMaterial("images/" + i + ".jpg");
				bmpMat.interactive = true;
				var plane:Plane = new Plane(bmpMat, 150, 112, 2, 2);
				plane.useOwnContainer = true;
				//DisplayObject3D類別下的useOwnContainer屬性
				//開啟後,物件即可直接增加濾鏡和修改alpha值。
				plane.filters = [new BlurFilter(36, 36, 1)]
				//增加BlurFilter。
				//因為有啟動濾鏡快速鍵。
				//所以可以使用Tweener來修改Blur的參數值。
				plane.alpha = 0;
				//alpha值為0。
				plane.x = Math.random() * 1000 - 500;
				plane.y = Math.random() * 1000 - 500;
				plane.z = Math.random() * 500 + 300;
				plane.rotationX = Math.random() * 360;
				plane.rotationY = Math.random() * 360;
				plane.rotationZ = Math.random() * 360;
				//亂數座標與rotation的值。
				//Math.random()會回傳0~1之間的亂數值。
				Tweener.addTween(plane,
				{
					x 			:Math.floor( i / 5) * 200 - 400,
					//x座標使用取整數。
					y 			:i % 5  * 180 - 400,
					//y座標使用取餘數。
					z 			:0,
					rotationX 	:0,
					rotationY 	:0,
					rotationZ 	:0,
					alpha		:1,
					_Blur_blurX	:0,
					_Blur_blurY	:0,					
					//因為有開啟FilterShortcuts.init();
					//即可使用_Blur_blurX,_Blur_blurY來修改濾鏡的BlurX和BlurY值
					time		:2,
					transition	:"easeOutBack",
					delay		:i * 0.01					
				} );				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, on3DOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, on3DOut);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, on3DClick);
				//偵聽plane物件發出的事件。
				view.scene.addChild(plane);
				//將plane加入至view.scene裡。
			}
		}
		private function on3DOver(e:InteractiveScene3DEvent):void {			
			e.displayObject3D.filters = [new GlowFilter(0x669900, 1, 6, 6, 4)];			
			//因為有開啟useOwnContainer屬性，
			//所以物件可以新增濾鏡。			
		}
		private function on3DOut(e:InteractiveScene3DEvent):void {					
			e.displayObject3D.filters = [];
			//移除濾鏡。			
		}
		private function on3DClick(e:InteractiveScene3DEvent):void {
			var _plane:Plane =  e.displayObject3D as Plane;
			//當滑鼠點擊時, 先得到廣播者物件。
			Tweener.addTween( view.camera,{
				x		:_plane.x,
				y		:_plane.y,
				z		:_plane.z - 100, 
				//camera的目標Z軸即是廣播者物件Z軸再減去100。
				time	:1.5
			} );
			bg_mc.addEventListener(MouseEvent.CLICK, onBackGroundClick);
			//偵聽場景上bg_mc發出的MouseEvent.CLICK事件。
		}
		private function onBackGroundClick(e:MouseEvent):void{
			bg_mc.removeEventListener(MouseEvent.CLICK, onBackGroundClick);
			//取消偵聽。
			//當bg_mc被點擊後, 移處偵聽。
			//讓camera移回到本來的位置。
			Tweener.addTween( view.camera,{
				x		:0,
				y		:0,
				z		:-1000,
				time	:1.5,
				transition:"easeOutExpo"
			});
		}
		private function onEventRender3D(e:Event):void{
			var _targetX:Number = stage.mouseX - (stage.stageWidth / 2);
			//算出滑鼠X軸距離場景中心點的距離值。
			var _targetY:Number = stage.mouseY - (stage.stageHeight / 2);
			//算出滑鼠Y軸距離場景中心點的距離值。
			view.camera.rotationY = _targetX / 40; 
			//因為移動量過大，所以多除以40。
			//將其值寫入至camera的rotationY屬性。
			view.camera.rotationX = _targetY / 40; 
			//將其值寫入至camera的rotationX屬性。
			view.singleRender();
		}
	}
}
