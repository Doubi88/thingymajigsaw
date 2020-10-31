extends MachineObject

class_name Dynamite

var inFireArea = false
var burning = false
var burnTime = 0
var exploded = false
var explosionDelta = 0

export var explodeTime = 10
export var explosionForce = 5000

func _physics_process(delta: float) -> void:
	if (isActive):
		if exploded:
			explosionDelta += delta
			if explosionDelta >= 1:
				visible = false
				collision_layer = 3
				collision_mask = 3
		if burning:
			get_node("Fire").visible = true
			burnTime += delta
			if burnTime >= explodeTime:
				explode()
		else:
			get_node("Fire").visible = false
			
	else:
		if (reset):
			burning = false
			burnTime = 0
			exploded = false
			explosionDelta = 0
			visible = true
			get_node("AnimatedSprite").frame = 0
			
			collision_layer = 1
			collision_mask = 1
			
			if inFireArea:
				burning = true
		get_node("Fire").visible = false
	._physics_process(delta)
	
func explode():
	var objectsParent = get_node("/root/DefaultUI/MachineObjects")
	exploded = true
	burning = false
	get_node("AnimatedSprite").frame = 1
	get_node("Fire").visible = false
	for obj in objectsParent.get_children():
		if (obj != self):
			(obj as MachineObject).addExplosionImpact(global_position, explosionForce)
			

func _on_FireArea_area_entered(area: Area2D) -> void:
	if area.name == "FireImpactArea" && area.get_parent().get_parent() != self:
		burning = true
		inFireArea = true

func _on_FireArea_area_exited(area: Area2D) -> void:
	if (area.name == "FireImpactArea"):
		if !isActive:
			burning = false
			burnTime = 0
			
		inFireArea = false
