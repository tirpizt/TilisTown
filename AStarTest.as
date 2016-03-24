package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import algorithm.PathFinder;
	
	import component.Grid;
	
	/**
	 * AStarTest
	 * @author Tirpizt
	 * 
	 */	
	public class AStarTest extends Sprite
	{
		private var _grid:Grid;
		private var _pathFinder:PathFinder;
		public function AStarTest()
		{
			_grid = new Grid;
			_grid.y = 100;
			addChild(_grid);
			
			var btn:Sprite = new Sprite;
			btn.graphics.beginFill(0xffff00);
			btn.graphics.drawCircle(30,80,10);
			btn.graphics.endFill();
			addChild(btn);
			
			btn.addEventListener(MouseEvent.CLICK,clickHandler);
			_pathFinder = new PathFinder();
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			_grid.resetGrid(10,10,20,new Point(0,0),new Point(9,9));
			_pathFinder.initMap(_grid.getGridVec(),_grid.gridWidth,_grid.gridHeight);
			_pathFinder.setStartAndEnd(new Point(0,0),new Point(9,9));
			var v:Vector.<Point> = _pathFinder.getNewPath();
			if(v){
				_grid.setPath(v);
			}
		}
	}
}