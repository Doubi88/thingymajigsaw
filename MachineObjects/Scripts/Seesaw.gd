extends MachineObject

class_name Seesaw

var boardRotation = 0
var boardPosition = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var board = get_node("SeesawBoard")
	if !isActive && reset:
		board.mode = RigidBody2D.MODE_STATIC
		board.global_transform = board.global_transform.rotated(boardRotation - board.global_transform.get_rotation())
		board.global_transform.origin = boardPosition
		
	._physics_process(delta)

	if !isActive:
		board.mode = RigidBody2D.MODE_STATIC
		boardRotation = board.global_transform.get_rotation()
		boardPosition = board.global_transform.origin
	else:
		get_node("SeesawBoard").mode = RigidBody2D.MODE_RIGID

func rotateWithMouse():
	var board = get_node("SeesawBoard")
	var rotationAngle = board.global_position.angle_to_point(get_global_mouse_position()) - rotationStartAngle
	board.rotate(rotationAngle)
	rotationStartAngle = board.rotation
