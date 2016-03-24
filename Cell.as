package component
{
	import flash.display.Sprite;
	
	/**
	 * Cell
	 * @author Tirpizt
	 * 
	 */	
	public class Cell extends Sprite
	{
		private var _isBlock:Boolean;
		private var _isInPath:Boolean;
		public static const CELL_WIDTH:int = 10;
		public static const CELL_HEIGHT:int = 10;
		public function Cell()
		{
			super();
		}

		public function get isInPath():Boolean
		{
			return _isInPath;
		}

		public function set isInPath(value:Boolean):void
		{
			_isInPath = value;
			if(_isInPath){
				graphics.clear();
				graphics.beginFill(0x00ff00);
				graphics.drawRect(0,0,CELL_WIDTH,CELL_HEIGHT);
				graphics.endFill();
			}
		}

		public function get isBlock():Boolean
		{
			return _isBlock;
		}

		public function set isBlock(value:Boolean):void
		{
			_isBlock = value;
			graphics.clear();
			if(_isBlock){
				graphics.beginFill(0xff0000);
			}else{
				graphics.beginFill(0xffffff);
			}
			graphics.drawRect(0,0,CELL_WIDTH,CELL_HEIGHT);
			graphics.endFill();
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
	}
}