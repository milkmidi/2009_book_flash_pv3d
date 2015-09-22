package{	
	import flash.display.*;
	import flash.events.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.*;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.view.BasicView;
	import caurina.transitions.Tweener;
	public class Paper3Dworld extends MovieClip{
		private var view		:BasicView;
		private var itemOfNumber:int = 20;//物件數量
		private var radius 		:int = 1000; //範圍半徑		
		public function Paper3Dworld():void{
			init3DEngine();
			init3DObject();			
		}
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Free");
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			for (var i:int = 0 ; i < itemOfNumber; i++) {
				//使用回圈建立20個Plane物件。
				var bmpMat:BitmapFileMaterial = new BitmapFileMaterial("images/" + i + ".jpg", true);
				//點陣圖材質。
				bmpMat.doubleSided = true; 
				//雙面模式
				bmpMat.interactive = true; 
				//互動模式
				var plane:Plane = new Plane(bmpMat, 200, 150);				
				//建構Plane物件, 並貼上點陣圖材質, 預設的座標為0,0,0。
				//使用Tweener移動Plane物件到指定的座標。				
				Tweener.addTween(plane,
				{
					x 			: Math.random() * radius - radius / 2,					
					y 			: Math.random() * radius - radius / 2,					
					z 			: Math.random() * radius - radius / 2,
					/*在這兒我們希望x的範圍是   -500到500的亂數值
					 * Math.random()會回傳0到1的亂數浮點數，乘上radius變數，
					 * 即可得到0到1000的亂數，再減去500，即可達到我們要的範圍。
					 **/
					rotationX 	: Math.random() * 360,
					rotationY 	: Math.random() * 360,
					rotationZ 	: Math.random() * 360,
					/*
					 * 亂數旋轉方向。
					 * */
					time		: 3,
					transition	: "easeOutExpo",
					delay		: i * 0.02					
				} );				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, onInteractivePress);
				//偵聽Plane物件所廣播的InteractiveScene3DEvent.OBJECT_PRESS事件。
				view.scene.addChild(plane);
				//加入至Scene3D物件裡。
			}
		}
		private function onInteractivePress(e:InteractiveScene3DEvent):void {
			//透過e物件其displayObject3D屬性, 可以得到廣播者物件。
			//回傳的型別為DisplayObject3D。
			var _emptyObj3D:DisplayObject3D = new DisplayObject3D();
			//建立一個空的DisplayObject3D物件。
			_emptyObj3D.copyTransform( e.displayObject3D );
			//拷貝廣播者物件的屬性。
			_emptyObj3D.moveBackward( 300 );
			//讓空白的DisplayObject3D物件往後移動300。
			Tweener.addTween( view.camera,
			//使用Tweener來移動Camera。
			{
				x			:_emptyObj3D.x,
				y			:_emptyObj3D.y,
				z			:_emptyObj3D.z,
				rotationX	:_emptyObj3D.rotationX,
				rotationY	:_emptyObj3D.rotationY,
				rotationZ	:_emptyObj3D.rotationZ,
				time		:3,
				transition	:"easeOutExpo"
			} );
		}
		private function onEventRender3D(e:Event):void{
			view.singleRender();
		}
	}
}
