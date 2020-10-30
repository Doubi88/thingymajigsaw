extends RigidBody2D

class_name MachineObject

export var displayName = ""

var isActive = false setget setIsActive, getIsActive
var isDragging = false
var isRotating = false
var rotationStartAngle: float

var reset = false
var startPos: Vector2
var startRotation = 0

var isInDropArea = false
var collisions = 0
export var isStatic = false

var explosionForces = Vector2.ZERO

func getIsActive() -> bool:
	return isActive
	
func setIsActive(value: bool):
	isActive = value
	
	
func _physics_process(delta: float) -> void:
	if (!isActive):
		mode = MODE_STATIC
		var rotateButton = get_node("RotateButton")
		if (rotateButton != null):
			rotateButton.visible = true
		
		if (reset):
			global_transform = global_transform.rotated(startRotation - global_transform.get_rotation())
			global_transform.origin = startPos
			
			reset = false
		if !isRotating:
			if  Input.is_mouse_button_pressed(BUTTON_LEFT) && (GlobalVars.editingObject == null || GlobalVars.editingObject == self):
				var rect: Rect2
				var dragArea: Area2D = get_node("DragArea")
				if (dragArea == null):
					rect = get_node("Sprite").get_rect()
					rect.position += global_position
				else:
					var dragAreaShape: CollisionShape2D = dragArea.get_node("CollisionShape2D")
					var extents: Vector2 = dragAreaShape.shape.extents
					rect.size = extents * 2
					rect.position = dragArea.global_position - extents
				
				var mousePos = get_global_mouse_position()
				if rect.has_point(mousePos):
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
		rotate(rotationAngle)
		rotationStartAngle = rotation
			
	if isDragging:
		global_transform.origin = get_global_mouse_position()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	applied_force = Vector2.ZERO
	state.apply_central_impulse(explosionForces)
	explosionForces = Vector2.ZERO
	
func isPositionValid() -> bool:
	return isInDropArea && collisions == 0

func _on_CheckArea_area_entered(area: Area2D) -> void:
	if area != get_node("DragArea") && area.get_parent().get_class() == get_class():
		collisions += 1


func _on_CheckArea_area_exited(area: Area2D) -> void:
	if area != get_node("DragArea") && area.get_parent().get_class() == get_class():
		collisions -= 1


func _on_RotateButton_button_down() -> void:
	if GlobalVars.editingObject == null:
		GlobalVars.editingObject = self
		isRotating = true
		rotationStartAngle = global_position.angle_to_point(get_global_mouse_position())


func _on_RotateButton_button_up() -> void:
	if GlobalVars.editingObject == self:
		GlobalVars.editingObject = null
		isRotating = false
	
func addExplosionImpact(explosionCenterGlobal: Vector2, forceAtCenter: float):
	var distanceXY = global_position - explosionCenterGlobal
	var force = forceAtCenter / distanceXY.length()
	var direction = distanceXY.normalized()
	explosionForces = Vector2(direction.x * force, direction.y * force)
