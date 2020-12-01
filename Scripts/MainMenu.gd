extends CenterContainer

class_name MainMenu



func _on_ExitButton_pressed():
	get_tree().finish()


func _on_PuzzlesMenuButton_pressed():
	var puzzlesScene = preload("res://Scenes/PuzzlesMenu.tscn").instance()
	puzzlesScene.puzzlesFolderName = "res://levels/"
	get_tree().change_scene_to(puzzlesScene)
	puzzlesScene.loadPuzzles()
