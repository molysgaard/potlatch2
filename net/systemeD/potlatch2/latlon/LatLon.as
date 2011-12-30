package net.systemeD.potlatch2.latlon {

    import net.systemeD.halcyon.*;
    import net.systemeD.halcyon.connection.*;
    import net.systemeD.potlatch2.*;
    import mx.managers.PopUpManager;

    import flash.events.*;
    import flash.geom.*;
    import flash.display.DisplayObject;
    import flash.ui.Keyboard;
    import net.systemeD.potlatch2.EditController;
    import net.systemeD.potlatch2.controller.*;
    import net.systemeD.halcyon.connection.*;
    import net.systemeD.halcyon.connection.actions.*;
    import net.systemeD.halcyon.MapPaint;

    public class LatLon {
        public function createNodes(cords:Object, layer:MapPaint):Array {
            var action:CompositeUndoableAction = new CompositeUndoableAction("Create nodes");
            var nodes:Array = [];
            for (var i:Number=0; i < cords.length; i++) {
                var curNode = layer.connection.createNode({}, cords[i].lat, cords[i].lon, action.push);
                nodes.push(curNode);
            }
            MainUndoStack.getGlobalStack().addAction(action);
            for (var i:Number=0; i < nodes.length; i++){
                layer.connection.registerPOI(nodes[i]);
            }
            return nodes;
        }

        public function createWay(cords, layer:MapPaint):Way {
            var undo:CompositeUndoableAction = new CompositeUndoableAction("Create way");
            var nodes = [];
            for (var i:Number=0; i < cords.length; i++){
                var curNode = layer.connection.createNode({}, cords[i].lat, cords[i].lon, undo.push);
                nodes.push(curNode);
            }
            var way:Way = layer.connection.createWay({}, nodes, undo.push);
            MainUndoStack.getGlobalStack().addAction(undo);
            layer.createWayUI(way);
            return way;
        }

        public function createArea(cords, layer:MapPaint):Way {
            var undo:CompositeUndoableAction = new CompositeUndoableAction("Create area");
            var nodes = [];
            for (var i:Number=0; i < cords.length; i++){
                var curNode = layer.connection.createNode({}, cords[i].lat, cords[i].lon, undo.push);
                nodes.push(curNode);
            }
            nodes.push(nodes[0]);
            var way:Way = layer.connection.createWay({}, nodes, undo.push);
            MainUndoStack.getGlobalStack().addAction(undo);
            layer.createWayUI(way);
            return way;
        }

        public function parseCords(cords):Object {
            var lines = cords.split("\n");
            cords=[];
            for (var i:Number=0; i < lines.length; i++){
                var lat, lon = lines[i].split(",");
                cords.push({lat:parseFloat(lat), lon:parseFloat(lon)});
            }
            return cords;
        }
    }
}
