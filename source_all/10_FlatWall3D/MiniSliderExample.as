package {
	import flash.display.Sprite;
	import flash.events.Event;
	import milkmidi.display.MiniSlider;
	public class MiniSliderExample extends Sprite  {
		private var slider		:MiniSlider;
		public function MiniSliderExample() {
			slider = new MiniSlider(0, 2000, 200);
			//建立MiniSlder物件。
			//new MiniSlider(最小值:Number , 最大值:Number, 物件寬度:Number)。
			slider.addEventListener(MiniSlider.SLIDER, onSlider);			
			//偵聽MiniSlider.SLIDER事件。
			slider.x = stage.stageWidth / 2 - 50;
			slider.y = stage.stageHeight - 50;
			//slider物件的x,y座標。
			this.addChild(slider);			
		}		
		private function onSlider(e:Event):void {
			trace("value:" +slider.value, "percentage:" + slider.percentage);			
		}
	}		
}