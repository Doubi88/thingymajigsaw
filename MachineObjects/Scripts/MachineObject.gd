extends RigidBody2D

class_name MachineObject

export var displayName = ""

var isActive = false
var isDragging = false
var isRotating = false
var rotationStartAngle: float

var reset = false
var startPos: Vector2
var startRotation = 0

var isInDropArea = false
var collisions = 0
export var isStatic = false

func _physics_process(delta: float) -> void:
	if (!isActive):
		mode = MODE_STATIC
		var rotateButton = get_node("RotateButton")
		if (rotateButton != null):
			rotateButton.visible = true
		
		if (reset):
			print(startRotation - global_transform.get_rotation())
			global_transform = global_transform.rotated(startRotation - global_transform.get_rotation())
			global_transform.origin = startPos
			
			reset = false
		if !isRotating:
			if  Input.is_mouse_button_pressed(BUTTON_LEFT) && (GlobalVars.editingObject == null || GlobalVars.editingObject == self):
				var spriteRect = (get_node("Sprite") as Sprite).get_rect()
				spriteRect.position += global_position
				var mousePos = get_global_mouse_position()
				if spriteRect.has_point(mousePos):
					isDragging = true
					GlobalVars.editingObject = self
			else:
				if GlobalVars.editingObject == self:
					GlobalVars.editingObject = null
				isDragging = false
			
			
		startPos = global_transform.origin
		startRotation = global_transform.get_rotation()
		
		if isPositionValid():
			get_node("RedOverlay").visible = false
		else:
			get_node("RedOverlay").visible = true
	else:
		var rotateButton = get_node("RotateButton")
		if (rotateButton != null):
			rotateButton.visible = false
		if !isStatic:
			mode = MODE_RIGID

	if isRotating:
		var rotationAngle = global_position.angle_to_point(get_global_mouse_position()) - rotationStartAngle
		print("rotationAngle ", rotationAngle)
		rotate(rotationAngle)
		rotationStartAngle = rotation
			
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


func _on_RotateButton_button_down() -> void:
	if GlobalVars.editingObject == null:
		GlobalVars.editingObject = self
		isRotating = true
		rotationStartAngle = global_position.angle_to_point(get_global_mouse_position())
		print("rotationStartAngle ", rotationStartAngle)


func _on_RotateButton_button_up() -> void:
	if GlobalVars.editingObject == self:
		GlobalVars.editingObject = null
		isRotating = false
	
