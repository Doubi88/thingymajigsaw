extends Control

class_name PuzzlesMenu

export(String, DIR) var puzzlesFolderName

func loadPuzzles():
	print("Puzzles menu ready")
	var files = getAllFilesInFolder(puzzlesFolderName, "*.lvl")
	
	var puzzleButtonScene = preload("res://Tools/PuzzleButton.tscn")
	var buttonsContainer = self
	for file in files:
		var button: PuzzleButton = puzzleButtonScene.instance()
		button.puzzleFilename = puzzlesFolderName + file
		button.updateButtonText()
		buttonsContainer.add_child(button)
		print("Added " + button.text + ": " + button.puzzleFilename)
	
func getAllFilesInFolder(folderName: String, filter: String) -> PoolStringArray:
	var dir: Directory = Directory.new()
	dir.open(folderName)
	
	var result = PoolStringArray()
	
	dir.list_dir_begin(true, true)
	var file = dir.get_next()
	while (file != ""):
		if (file.match(filter)):
			result.append(file)
		file = dir.get_next()
	
	dir.list_dir_end()
	return result
