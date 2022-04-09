extends VBoxContainer

var current_row: int = 1
var total_rows: int = DATA.get_answer_length()

func _input(event: InputEvent):
	var row_node: Node = get_node("Row" + str(current_row))
	if (event.as_text() == "Enter") and row_node.is_row_full():
		if current_row == total_rows:
			#Fancy colour stuff
			#Finish game
			pass
		
		elif current_row < total_rows:
			#Fancy colour stuff
			
			#Move on to next row & initalise
			current_row += 1
			row_node = get_node("Row" + str(current_row))
			row_node.initialise()
		

