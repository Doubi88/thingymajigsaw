extends RigidBody2D

class_name MachineObject

export var displayName = ""

var isActive = false
var isDragging = false
export var isStatic = false

func _process(delta: float) -> void:
	#print("static ", isStatic, " isActive ", isActive)
	if (isStatic || !isActive):
		mode = MODE_STATIC
		var mousePos = get_global_mouse_position()
		var collShape = get_node("CollisionShape2D")
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			var spriteRect = (get_node("Sprite") as Sprite).get_rect()
			spriteRect.position += global_position
			if spriteRect.has_point(mousePos):
				isDragging = true
		else:
			isDragging = false
	else:
		mode = MODE_RIGID

func _physics_process(delta: float) -> void:
	if isDragging:
		global_transform.origin = get_global_mouse_position()

