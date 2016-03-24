package algorithm
{
	import flash.geom.Point;

	/**
	 * PathFinder
	 * @author Tirpizt
	 * 
	 */	
	public class PathFinder
	{
		private var _all:Vector.<ASMapCell>;
		private var _openSet:Vector.<ASMapCell>;
		private var _closeSet:Vector.<ASMapCell>;
		private var _tempSet:Vector.<ASMapCell>;
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _startPoint:Point;
		private var _endPoint:Point;
		public function PathFinder()
		{
			_all 	  = new Vector.<ASMapCell>;
			_openSet  = new Vector.<ASMapCell>;
			_closeSet = new Vector.<ASMapCell>;
			_tempSet  = new Vector.<ASMapCell>;
		}
		
		/**
		 *清理列表 
		 * 
		 */		
		private function clear():void
		{
			while(_all.length){
				_all.pop();
			}
			
			while(_openSet.length){
				_openSet.pop();
			}
			
			while(_closeSet.length){
				_closeSet.pop();
			}
		}
		
		public function initMap(mapVec:Vector.<Boolean>,mapWidth:int,mapHeight:int):void
		{
			clear();
			_mapWidth = mapWidth;
			_mapHeight = mapHeight;
			for(var i:int = 0;i < mapVec.length;i++){
				var cell:ASMapCell = new ASMapCell;
				cell.X = i%mapWidth;
				cell.Y = int(i/mapHeight);
				cell.IsBlock = mapVec[i];
				cell.State = ASMapCell.CSNONE;
				_all.push(cell);
			}
		}
		
		public function setStartAndEnd(startPoint:Point,endPoint:Point):void
		{
			_startPoint = startPoint;
			_endPoint = endPoint;
		}
		
		/**
		 *获取路径 
		 * @return 
		 * 
		 */		
		public function getNewPath():Vector.<Point>
		{
			var path:Vector.<Point> = new Vector.<Point>;
			var i:int;
			//出发点
			var startCell:ASMapCell = getCellByPoint(_startPoint);
			var endCell:ASMapCell = getCellByPoint(_endPoint);
			if(startCell.IsBlock || endCell.IsBlock){
				trace("not a avaliable start or end");
				return null;
			}
			
			openCell(startCell);
			startCell.GCost = 0;
			startCell.HCost = Math.abs(endCell.X - startCell.X) + Math.abs(endCell.Y - startCell.Y);
			//当前考察的格子
			var curCell:ASMapCell;
			var lowestFValue:int;	//最低F值
			var lowestHCost:int;	//最低H值
			var lowestCell:ASMapCell;
			var lastLowestCell:ASMapCell;
			while(_openSet.length){
				var str:String;
				lowestFValue = int.MAX_VALUE;
				lowestHCost = int.MAX_VALUE;
				for(i = 0;i <_openSet.length; i++){
					curCell = _openSet[i];
					if(curCell.FValue < lowestFValue || 
						(curCell.FValue == lowestFValue && curCell.HCost < lowestHCost)){
						lowestFValue = curCell.FValue;
						lowestHCost = curCell.HCost;
						lowestCell = curCell;
						if(lowestCell.Prev){
							lowestCell.Prev.Next = curCell;
						}
					}
				};
				if(lastLowestCell == lowestCell){
					trace("no path");
					break;
				}
				lastLowestCell = lowestCell;
				closeCell(lowestCell);
				str = "closeSet:";
				for(i = 0;i <_closeSet.length; i++){
					str += "("+_closeSet[i].X+","+_closeSet[i].Y+")  ";
				}
				trace(str);
				//找到终点
				if(lowestCell.HCost == 0){
					curCell = lowestCell;
					while(curCell.Prev){
						path.unshift(new Point(curCell.X,curCell.Y));
						curCell = curCell.Prev;
					}
					path.push(_startPoint);
					break;
				}
				
				//增加openset
				while(_tempSet.length){
					_tempSet.pop();
				}
				for(i = 0;i<_closeSet.length;i++){
					curCell = _closeSet[i];
					var aroundcell:ASMapCell;
					if(curCell.X > 0){
						aroundcell = getCellByXY(curCell.X-1,curCell.Y);
						handleCell(aroundcell,curCell,endCell);
					}
					if(curCell.X < _mapWidth-1){
						aroundcell = getCellByXY(curCell.X+1,curCell.Y);
						handleCell(aroundcell,curCell,endCell);
					}
					if(curCell.Y > 0){
						aroundcell = getCellByXY(curCell.X,curCell.Y-1);
						handleCell(aroundcell,curCell,endCell);
					}
					if(curCell.Y < _mapHeight-1){
						aroundcell = getCellByXY(curCell.X,curCell.Y+1);
						handleCell(aroundcell,curCell,endCell);
					}
				}
				
				for(i = 0;i<_tempSet.length;i++){
					openCell(_tempSet[i]);
				}
				
				str = "openSet:";
				for(i = 0;i <_openSet.length; i++){
					str += "("+_openSet[i].X+","+_openSet[i].Y+")  ";
				}
				trace(str);
				trace("===========================");
			}
			return path;
		}
		
//		public function getCloseSet():void
//		{
//			return
//		}
		
		private function handleCell(aroundcell:ASMapCell,curCell:ASMapCell,endCell:ASMapCell):void
		{
			if(!aroundcell.IsBlock && aroundcell.State != ASMapCell.CSCLOSE){
				if(aroundcell.State == ASMapCell.CSNONE){
					_tempSet.push(aroundcell);
				}
				setCost(aroundcell,curCell,endCell);
			}
		}
		
		/**
		 *设置格子FGH值 
		 * @param cell
		 * @param preCell
		 * @param endCell
		 * 
		 */		
		private function setCost(cell:ASMapCell,preCell:ASMapCell,endCell:ASMapCell):void
		{
			var gCost:int = preCell.GCost + 1;
			if(cell.GCost == 0 || gCost < cell.GCost){
				cell.GCost = gCost;
				cell.Prev = preCell;
			}
			cell.HCost = Math.abs(endCell.X - cell.X) + Math.abs(endCell.Y - cell.Y);
			cell.FValue = cell.GCost + cell.HCost;
		}
		
		/**
		 *将格子置入openset
		 * @param cell
		 * 
		 */		
		private function openCell(cell:ASMapCell):void
		{
			if(cell.State != ASMapCell.CSOPEN){
				_openSet.push(cell);
				cell.State = ASMapCell.CSOPEN;
			}
		}
		
		/**
		 *将格子置入closeset
		 * @param cell
		 * 
		 */
		private function closeCell(cell:ASMapCell):void
		{
			if(cell.State != ASMapCell.CSCLOSE){
				_closeSet.push(cell);
				_openSet.splice(_openSet.indexOf(cell),1);
				cell.State = ASMapCell.CSCLOSE;
			}
		}
		
		private function getCellByPoint(p:Point):ASMapCell
		{
			return getCellByXY(p.x , p.y);
		}
		
		private function getCellByXY(X:int,Y:int):ASMapCell
		{
			var index:int = X + Y*_mapWidth;//点的索引
			return _all[index];
		}
	}
	
}

final class ASMapCell extends Object
{
	public var X:int;
	public var Y:int;
	public var IsBlock:Boolean;
//	public var MarkTag:int;
//	public var LastX:int;
//	public var LastY:int;
	public var HCost:int;
	public var GCost:int;
	public var FValue:int;
	public var State:int;
	public var Prev:ASMapCell;
	public var Next:ASMapCell;
//	public var btDir:int;
	public static const CSNONE:int = 0;
	public static const CSOPEN:int = 1;
	public static const CSCLOSE:int = 2;
	
	function ASMapCell()
	{
	}
}