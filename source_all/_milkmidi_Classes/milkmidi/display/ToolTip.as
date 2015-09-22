package milkmidi.display {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	public class ToolTip extends Sprite {
		
		private var _txt:TextField;
		private var _text:String = "";
		
		public function ToolTip(pWidth:int = 25) {			
			_txt = new TextField();
			_txt.textColor = 0xbbbbbb;			
			this.graphics.lineStyle(1, 0xcccccc);
			this.graphics.beginFill(0xffff00, 1);
			this.graphics.drawRect(0, 0, pWidth, 18);			
			this.graphics.endFill();
			this.addChild(_txt);
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
	
		public function get text():String { return _text; }
		
		public function set text(pText:String):void {
			_text = pText;
			_txt.text = _text;
		}		
	}
}