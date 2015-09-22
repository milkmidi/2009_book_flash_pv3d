package {
    import flash.display.*;
    import flash.events.*;
	import flash.net.navigateToURL;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.*;
	import org.papervision3d.view.BasicView;
	import caurina.transitions.Tweener;
	import milkmidi.papervision3d.materials.ReflectionFileMaterial;
	
	//匯入筆者所寫的反射材質。
    public class CoverFlow extends MovieClip{		
		private var view			:BasicView;
		private var loadedNumber	:int = 0;  //已載入的圖片數量。
		private var itemOfNumber	:int = 12; //物件數量。
		private var currentPlaneIndex:Number = 0;//目前圖片的索引值。
		private var planeAngle		:Number = 43;   //角度。
		private var planeSeparation	:Number = 120;  //左右二邊Plane與Plane的間距。
		private var planeOffset		:Number = 160;  //目前所選擇的Plane其左右的間距。
		private var selectPlaneY	:Number = -40;  //目前所選擇Plane的y值。
		private var selectPlaneZ	:Number = -490;	//目前所選擇Plane的z值。
		public function CoverFlow(){
			init3DEngine();
			init3DObject();
			initObject();			
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");
			view.camera.z = -800; 
			view.viewport.buttonMode = true;			
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void{
			for (var i:int = 0 ; i < itemOfNumber; i++){
				var refMat:ReflectionFileMaterial = new ReflectionFileMaterial("images/" + i + ".jpg", true);
				//使用筆者所寫的ReflectionFileMaterial反射材質。
				//new ReflectionFileMaterial(圖片路徑:String,精準模式:Boolean)。
				refMat.addEventListener(FileLoadEvent.LOAD_COMPLETE, onFileLoaderComplete);
				//偵聽refMat發出的FileLoadEvent.LOAD_COMPLETE事件。
				refMat.interactive = true;
				//互動模式開啟。
				var plane:Plane  = new Plane( refMat, 200, 300, 4, 4);
				plane.name = "item" + i;
				plane.extra = { id:i };
				//為每個plane設定一個唯一的id值。
				plane.z = i * -20;
				//讓z軸遞減。
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, on3DClick);
				//偵聽InteractiveScene3DEvent.OBJECT_CLICK事件。
				view.scene.addChild(plane);
			}
		}
		private function initObject():void{
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, onEventMouseWheel);
			//ActionScript3,只有stage是全域的滑鼠感應。
			//偵聽stage發出的滑鼠滾輪事件。
		}
		private function onFileLoaderComplete(e:FileLoadEvent):void {
			loadedNumber++;
			if (loadedNumber == itemOfNumber) {
				//如果已經載入的圖片數量等於總圖片數量
				shiftToItem(6);
				//執行shiftToItem函式。
			}
		}
		public function shiftToItem(p_id:int):void{
			currentPlaneIndex = p_id;
			//將目標編號寫入currentPlaneIndex變數。
			
			stage.quality = StageQuality.MEDIUM;
			//把整體的品質設成中等,漸少效能的運算。
			var _tweenObj:Object;
			//用for回圈,一次更改所有plane的屬性。
			for (var i:int = 0; i < itemOfNumber; i++){
				var plane:Plane = view.scene.getChildByName("item" + i) as Plane;
				//Scene類別下的getChildByName方法, 可以得到其子系物件,型別為DisplayObject3D。
				//型別不同，所以要轉換。
				var dis	:int = i - p_id;
				//算出目前回圈值與目標編號值的差。				
				if (i == p_id) {
					//如果目前回圈值等於目標編號值
					//表示目前所算算的plane為正中間顯示。
					_tweenObj =
					{
						x			:0,
						y			:selectPlaneY,
						z			:selectPlaneZ,
						rotationY	:0,
						onComplete	:function ():void {
							stage.quality = StageQuality.HIGH;
							//當Tweener完成時,再把品質調成高。
						}
					};
					//把值寫入到_tweenObj物件裡。
				} else if (i < p_id) {
					//如果回圈值小於目標編號值
					//表示該plane在左邊。
					_tweenObj =
					{
						x			:dis * planeSeparation - planeOffset,
						//x軸位置等於：距離差乘上間距,再多減去planeOffset變數。
						y			:0,
						z			:0,
						rotationY	: -planeAngle
					};
					
				} else  {
					//plane在右邊。
					_tweenObj =
					{
						x			:dis * planeSeparation  + planeOffset,
						//x軸位置等於：距離差乘上間距,再多加planeOffset變數。
						y			:0,
						z			:0,
						rotationY	:planeAngle
					};
				}
				_tweenObj.time = 0.8;
				Tweener.addTween(plane, _tweenObj);
				//使用Tweener移動物件。
			}
		}
		private function on3DClick(e:InteractiveScene3DEvent){
			var _id:int = e.displayObject3D.extra.id;
			//InteractiveScene3DEvent類別下有個displayObject3D屬性
			//可以得到廣播者,型別為DisplayObject3D
			//再透過extra屬性裡的id屬性,即可得到一開始我們為每個Plane設定的唯一id值。
			shiftToItem(_id);
			//把該值傳進shiftToItem函式執行。
		}
		private function onEventMouseWheel(e:MouseEvent):void {
			//MouseEvent類別下, delta屬性可以得到滑鼠滾輪的值
			//e.dalta如果大於0,表示滾輪向上,小於0表示向下。		
			if (e.delta < 0)  {
				moveRight();
			}else {
				moveLeft();
			}
		}
		public function moveLeft():void	{
			if (currentPlaneIndex > 0) {
				//如果目前plane的索引值大於0的話
				shiftToItem(currentPlaneIndex - 1);
			}
		}
		public function moveRight():void{
			if (currentPlaneIndex < itemOfNumber -1) {
				//如果目前plane的索引值小於總數量扣一
				shiftToItem(currentPlaneIndex + 1);
			}
		}
        private function onEventRender3D(e:Event):void{
			view.singleRender();
        }
    }
}


