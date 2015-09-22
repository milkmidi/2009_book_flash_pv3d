package {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;	
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;	
	import org.papervision3d.view.BasicView;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import org.papervision3d.cameras.CameraType
	import caurina.transitions.Tweener;	

	public class SpaceGallery extends MovieClip	{
		private var view				:BasicView;
		private var itemOfNumber		:int = 19; 			//圖片數量
		private var rootNode			:DisplayObject3D;
		private var targetZ				:Number = 0;		//目標Z軸
		public function SpaceGallery(){
			init3DEngine();
			init3DObject();
			initObject();			
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, CameraType.TARGET);			
			view.viewport.buttonMode = true;
			view.camera.z = -740;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			rootNode = new DisplayObject3D();
			//建立空白的DisplayObject3D。
			rootNode.z = -2000;			
			view.scene.addChild(rootNode);
			//加入至view.scene。
			var colorMat:ColorMaterial = new ColorMaterial(0xaadddd, .5);
			//色材材質，給Cube的其他面使用。
			for (var i:int = 0; i < itemOfNumber; i++) {
				var movie:MovieClip = new MaterialMC();		
				//建構MaterialMC，類別來源是元件庫設定的類別。
				movie._txt.text = "NO." + i;			
				//設定文字物件的文字。
				
				var movieMat	:MovieMaterial = new MovieMaterial(movie, true, false, true);								
				//建構MovieMaterial影片片段材質，new MovieMaterial(影片片段來源,是否透明,是否播放動畫,精準模式)。				
				movieMat.interactive = true;
				//互動模式開啟。
				
				var bmpMat		:BitmapFileMaterial = new BitmapFileMaterial("images/" + i + ".jpg", true);
				//點陣圖材質。
				bmpMat.interactive = true;
				//互動模式開啟。
				
				var ml			:MaterialsList = new MaterialsList(
				//材質列表。
				{
					top		:colorMat ,
					bottom	:colorMat,
					left	:colorMat,
					right	:colorMat,
					//上、下、左、右皆是使用色彩材質
					front	:bmpMat,
					//前：使用點陣材質。
					back	:movieMat
					//後：使用影片片段材質。
				} );
				
				var cube:Cube = new Cube(ml, 400, 1, 300);
				//建構Cube物件，new Cube(材質列表 ,寬度,深度,高度)				
				cube.useOwnContainer = true;
				//獨立容器模式開啟。
				cube.alpha = .7;
				//透明度為0.7。
				cube.extra = { isFlip:false };
				//自定變數，用來判斷Cube是否已經翻轉過。
				cube.z = i * 400;
				//z軸遞增。
				cube.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, on3DRelease);
				//偵聽點擊事件。
				rootNode.addChild(cube);
				//將cube加入至rootNode。
			}			
		}	
		private function initObject():void {
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onEventMouseWheel);
			//偵聽滾輪事件。
		}
		
		private function onEventMouseWheel(e:MouseEvent):void{			
			if (e.delta > 0) {
				targetZ -= 400;
				//滾輪向上，目標z軸就減400。
			}else {
				//滾輪向下，目標z軸就加400。
				targetZ += 400;
			}
		}		
		private function on3DRelease(e:InteractiveScene3DEvent):void {
			var _tweenObj:Object;
			var _target:Cube = e.displayObject3D as Cube;
			//得到廣播者Cube物件
			//判斷是否已經翻轉。
			if (_target.extra.isFlip) {
				//是的話，就讓rotationY轉回0度。
				_tweenObj = { rotationY:0, alpha:0.7 };
				_target.extra.isFlip = false;
			}else {
				//否的話，就讓rotationY轉回至180度。
				_tweenObj = { rotationY:180, alpha:1 };
				_target.extra.isFlip = true;
			}
			_tweenObj.time = 0.9;
			//該Tweener動作在0.9秒內完成
			_tweenObj.transition = "easeInOutBack";			
			//運動方式。
			Tweener.addTween(_target, _tweenObj)
			//執行Tweener。
		}
		
		private function onEventRender3D(e:Event):void	{			
			var _targetX:Number = stage.mouseX - stage.stageWidth / 2;			
			//滑鼠x座標距離場景中心點。
			var _targetY:Number = stage.mouseY - stage.stageHeight / 2;
			//滑鼠y座標距離場景中心點。
			view.camera.x += (_targetX - view.camera.x) / 10;
			view.camera.y += (_targetY - view.camera.y) / 10;			
			rootNode.z += (targetZ - rootNode.z) / 10;
			//漸近運動。						
			view.singleRender();
		}
	}
}
