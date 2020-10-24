extends Node2D

class_name Rope

var point1 = Vector2(100, 50)
var point2 = Vector2(141, 50)

var ropeObjects = []
export var chainElemWidth = 15
export(String, FILE, "*.tscn") var objectSceneName = "RopeObject.tscn"

var objectScene: Resource

func _ready() -> void:
	objectScene = preload("RopeObject.tscn")
	var currentPos = point1
	var currentIndex = 0
	var step = (point2 - point1).normalized() * chainElemWidth
	while (currentPos.x - point1.x < point2.x - point1.x || currentPos.y - point1.y < point2.y - point1.y):
		var chainObj = objectScene.instance()
		add_child(chainObj)
		chainObj.global_position = currentPos
		
		ropeObjects.append(chainObj)
		
		if (currentIndex > 0):
			var pinJoint = PinJoint2D.new()
			add_child(pinJoint)
	#		pinJoint.bias = 0
	#		pinJoint.softness = 0
			pinJoint.disable_collision = true
			pinJoint.global_position = currentPos + step
			pinJoint.node_a = ropeObjects[currentIndex - 1].get_path()
			pinJoint.node_b = chainObj.get_path()
#		else:
#			chainObj.mode = RigidBody2D.MODE_STATIC
		currentPos += step
		currentIndex += 1
	
	
