package src {
	//設定類別套件路徑為 src
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	public class ButtonMC extends PlayBackMovieClip {		
		//定義 ButtonClip 類別, 並繼承 PlayBackMovieClip 類別
		public var id:int;
		//為該類別設定一個公開的變數
		//該變數由外部成員定義, 在此範例是用來當做陣列的索引值使用
		public function ButtonMC() {						
			this.addEventListener(MouseEvent.ROLL_OVER, onEventRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onEventRollOut);
			//在建構函式時, 就設定好偵聽滑鼠滑入與滑出事件
			this.buttonMode = true;
			//開啟按鈕模式。
		}	
		private function onEventRollOver(e:MouseEvent):void {
			this.play();
			//播放影格動畫
		}		
		private function onEventRollOut(e:MouseEvent):void {
			this.playBack();
			//因為是繼承 PlayBackMovieClip 類別, 所以也能使用 playback() 方法來倒退播放
		}
	}
}
