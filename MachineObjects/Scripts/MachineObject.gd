extends RigidBody2D

class_name MachineObject

export var displayName = ""

var isActive = false
var isDragging = false
var reset = false
var startPos: Vector2
var startRotation = 0

var isInDropArea = false
var collisions = 0
export var isStatic = false

func _physics_process(delta: float) -> void:
	if (!isActive):
		mode = MODE_STATIC
		
		if (reset):
			print(startRotation - global_transform.get_rotation())
			global_transform = global_transform.rotated(startRotation - global_transform.get_rotation())
			global_transform.origin = startPos
			
			reset = false
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT) && (GlobalVars.draggingObject == null || GlobalVars.draggingObject == self):
			var spriteRect = (get_node("Sprite") as Sprite).get_rect()
			spriteRect.position += global_position
			var mousePos = get_global_mouse_position()
			if spriteRect.has_point(mousePos):
				isDragging = true
				GlobalVars.draggingObject = self
		else:
			if GlobalVars.draggingObject == self:
				GlobalVars.draggingObject = null
			isDragging = false
			
			
		startPos = global_transform.origin
		startRotation = global_transform.get_rotation()
		
		if isPositionValid():
			get_node("RedOverlay").visible = false
		else:
			get_node("RedOverlay").visible = true
	elif !isStatic:
		mode = MODE_RIGID

	if isDragging:
		global_transform.origin = get_global_mouse_position()

func isPositionValid() -> bool:
	return isInDropArea && collisions == 0

func _on_CheckArea_area_entered(area: Area2D) -> void:
	if area.get_parent().get_class() == get_class():
		collisions += 1


func _on_CheckArea_area_exited(area: Area2D) -> void:
	if area.get_parent().get_class() == get_class():
		collisions -= 1
