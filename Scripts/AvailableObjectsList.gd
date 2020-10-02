extends Node

class_name AvailableObjectsList

export(String, FILE, "*.lvl") var levelFileName = ""

var machineObjects = []
var objectCounts = []
var selectedItem: MachineObject
var running = false

func _ready() -> void:
	readLevelFile()
	
	var itemList = get_node("VBoxContainer/ItemList")
	
	for i in range(machineObjects.size()):
		itemList.add_item(str(objectCounts[i]), machineObjects[i].get_node("Sprite").texture, true)

func _process(delta: float) -> void:
	if !running:
		var itemList = get_node("VBoxContainer/ItemList")
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if selectedItem == null:
				var pos = itemList.get_local_mouse_position()
				var item = itemList.get_item_at_position(pos, true)
				if (item >= 0):
					selectedItem = spawnItemAtCursor(item)
					selectedItem.isDragging = true
		else:
			if (selectedItem != null):
				selectedItem.isDragging = false
				selectedItem = null
				


func spawnItemAtCursor(itemIndex: int) -> MachineObject:
	var newItem = machineObjects[itemIndex].duplicate() as MachineObject
	var itemList = get_node("VBoxContainer/ItemList")
	if (objectCounts[itemIndex] == 1):
		machineObjects.remove(itemIndex)
		objectCounts.remove(itemIndex)
		itemList.remove_item(itemIndex)
	else:
		objectCounts[itemIndex] -= 1
		itemList.set_item_text(itemIndex, str(objectCounts[itemIndex]))
	
	newItem.isActive = false
	var machineObjectsNode = get_parent().owner
	print(machineObjectsNode.name)
	machineObjectsNode = machineObjectsNode.get_node("MachineObjects")
	machineObjectsNode.add_child(newItem, true)
	
	return newItem
	
func readLevelFile():
	var itemList = get_node("VBoxContainer/ItemList")
	var text = load_text_file(levelFileName)
	if text != null:
		var lines = text.split("\n", false)
		for line in lines:
			var cols = line.split(" ")
			var objectScene = load("res://MachineObjects/" + cols[0] + ".tscn")
			var machineObject : MachineObject = objectScene.instance()
			
			var count = cols[1].to_int()
			machineObjects.append(machineObject)
			objectCounts.append(count)
	else:
		get_tree().quit()

func load_text_file(path):
	var f = File.new()
	var err = f.open(path, File.READ)
	if err != OK:
		var error = "Could not open file \"" + path + "\""
		if err == ERR_FILE_NOT_FOUND:
			error += ", File not found"
		else:
			error += ", error code " + str(err)
		OS.alert(error, "Error opening level file")
		return null
	var text = f.get_as_text()
	f.close()
	return text

func save_text_file(text, path):
	var f = File.new()
	var err = f.open(path, File.WRITE)
	if err != OK:
		printerr("Could not write file, error code ", err)
		return
	f.store_string(text)
	f.close()

func _on_Play_pressed() -> void:
	var objectsNode = owner.get_node("MachineObjects")
	var items = objectsNode.get_children()
	for item in items:
		item.isActive = true
		print("isActive of ", item.displayName, " = ", item.isActive)
	running = true
	(get_node("VBoxContainer/Buttons/Play").icon as AnimatedTexture).current_frame = 1
