package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import src.PlayBackMovieClip;
	//匯入我們自定的ChildMovieClip類別
	public class A03_privatePublicDemo extends MovieClip {
		private var _mc:PlayBackMovieClip;
		//宣告_mc變數, 型別為PlayBackMovieClip。
		public function A03_privatePublicDemo(){
			_mc = new PlayBackMovieClip();
			//建構PlayBackMovieClip類別。			
			//PlayBackMovieClip類別是繼承至MovieClip類別,
			//所有MovieClip類別擁有的屬性和方法該類別也擁有。
			_mc.x = 40;
			_mc.y = 40;
			//_mc物件的座標位置。
			this.addChild(_mc);
			//加入該物件至目前的容器。
			
			_mc.addEventListener(MouseEvent.ROLL_OVER, onEventRollOver);
			_mc.addEventListener(MouseEvent.ROLL_OUT, onEventRollOut);
			//偵聽		
		}
		
		private function onEventRollOver(e:MouseEvent):void {
			//當滑鼠移入時, 讓 _mc 物件開始播放
			_mc.play();
		}
		
		private function onEventRollOut(e:MouseEvent):void {			
			_mc.playBack();
			//當滑鼠移出時, 讓 _mc 物件執行我們新增的倒退播放效果
			//執行我們在 PlayBackMovieClip 類別中自訂的 playBack() 方法			
		}
	}
}
