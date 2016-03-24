package component
{
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * Grid
	 * @author Tirpizt
	 * 
	 */	
	public class Grid extends Sprite
	{
		private var _gridWidth:int;
		private var _gridHeight:int;
		private var _blockNum:int;
		private var _cellGroup:Vector.<Cell>;
		public function Grid()
		{
			_cellGroup = new Vector.<Cell>;
		}
		
		public function get gridHeight():int
		{
			return _gridHeight;
		}

		public function get gridWidth():int
		{
			return _gridWidth;
		}

		public function resetGrid(gridWidth:int,gridHeight:int,blockNum:int,starPoint:Point,endPoint:Point):void
		{
			if(blockNum > gridWidth*gridHeight){
				throw Error("设定封闭格子过多");
				return;
			}
			_gridWidth = gridWidth;
			_gridHeight = gridHeight;
			graphics.lineStyle(2,0x000000);
			graphics.lineTo(_gridWidth*Cell.CELL_WIDTH,0);
			graphics.lineTo(_gridWidth*Cell.CELL_WIDTH,_gridHeight*Cell.CELL_HEIGHT);
			graphics.lineTo(0,_gridHeight*Cell.CELL_HEIGHT);
			graphics.lineTo(0,0);
			
			_blockNum = blockNum;
			while(_cellGroup.length){
				_cellGroup.pop();
			}
			var total:int = _gridWidth*_gridHeight;
			var restBlockNum:int = _blockNum;//剩余未生成的封闭格子数
			var rand:Number = 0.0;
			for(var i:int = 0;i < total; i++){
				var cell:Cell = new Cell;
				addChild(cell);
				var X:int = i%_gridWidth;
				var Y:int = int(i/_gridWidth);
				cell.move(X*Cell.CELL_WIDTH,Y*Cell.CELL_HEIGHT);
				rand = Math.random();
				if(rand * (total-i) <= restBlockNum )
				{
					if(X == starPoint.x && Y == starPoint.y || X == endPoint.x && Y == endPoint.y){
						cell.isBlock = false;
					}else{
						cell.isBlock = true;
						restBlockNum--;
					}
				}else{
					cell.isBlock = false;
				}
				_cellGroup.push(cell);
			}
		}
		
		/**
		 *获取格子状态向量 
		 * @return 
		 * 
		 */		
		public function getGridVec():Vector.<Boolean>
		{
			var arr:Vector.<Boolean> = new Vector.<Boolean>;
			for(var i:int = 0;i < _cellGroup.length;i++){
				arr.push(_cellGroup[i].isBlock);
			}
			return arr;
		}
		
		/**
		 *设定路径 
		 * @param path
		 * 
		 */		
		public function setPath(path:Vector.<Point>):void
		{
			for(var i:int; i< path.length; i++){
				var index:int = path[i].x + path[i].y * _gridWidth;
				_cellGroup[index].isInPath = true;
			}
		}
	}
}