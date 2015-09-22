﻿package{	
	import flash.display.MovieClip;
	//匯入MovieClip類別。
	import flash.events.Event;
	//匯入Event類別。
	import org.papervision3d.view.BasicView;
	//匯入BasicView類別。
	public class A01_BasicDocument extends MovieClip {	
		//A01_BasicDocument類別, 繼承MovieClip。		
		private var view:BasicView;		
		//宣告view變數, 型別為BasicView。		
		public function A01_BasicDocument():void{
			//建構函式, 該類別被實體化時, 會執行一次。
			//可以把要初始化的值或物件寫在這。	
			init3DEngine();
			//執行init3DEngine函式。
			init3DObject();
			//執行init3DObject函式。
		}
		private function init3DEngine():void{
			//此函式的用意是用來建立PV3D所需的基本類別。
			//在此建構BasicView物件、設定Camera參數。
			view = new BasicView(0, 0, true, true, "Target");						
			/*
			建構BasicView物件
			new BasicView(
				viewport寬度		:Number,
				viewport高度		:Number,
				是否自動對齊場景	:Boolean, 
				是否開啟滑鼠感應功能:Boolean,
				camera類別			:String
				) 			
			*/
			this.addChild(view);			
			//BasicView是繼承Sprite, 可被加入至可視物件容器裡。			
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);	
			//偵聽 Event.ENTER_FRAME 事件, 以便持續更新畫面
		}
		private function init3DObject():void{
			//init3DObject函式, 用來建立PV3D物件、材質及偵聽事件。
		}
		private function onEventRender3D(e:Event):void {			
			view.singleRender();
			//運算view物件。
			//使用算圖類別, 運算Camera所看到的Scene3D世界
			//並將結果呈顯在Viewport3D裡。
		}
	}
}