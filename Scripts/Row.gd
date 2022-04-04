extends HBoxContainer

var word : String
var letter_to_update : int = 0
var guess

#on input: 
#	if NOT letter_to_update = length of word
#		if input is a letter:
#			change LetterBox/Letter to input letter
#			letter_to_update + 1
#			apend letter to guess string
#		
#		else if input is backspace:
#			remove previous LetterBox/Letter (make blank)
#			letter_to_update - 1
#			remove letter from guess string
#
#	else if letter_to_update = length of word
#		if input is Enter:
#			compare guess string with word


func _ready():
	
	
	
	pass

