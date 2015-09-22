package {//類別包路徑
	import flash.display.MovieClip;
	//匯入類別，寫時間軸預設是所有FLASH內建的類別皆可直接使用
	//但寫class就需要一個一個匯入，
	//或是可以一次匯入某某類別包下的所有類別
	//如：import flash.display.*;
	//這句指的是匯入flash.display包下的所有類別
	public class A01_BaseDocumentClass extends MovieClip {
		//類別名稱：A01_BaseDocumentClass，繼承MovieClip類別
		
		public function A01_BaseDocumentClass(){
			//建構函式，與類別名稱、檔名需要一樣。
			//此函式在建構時會被執行一次，之後就無法再被呼叫。
			trace("A01_BaseDocumentClass類別，建構成功。");
		}
	}
}
