package net.systemeD.potlatch2.controller {
	import flash.events.*;
	import flash.display.*;
	import net.systemeD.potlatch2.EditController;
	import net.systemeD.halcyon.connection.*;
    import net.systemeD.halcyon.connection.actions.*;
	import net.systemeD.halcyon.Map;
	import net.systemeD.halcyon.MapPaint;

	public class NoSelection extends ControllerState {

		public function NoSelection() {
		}

		override public function isSelectionState():Boolean {
			return false;
		}
		
		override public function processMouseEvent(event:MouseEvent, entity:Entity):ControllerState {
			var cs:ControllerState = sharedMouseEvents(event, entity);
			if (cs) return cs;

			var paint:MapPaint = getMapPaint(DisplayObject(event.target));
			var focus:Entity = getTopLevelFocusEntity(entity);

			if (event.type==MouseEvent.MOUSE_UP && (focus==null || (paint && paint.isBackground)) && map.dragstate!=map.DRAGGING && map.dragstate!=map.SWALLOW_MOUSEUP) {
				map.dragstate=map.NOT_DRAGGING;
				// ** FIXME: BeginWayAction ought to be a discrete class
				var undo:CompositeUndoableAction = new BeginWayAction();
				var conn:Connection = layer.connection;
				var startNode:Node = conn.createNode(
					{}, 
					controller.map.coord2lat(event.localY),
					controller.map.coord2lon(event.localX), undo.push);
				var way:Way = conn.createWay({}, [startNode], undo.push);
				MainUndoStack.getGlobalStack().addAction(undo);
				return new DrawWay(way, true, false);
			}
			return this;
		}
		
		override public function processKeyboardEvent(event:KeyboardEvent):ControllerState {
			var cs:ControllerState = sharedKeyboardEvents(event);
			return cs ? cs : this;
		}
		
        override public function enterState():void {
			controller.map.mouseUpHandler();
        }
        override public function exitState(newState:ControllerState):void {
        }
		override public function toString():String {
			return "NoSelection";
		}

	}
}
