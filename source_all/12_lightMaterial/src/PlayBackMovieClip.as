package src {
	//設定類別包路徑為src。
	import flash.display.MovieClip;
	//匯入MovieClip類別。
	import flash.events.Event;
	//匯入Event類別。
	public class PlayBackMovieClip extends MovieClip {		
		//PlayBackMovieClip類別, 繼承MovieClip類別。
		public function PlayBackMovieClip() {						
			//建構函式, 被建構時讓影格停止。
			this.stop();
			this.addFrameScript(totalFrames - 1, _addFrameScript9);			
			//addFrameScript(影格數:uint , 新增的函式:Function);
			//是MovieClip類別擁有的方法。
			//能動態在指定的影格新增程式碼。
			//0表示第一個影格,1表示第二個影格,依此類推。			
		}
		
		private function _addFrameScript9():void{
			stop();
			//在影格10的地方, 增加程式碼stop();
		}
		public function playBack():void {
			//新增一個新方法playBack();
			//設定成public公開的, 這樣其他的類別才能呼叫。
			this.addEventListener(Event.ENTER_FRAME, onEventEnterFrame);
			//偵聽EnterFrame事件。
		}		
		private function onEventEnterFrame(e:Event):void {
			//偵聽者函式, 不需要給其他類別呼叫
			//所以設定成private私有的即可。
			if (this.currentFrame == 1) {
				//如果現在的影格等於1,
				//取消偵聽事件。
				this.removeEventListener(Event.ENTER_FRAME, onEventEnterFrame);
			}else {
				//否則上一個影格。
				this.prevFrame();
			}
		}
	}
}
