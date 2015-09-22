package {		
	import flash.display.MovieClip;
	import flash.events.Event;	
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;	
	import org.papervision3d.objects.primitives.Cube
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.events.InteractiveScene3DEvent;		
	import org.papervision3d.render.QuadrantRenderEngine;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.view.BasicView;	
	import caurina.transitions.Tweener;	
	import caurina.transitions.properties.CurveModifiers;		
	
	public class CubeJumpDemo extends MovieClip {			
		private var view	:BasicView;		
		private var light   :PointLight3D = new PointLight3D();	
		//光源物件
		public function CubeJumpDemo() {
			CurveModifiers.init();			
			//啟動 Tweener 類別的快速編修貝茲曲線功能
			init3DEngine();			
			init3DObject();					
		}
		private function init3DEngine():void {
			view = new BasicView(0, 0, true, true, "Target");						
			view.camera.z = -2000;
			view.viewport.buttonMode = true;
			view.renderer = new QuadrantRenderEngine(QuadrantRenderEngine.CORRECT_Z_FILTER);
			//將view物件下的renderer運算類別換成的QuadrantRenderEngine類別。
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			light.y = 3000;		
			//光源物件的y軸座標
			view.scene.addChild(light);		
			//加入光源至scene裡。
			//建立5個Cube。
			createCube(0x85DB18 , -1000 , 0)			
			createCube(0xCDE855 , -500 , 0.01);
			createCube(0xF5F6D4 , 0, 0.02);			
			createCube(0x493F0B , 500, 0.03);			
			createCube(0xA7C520 , 1000, 0.04);						
		}
		private function createCube(p_color:uint, p_x:int , p_delay:Number):void {						
			var _flmat		:FlatShadeMaterial  = new FlatShadeMaterial(light, p_color , 0xffffff);
			//光源材質。
			_flmat.interactive = true;
			//互動模式。
			var _ml			:MaterialsList = new MaterialsList( { all:_flmat } );			
			//材質列表。
			var _cube		:Cube = new Cube(_ml, 300, 300, 300);			
			//建構Cube物件。
			_cube.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK , on3DClick);
			//偵聽Click事件。
			_cube.x = p_x;
			_cube.y = 2000;
			
			var colotMat:ColorMaterial = new ColorMaterial(0x000000, .8, false);
			var _shadow		:Plane = new Plane(colotMat, 300, 300);
			//建構Plane物件，並貼上色彩材質來當做影子。
			_shadow.rotationX = 90;
			_shadow.x = p_x;
			_shadow.y = -150;
			view.scene.addChild(_shadow);
			
			_cube.extra = { shadow:_shadow };
			//為cube物件指定額外的屬性。
			Tweener.addTween(_cube,
			{
				y				:0,
				time			:2,
				delay			:p_delay,
				transition		:"easeOutBounce",
				onUpdate    	:_onTweenerUpdate,
				onUpdateParams	:[_cube]
			});			
			//播放Tweener動畫，讓Cube掉下並有彈跳的效果。
			view.scene.addChild(_cube);			
		}		
		private function on3DClick(e:InteractiveScene3DEvent):void {
			e.displayObject3D.rotationX = 0;
			//當Cube被點擊時，播放二個Tweener動畫
			//一個製作y軸的動畫。
			//一個製作rotationX的動畫。
			Tweener.addTween(e.displayObject3D, 
			{
				y:0, z:0,
				_bezier		: { z:0, y:700 }, 
				time		:1,
				transition	:"linear" 
			} );			
			Tweener.addTween(e.displayObject3D,
			{
				rotationX		:360,
				time			:1.6,
				onUpdate    	:_onTweenerUpdate,
				//當Tweener在更新數值時,可以不斷呼叫自已設定的函式
				onUpdateParams	:[e.displayObject3D]
				//將參數傳給自訂的 _onTweenerUpdate 函式
			} );
		}
		private function _onTweenerUpdate(p_obj:DisplayObject3D):void {
			var _dur:Number = p_obj.y / 500;
			var _shadow:Plane = p_obj.extra.shadow as Plane;
			_shadow.scale = Math.max(1 - _dur, 0);	
			//當 Tweener 在更新數值時, 也一起更改影子的大小值
		}
		private function onEventRender3D(e:Event):void {			
			var _targetX:Number = (stage.stageWidth / 2 - stage.mouseX) * 3;			
			var _targetY:Number = stage.stageHeight / 2 - stage.mouseY;			
			view.camera.x += (_targetX - view.camera.x) / 10;
			view.camera.y = _targetY + 300;
			view.camera.z = Math.abs(_targetX)/3 - 1500;		
			view.singleRender();
		}	
	}
}

