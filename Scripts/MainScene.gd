extends Control

func _ready():
	
	$BackgroundColour.rect_position = rect_position
	$BackgroundColour.rect_size = rect_size
	
	$WordGrid.rect_position.x = (rect_size.x / 2) - ($WordGrid.rect_size.x / 2)
	$WordGrid.rect_position.y = (rect_size.y / 2) - ($WordGrid.rect_size.y / 2)
	
	
