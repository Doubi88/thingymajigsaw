extends MachineObject

class_name Trampoline

func setIsActive(value: bool):
	.setIsActive(value)
	if (value):
		get_node("Mat1").mode = RigidBody2D.MODE_RIGID
		get_node("Mat2").mode = RigidBody2D.MODE_RIGID
		get_node("Mat3").mode = RigidBody2D.MODE_RIGID
		get_node("Mat4").mode = RigidBody2D.MODE_RIGID
		get_node("Mat5").mode = RigidBody2D.MODE_RIGID
		get_node("Mat6").mode = RigidBody2D.MODE_RIGID
		get_node("Mat7").mode = RigidBody2D.MODE_RIGID
		get_node("Mat8").mode = RigidBody2D.MODE_RIGID
		get_node("Mat9").mode = RigidBody2D.MODE_RIGID
		get_node("Mat10").mode = RigidBody2D.MODE_RIGID
		get_node("Mat11").mode = RigidBody2D.MODE_RIGID
		get_node("Mat12").mode = RigidBody2D.MODE_RIGID
		get_node("Mat13").mode = RigidBody2D.MODE_RIGID
	else:
		get_node("Mat1").mode = RigidBody2D.MODE_STATIC
		get_node("Mat2").mode = RigidBody2D.MODE_STATIC
		get_node("Mat3").mode = RigidBody2D.MODE_STATIC
		get_node("Mat4").mode = RigidBody2D.MODE_STATIC
		get_node("Mat5").mode = RigidBody2D.MODE_STATIC
		get_node("Mat6").mode = RigidBody2D.MODE_STATIC
		get_node("Mat7").mode = RigidBody2D.MODE_STATIC
		get_node("Mat8").mode = RigidBody2D.MODE_STATIC
		get_node("Mat9").mode = RigidBody2D.MODE_STATIC
		get_node("Mat10").mode = RigidBody2D.MODE_STATIC
		get_node("Mat11").mode = RigidBody2D.MODE_STATIC
		get_node("Mat12").mode = RigidBody2D.MODE_STATIC
		get_node("Mat13").mode = RigidBody2D.MODE_STATIC
