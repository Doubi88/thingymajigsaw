extends Button

class_name PuzzleButton

export(String, FILE, "*.lvl") var puzzleFilename: String setget setPuzzleFilename, getPuzzleFilename

func setPuzzleFilename(value: String) -> void:
	puzzleFilename = value
	updateButtonText();

func getPuzzleFilename() -> String:
	return puzzleFilename
	
func updateButtonText():
	if (puzzleFilename != null):
		var puzzleName = puzzleFilename.substr(puzzleFilename.find_last("/") + 1)
		puzzleName = puzzleName.substr(0, puzzleName.find_last("."))
		text = puzzleName
	else:
		text = "Not specified"
		
func _on_PuzzleButton_pressed():
	if (puzzleFilename == null):
		var uiSceneLoad = ResourceLoader.load("res://Scenes/DefaultUI.tscn")
		var uiScene = uiSceneLoad.instance()
		
		var hud: AvailableObjectsList = get_tree().current_scene.get_node("/DefaultUI/Background/HUD")
		hud.levelFileName = puzzleFilename
		get_tree().change_scene_to(uiScene)
