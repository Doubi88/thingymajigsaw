extends Resource

class_name LevelParser

func parse(fileName: String, itemList: AvailableObjectsList, machineObjectsParent: Node):
	var text = loadTextFile(fileName)
	var jsonResult = JSON.parse(text)
	if (jsonResult.error == OK):
		if (typeof(jsonResult.result) == TYPE_DICTIONARY):
			var listItems: Array = jsonResult.result.itemList;
			for listItem in listItems:
				var sceneName = listItem.name
				var objectScene = load("res://MachineObjects/" + sceneName + ".tscn")
				if (objectScene == null):
					print("Could not find MachineObject named ", sceneName);
				else:
					var machineObject : MachineObject = objectScene.instance()
					var count = listItem.amount as int
					itemList.addListItem(machineObject, count)
			
			var placedItems: Array = jsonResult.result.placedItems

			for placedItem in placedItems:
				var sceneName = placedItem.name
				var objectScene = load("res://MachineObjects/" + sceneName + ".tscn")
				if (objectScene == null):
					print("Could not find MachineObject named ", sceneName);
				else:
					var machineObject : MachineObject = objectScene.instance()
					var location = Vector2(placedItem.location.x, placedItem.location.y)
					var rotation = placedItem.rotation
					
					machineObjectsParent.add_child(machineObject, true)
					machineObject.isActive = false
					machineObject.isDragging = false
					machineObject.global_position = location
					machineObject.rotation = rotation * PI / 180
			
		else:
			OS.alert("Error parsing level file")
	else:
		OS.alert("Error parsing level file: " + jsonResult.error_string)

func save(fileName: String, itemList: AvailableObjectsList, machineObjectsParent: Node):
	var jsonObject = {};
	jsonObject.itemList = []
	for i in range(0, itemList.machineObjects.size()):
		var item: MachineObject = itemList.machineObjects[i]
		var itemToAdd = {}
		var itemName = item.filename.substr(item.filename.find_last("/") + 1)
		itemName = itemName.substr(0, itemName.find_last("."))
		
		itemToAdd.name = itemName
		itemToAdd.amount = itemList.objectCounts[i]
		jsonObject.itemList.append(itemToAdd)

	jsonObject.placedItems = []
	var children = machineObjectsParent.get_children()
	for i in range(0, children.size()):
		var item: MachineObject = children[i]
		var placedItem = {}
		var itemName = item.filename.substr(item.filename.find_last("/") + 1)
		itemName = itemName.substr(0, itemName.find_last("."))
		
		placedItem.name = itemName
		placedItem.location = {}
		placedItem.location.x = item.global_position.x
		placedItem.location.y = item.global_position.y
		placedItem.rotation = item.rotation * 180 / PI
		jsonObject.placedItems.append(placedItem)
	
	var jsonText = JSON.print(jsonObject)
	saveTextFile(jsonText, fileName)
	

func loadTextFile(path):
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

func saveTextFile(text, path):
	var f = File.new()
	var err = f.open(path, File.WRITE)
	if err != OK:
		printerr("Could not write file, error code ", err)
		return
	f.store_string(text)
	f.close()
