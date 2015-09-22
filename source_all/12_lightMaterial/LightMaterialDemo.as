package{	
	import flash.display.BitmapData;
	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.shadematerials.*;	
	import org.papervision3d.materials.special.CompositeMaterial;		
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.view.BasicView;
	import src.ButtonMC;
	//匯入我們自定的ButtonMC類別。
	public class LightMaterialDemo extends MovieClip{
		private var view		:BasicView;
		private var light 		:PointLight3D; 		//點光源3D物件。				
		private var cube		:Cube;		//方塊。
		private var sphere		:Sphere;	//球體。
		private var matArray	:Array = new Array();//陣列物件
		public function LightMaterialDemo(){
			init3DEngine();
			init3DObject();
			initObject();
		}
		
		
		private function init3DEngine():void{
			view = new BasicView(0, 0, true, true, "Target");			
			view.camera.y = 500;
			view.camera.z = -1200;
			this.addChild(view);
			this.addEventListener(Event.ENTER_FRAME, onEventRender3D);
		}
		private function init3DObject():void {
			light = new PointLight3D(true);
			//建立光源物件語法：new PointLight3D(是否出現光源實體:Boolean);
			//將是否出現光源實體參數設成 true 的話, 就會出現一菱形物件, 顯示現在的光源位置

			light.y = 400;			
			//PointLight3D是繼承DisplyObject3D類別,
			//所以也有擁x,y,z等屬性。
			
			view.scene.addChild(light);
			//將光源物件加入至view.scene。
			
			var wireMat:WireframeMaterial = new WireframeMaterial(0xddeeaa);
			//線框材質。			
			var ml:MaterialsList = new MaterialsList( 
			{
				all:wireMat
			});
			//材質列表。
			cube = new Cube(ml, 400, 400, 400, 2, 2, 2);			
			//建構Cube物件。
			view.scene.addChild(cube);
			
			sphere = new Sphere(wireMat, 200);
			//建構Sphere物件。
			sphere.x = 800;
			view.scene.addChild(sphere);
		}
		private function initObject():void {		
			//先把全部要用到的材質建立起來, 並放在 Array 裡
			//當使用者點擊按鈕時, 就到 Array 中找尋對應的材質物件, 並更換 Cube 和 Sphere 的材質			
			var colorMat	:ColorMaterial = new ColorMaterial(0xF5F6D4);
			//色彩材質
			colorMat.name = "ColorMaterial";
			//材質類別也可以取實體名稱
			matArray.push(colorMat);
			//放入陣列裡。
			
			var wireMat		:WireframeMaterial = new WireframeMaterial(0xffccff);
			//線框材質
			wireMat.name = "WireframeMaterial";
			matArray.push(wireMat);
			
			var compoMat	:CompositeMaterial = new CompositeMaterial();
			//合成材質, 能將二個以上的材質結合成一個
			compoMat.addMaterial(colorMat);			
			compoMat.addMaterial(wireMat);
			//將色彩材質和線框材質合成。
			compoMat.name = "CompositeMaterial";
			matArray.push(compoMat);
			
			var bmpMat		:BitmapAssetMaterial = new BitmapAssetMaterial("MyBitmapData", true);
			//點陣圖材質, 來源是元件庫中的點陣圖
			bmpMat.name = "BitmapMaterial";
			matArray.push(bmpMat);
			
			var movieMat	:MovieAssetMaterial = new MovieAssetMaterial("ItemMC", false, true);
			//影片片段材質, 來源是元件庫中的 MovieClip
			movieMat.name = "MovieMaterial";
			matArray.push(movieMat);			
			
			
			///////////////---------------光源材質系列-------------
			var flatMat		:FlatShadeMaterial  = new FlatShadeMaterial(light, 0xF5F6D4, 0);						
			//FlatShadeMaterial 為多邊形的每個面都產生陰影, 其建構構語法：	
			//new FlatShadeMaterial	(光源:PointLight3D ,光源顏色:uint,周圍顏色:uint );			
			flatMat.name = "FlatShadeMaterial";
			matArray.push(flatMat);
			
			var cellMat 	:CellMaterial		= new CellMaterial(light, 0xF5F6D4, 0, 12);
			//CellMaterial 使用兩種顏色和漸變數量做為參數, 其建構構語法：
			//new CellMaterial		(光源:PointLight3D , 第一種顏色:uint, 第二種顏色:uint , 階段:int );						
			cellMat.name = "CellMaterial";
			matArray.push(cellMat);				
			
			var gouraudMat	:GouraudMaterial	= new GouraudMaterial(light, 0xF5F6D4, 0);	
			//GouraudMaterial 可以讓陰影有平滑效果, 其建構構語法：
			//new GouraudMaterial	(光源:PointLight3D ,光源顏色:uint,周圍顏色:uint );
			gouraudMat.name = "GouraudMaterial";
			matArray.push(gouraudMat);
			
			var phongMat	:PhongMaterial 		= new PhongMaterial(light, 0xF5F6D4, 0, 10);						
			//PhongMaterial和 GouraudMaterial很像, 但它有類似鏡子般的反射光源效果,
			//其建構構語法：
			//new PhongMaterial		(光源:PointLight3D ,光源顏色:uint,周圍顏色:uint ,光源反射值:int );	
			phongMat.name = "PhongMaterial";
			matArray.push(phongMat);				
			
			for (var i:int = 0; i < matArray.length; i++) {
				//使用回圈建立按鈕元件。
				var _btnMC:ButtonMC = new ButtonMC();
				_btnMC.y = i * 22 +30;
				_btnMC.mouseChildren = false;
				//讓其容器內的子物件滑鼠感應功能失效。				
				_btnMC.name = "btn" + i;
				_btnMC.id = i;
				_btnMC.label_txt.text = matArray[i].name;
				_btnMC.addEventListener(MouseEvent.CLICK, onButtonClick);
				this.addChild(_btnMC);
			}
		}
		
		private function onButtonClick(e:MouseEvent):void {
			var _mat:MaterialObject3D = matArray[e.currentTarget.id];
			//得到相對映的材質。
			label_txt.text = _mat.name;
			//場景上的labet_txt動態文字, 其顯示的文字為材質的實體明稱。
			cube.replaceMaterialByName( _mat , "all");				
			//cube物件使用replaceMaterialByName函式, 一次置換六面的材質。
			sphere.material = _mat;
			//將更換sphere物件的材質
		}	
		private function onEventRender3D(e:Event):void {			
			light.x = stage.mouseX - stage.stageWidth / 2			
			//移動光源的x軸
			cube.rotationY += .5;
			cube.rotationX += .5;
			//旋轉
			sphere.rotationY += .5;
			view.singleRender();
		}		
	}	
}
