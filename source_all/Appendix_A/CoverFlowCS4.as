package {
    import flash.display.*;
    import flash.events.*;	
	import flash.net.URLRequest;
	import caurina.transitions.Tweener;	
    public class CoverFlowCS4 extends MovieClip {		
		private var itemOfNumber		:int = 12;//物件數量
		private var currentPlaneIndex	:Number = 0;//目前圖片的索引值
		private var planeAngle			:Number = 43;   //角度
		private var planeSeparation		:Number = 120;  //左右二邊Plane與Plane的間距。
		private var planeOffset			:Number = 200;  //目前所選擇的Plane其左右的間距。
		private var selectPlaneY		:Number = -50;  //目前所選擇Plane的y值
		private var selectPlaneZ		:Number = -490;	//目前所選擇Plane的z值
		private var container			:Sprite;
		private var sortArray			:Array = new Array();
		//排序用的陣列
		public function CoverFlowCS4(){
			initObject();			
		}		
		private function initObject():void {
			container = new Sprite();
			//建構物件，其類別為Sprite。
			container.x = stage.stageWidth / 2;
			container.y = stage.stageHeight / 2;
			//對個場景的正中間。
			container.z = 500;
			//Sprite繼承DisplayObject, 一樣擁有3D屬性。
			//z軸為正500，就是往後移動。
			container.rotationX = 5;
			//以x軸為軸心做旋轉。
			this.addChild(container);
			//加入至目前的容器。
			for (var i:int = 0 ; i < itemOfNumber; i++){
				var _mc:MovieClip = new ItemMC();
				//宣告_mc變數，型別為MovieClip，建構ItemMC類別，來源是元件庫設定的類別名稱。
				var _ldr:Loader = new Loader();
				//建構Loader類別。
				_ldr.load(new URLRequest("images/" + i + ".jpg"));
				//載入圖檔。						
				_ldr.x = -127;
				_ldr.y = -120;
				_mc.addChild(_ldr);
				//將Loader加入至_mc物件裡。
				_mc.id = i;
				//直定id變數。
				_mc.z = i * -20;
				//修改z軸屬性。
				_mc.name = "item" + i;
				//實體名稱。
				_mc.buttonMode = true;
				//開啟按鈕模式。
				_mc.addEventListener(MouseEvent.ROLL_OVER, onEventRollOver);
				_mc.addEventListener(MouseEvent.ROLL_OUT, onEventRollOut);
				_mc.addEventListener(MouseEvent.CLICK, onClick);
				//偵聽滑鼠事件。
				container.addChild(_mc);
				//將_mc物件加入至container裡。
				sortArray.push(_mc);
			}
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, onEventMouseWheel);
			//偵聽滾輪事件。
			shiftToItem(6);
			//執行shiftToItem函式。
		}
		
		private function onEventRollOver(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("over");
			//當RollOver物件時，就讓廣播者從over表籤開始播放。
		}
		
		private function onEventRollOut(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("out");
			//當RollOut物件時，就讓廣播者從out表籤開始播放。
		}
		
	
		
		public function shiftToItem(p_id:int):void{
			currentPlaneIndex = p_id;
			//將新編號值寫入currentPlaneIndex變數。
			
			var _tweenObj:Object;
			//用for回圈,一次更改所有plane的屬性。
			for (var i:int = 0; i < itemOfNumber; i++){
				var _mc:MovieClip = container.getChildByName("item" + i) as MovieClip;
				//container是Sprite類別，可以使用getChildByName的方法得到其子系物件。				
				//型別不同，所以要轉換。
				var dis	:int = i - p_id;
				//算出目前回圈值與新值的差。
				if (i == p_id) {
					//如果目前回圈值等於新值
					//表示該plane為正中間顯示。
					_tweenObj =
					{
						x			:0,
						y			:selectPlaneY,
						z			:selectPlaneZ,
						rotationY	:0,
						onUpdate    :sortChildren
						//數值更新時, 不斷的執行sortChildren函式。
					};
					//把值寫入到_tweenObj物件裡。
				} else if (i < p_id) {
					//如果回圈值小於新值
					//表示該plane在左邊。
					_tweenObj =
					{
						x			:dis * planeSeparation - planeOffset,
						y			:0,
						z			:Math.abs(dis) * 100,
						rotationY	: -planeAngle
					};
					
				} else  {
					//plane在右邊。
					_tweenObj =
					{
						x			:dis * planeSeparation  + planeOffset,
						y			:0,
						z			:Math.abs(dis) * 100,
						rotationY	:planeAngle
					};
				}
				_tweenObj.time = 0.8;
				Tweener.addTween(_mc, _tweenObj);
				//使用Tweener移動物件。
			}
		}		
		private function onClick(e:MouseEvent){
			var _id:int = e.currentTarget.id;
			shiftToItem(_id);
			//把該值傳進shiftToItem執行。
		}
		private function onEventMouseWheel(e:MouseEvent):void {
			//MouseEvent類別下, delta可以得到滑鼠滾輪的值
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
		public function sortChildren():void {			
			sortArray.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			//使用陣列的排序方法，依參數p_criteria，以數字型態遞減排序。			
			for (var i:int =  0; i< sortArray.length; i++) {
				var _child:MovieClip = sortArray[i] as MovieClip;				
				container.setChildIndex( _child, i );
				//重新指定深度。				
			}		
		}
    }
}


