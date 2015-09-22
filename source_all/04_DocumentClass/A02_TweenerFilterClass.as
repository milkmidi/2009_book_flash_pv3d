package {
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	import flash.events.MouseEvent;
	//匯入所需的類別檔。
	
	public class A02_TweenerFilterClass extends MovieClip {
		//類別名稱：A02_TweenerFilterClass，繼承MovieClip物件
		
		public function A02_TweenerFilterClass(){
			FilterShortcuts.init();
			clip_mc.addEventListener(MouseEvent.ROLL_OVER,onEventRollOver)
			clip_mc.addEventListener(MouseEvent.ROLL_OUT, onEventRollOut)
			//把要初始化的事件寫在建構函式裡。
			
		}
		private function onEventRollOver (e:MouseEvent):void {
			Tweener.addTween(e.currentTarget,
			{
			   _Blur_blurX	:60,//修改Blur濾鏡的x值
			   _Blur_blurY 	:60,//修改Blur濾鏡的y值
			   time			:1,   //在幾秒鐘內完成該Tweener的動作，必填參數。
			   transition	:"easeInOutBounce"
			});
		}

		private function onEventRollOut (e:MouseEvent):void {
			Tweener.addTween(e.currentTarget,
			{
			   _Blur_blurX	:0,//修改Blur濾鏡的x值
			   _Blur_blurY 	:0,//修改Blur濾鏡的y值
			   time			:1,   //在幾秒鐘內完成該Tweener的動作，必填參數。
			   transition	:""
			});
		}
	}
}
