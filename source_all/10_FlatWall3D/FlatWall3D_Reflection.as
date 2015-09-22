package{
    import flash.display.*;
    import flash.events.*;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
    import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import caurina.transitions.*;
	import milkmidi.display.MiniSlider;	
	import milkmidi.papervision3d.materials.ReflectionFileMaterial;
	//匯入筆者所撰寫的MiniSlider類別。
    public class FlatWall3D_Reflection extends MovieClip 	{
		private var view			:BasicView;
		private var itemOfNumber	:int = 21;		//圖片數量
		private var cameraX			:Number = 0;	//camera的目標x軸
		private var cameraY			:Number = 0;	//camera的目標y軸
		private var cameraZ			:Number = -1000;//camera的目標z軸
		private var cameraZMin		:Number = -1500;//cameraZ軸的最小值
		private var cameraZMax		:Number = -150;	//cameraZ軸的最大值
		private var slider			:MiniSlider;	//迷你Slider物件。
        public function FlatWall3D_Reflection(){
			init3DEngine();
			init3DObject();
			initObject();
        }
		private function init3DEngine():void{
			view = new BasicView(0, 0, true , true, "Free");
			view.viewport.buttonMode = true;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);			
			view.camera.z = -2500;
			view.camera.x = -1000;
		}
		private function initObject():void{
			slider = new MiniSlider(0, 2000, 200);
			//建立MiniSlder物件。
			//new MiniSlider(最小值:Number , 最大值:Number, 物件寬度:Number)。
			slider.addEventListener(MiniSlider.SLIDER, onSlider);			
			//偵聽MiniSlider.SLIDER事件。
			slider.x = stage.stageWidth / 2 - 50;
			slider.y = stage.stageHeight - 50;
			//slider物件的x,y座標。
			this.addChild(slider);			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			//偵聽滾輪事件。
		}
		
		private function onSlider(e:Event):void{
			cameraX = slider.value;
			//slider物件其value屬性可得到目前的值,範圍為建構時所填寫的0到2000。
		}
		private function init3DObject():void {
			var bmpMat		:MaterialObject3D;
			var planeHeight	:int;
			//宣告變數, 避免在判斷式時重復宣告。
			for (var i:int = 0; i < itemOfNumber; i++) {				
				if (i % 3 == 0) {										
					//取 3 餘數如果等於 0 的話, 表示是最下方一排					
					bmpMat = new ReflectionFileMaterial("images/" + i + ".jpg", true);
					//反射材質
					planeHeight = 250;
					//因為使用反射材質, 所以高度要增加一倍					
				}else {
					bmpMat = new BitmapFileMaterial("images/" + i + ".jpg");
					planeHeight = 125;
					//使用本來的點陣圖材質和高度
				}				
				bmpMat.interactive = true;
				bmpMat.smooth = true;				
				var plane:Plane = new Plane(bmpMat, 150, planeHeight, 4, 4);
				plane.x = Math.floor( i / 3) * 200;
				plane.y = i % 3 * 200;				
				plane.y -= (i % 3 == 0) ? 125 / 2 : 0;			
				//修正反射Plane物件的y軸。				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onEvent3DOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onEvent3DOut);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onEvent3DClick);
				view.scene.addChild(plane);
			}
		}
		private function onMouseWheel(e:MouseEvent):void {
			//用 MouseEvent 類別下的 delta 屬性可以得到滑鼠滾輪的值
			//e.dalta如果大於0,表示滾輪向上,小於0表示向下。			
			cameraZ = view.camera.z + (e.delta * 100);
			//將 camera 要移動到的目標 z 軸值寫入至 cameraZ 變數裡
			if (cameraZ < cameraZMin) {
				cameraZ = cameraZMin
			}else if(cameraZ > cameraZMax){
				cameraZ = cameraZMax
			}
			//判斷目標 z 軸值是否小於最小值或是大於最大值, 再決定 camera 要移動到的目標			
		}
		private function onEvent3DOver(e:InteractiveScene3DEvent):void {
			//當滑鼠滑入感應區時, 讓廣播者物件稍往前移
			Tweener.addTween( e.displayObject3D,{
                z		: -10,
                time	:1
			});
		}
		private function onEvent3DOut(e:InteractiveScene3DEvent):void {
			//當滑鼠離開感應區, 讓廣播者的 z 軸回復到 0
			Tweener.addTween( e.displayObject3D,{
                z		: 0,
                time	:1
			});
		}
		private function onEvent3DClick(e:InteractiveScene3DEvent):void{
			var _target:Plane = e.displayObject3D as Plane;
			//當使用者點選圖片時, 先取得廣播者 (被點選者),
			//其x,y,z屬性即是Camera的目標值,
			//z軸要多減去150,讓Camera可以往後一點
			cameraX = _target.x;
			cameraY = _target.y;
			cameraZ = _target.z -150;
			bg_mc.addEventListener(MouseEvent.CLICK, onBackGroundClick);
			//偵聽場景上的bg_mc物件所發出的MouseEvent.CLICK事件。
		}
		
		private function onBackGroundClick(e:MouseEvent):void{
			cameraZ = -1000;
			//目標Z軸回到-1000;
			bg_mc.removeEventListener(MouseEvent.CLICK, onBackGroundClick);
			//取消偵聽。
		}

        private function onEventRender3D(e:Event):void{			
			var _incrementX:Number = (cameraX - view.camera.x) / 20;
			//算出x軸的移動量			
			var _incrementRotation:Number = (_incrementX - view.camera.rotationY) / 20;
			//把 x 軸的移動量當成 rotationY 的目標值, 套入至漸進公式裡 
			//這樣可以做出 Camera 到達到目標 x 軸後, 再慢慢轉正的效果
			view.camera.rotationY += _incrementRotation;
			
			view.camera.x += _incrementX;
			// x 軸的漸進公式
			view.camera.y += (cameraY - view.camera.y) / 20;
			// y 軸的漸進公式
			view.camera.z += (cameraZ - view.camera.z) / 20;
			// z 軸的漸進公式
			view.singleRender();
        }
    }
}
