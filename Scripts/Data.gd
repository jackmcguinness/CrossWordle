extends Node

var guess_n : int = 0 #gets incremented for each guess
var answer : String = "godot"


func get_answer_length():
	#answer.length() used a lot throughout different scripts, so getter written 
	#in case the variable name needs to change for some reason.
	return answer.length()
