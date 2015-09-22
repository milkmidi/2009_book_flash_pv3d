package {
	import flash.display.MovieClip;
	import flash.events.Event;			
	import org.papervision3d.view.BasicView;	
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;	
	public class A06_primitives_Cube_difMaterial extends MovieClip {		
		private var view		:BasicView;			
		private var cube		:Cube;		
		public function A06_primitives_Cube_difMaterial():void {
			init3DEngine();			
			init3DObject();
		}
		private function init3DEngine():void{			
			view = new BasicView(0, 0, true, true, "Target");									
			this.addChild(view);						
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);				
		}
		private function init3DObject():void {			
			var wireMatR		:WireframeMaterial = new WireframeMaterial(0xff0000, 1);	
			var wireMatG		:WireframeMaterial = new WireframeMaterial(0x00ff00, 1);	
			var wireMatB		:WireframeMaterial = new WireframeMaterial(0x0000ff, 1);	
			var colorMatR	:ColorMaterial = new ColorMaterial(0xff0000, 1);			
			var colorMatG	:ColorMaterial = new ColorMaterial(0x00ff00, 1);			
			var colorMatB	:ColorMaterial = new ColorMaterial(0x0000ff, 1);			
			var ml			:MaterialsList = new MaterialsList(
			{ 
				top		:wireMatR  ,
				bottom	:wireMatG  ,
				left	:wireMatB  ,
				right	:colorMatR ,
				front	:colorMatG ,
				back	:colorMatB 
			} );			
			//Cube的六面物件, 名稱分別為top, bottom, left, right, front, back。
			cube = new Cube(ml, 400, 400, 400);						
			//建立Cube方塊物件。		
			view.scene.addChild(cube);			
		}
		private function onEventRender3D(e:Event):void {
			cube.rotationY += 3;
			cube.rotationX += 3;
			view.singleRender();			
		}
	}
}