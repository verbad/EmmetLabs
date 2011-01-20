package com.emmet.model {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.Dictionary;

  public class Person extends GraphElement {
    private var _id:int;
    private var _type:String;
    private var _name:String;
    private var _directedRelationships:Array;
    private var _tags:Array;
    private var _primaryPhotoUrl:String;
    private var _param:String;
    private var _stub:Boolean;

    private static var __plurals:Object = { person:"people", entity:"entities"}

    private static var __nodeIdToNode:Dictionary = new Dictionary();

    public static function byNodeId(nodeID:String):Person {
      return __nodeIdToNode[nodeID];
    }

    protected static function updateNodeId(nodeID:String, node:Person):Person {
      __nodeIdToNode[nodeID] = node;
      return node;
    }

    public static function fromXml(personXml:XML):Person {
      var id:int = personXml.@id;
      var type:String = personXml.name().localName
      var name:String = personXml.name;
      var primaryPhotoUrl:String = personXml.primary_photo_url;
      var param:String = personXml.param;
      // Needs to be coerced into a string first
      // var stub:Boolean = personXml.@stub.toLowerCase == "true";
      var stubAttr:String = personXml.@stub
      var stub:Boolean = stubAttr.toLowerCase() == "true";

      var nodeId:String = type + "_" + id;
      var old:Person = byNodeId(nodeId)

      if ( old == null) {
        updateNodeId(nodeId, new Person(id, name, primaryPhotoUrl, param, type));
        var created:Person = byNodeId(nodeId);
        created.stub = stub;
        return created;
      }
      // These SHOULD all be the same, but reset them just in case
      old._id = id;
      old._type = type;
      old._name = name;
      old._primaryPhotoUrl = primaryPhotoUrl;
      old._param = param;

      if (old.stub && !stub) {
        old._stub = stub;
        old.fireLoadedEvents();
      }

      return old;
    }

    private static function pluralFor(singular:String):String {
      var plural:String = __plurals[singular];
      if (plural == "") {
        plural = singular + "s";
      }
      return plural;
    }

    public function Person(id:int, name:String, primaryPhotoUrl:String, param:String, type:String = "person") {
      _id = id;
      _name = name;
      _type = type;
      _primaryPhotoUrl = primaryPhotoUrl;
      _param = param;
      _directedRelationships = [];
      _tags = [];
    }

    public function get id():int { return _id; }
    public function get name():String { return _name; }
    public function get type():String { return _type; }
    public function get node_id():String { return _type + "_" + _id; }
    public function get directedRelationships():Array { return _directedRelationships; }
    public function set directedRelationships(rels:Array):void { _directedRelationships = rels; }
    public function get tags():Array { return _tags; }
    public function get primaryPhotoUrl():String { return _primaryPhotoUrl; }
    public function get networkUrl():String { return "/network/" + param; }
    public function get profileUrl():String { return "/view/" + pluralFor(_type) + "/" + param; }
    public function get addConnectionUrl():String { return "/" + pluralFor(_type) + "/" + param + "/connections"; }
    public function get param():String { return _param; }
    public function get stub():Boolean { return _stub }
    public function set stub(s:Boolean):void { _stub = s }

    public function addDirectedRelationship(directedRelationship:DirectedRelationship):void {
      if (!hasRelationshipTo(directedRelationship.to)) {
        _directedRelationships.push(directedRelationship);
      }
    }

    private function hasRelationshipTo(person:Person):Boolean {
      for (var i:String in directedRelationships) {
        if (directedRelationships[i].to == person) {
          return true;
        }
      }
      return false;
    }

    public function findDirectedRelationshipTo(person:Person):DirectedRelationship {
      for (var i:String in directedRelationships) {
        if (directedRelationships[i].to == person) {
          return directedRelationships[i];
        }
      }
      throw "Couldn't find directed relationship to " + person.name;
    }

    public override function toString():String {
      return name;
    }

    public function get descendantCount():Number {
      return 1;
    }
  }
}