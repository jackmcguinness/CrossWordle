extends VBoxContainer

### TODO:
### DONE! Map keyboard inputs to each key
# On input, update relevant letterbox/label.text
#
# Also map backspace
# If input, remove previous letter
#
# On 'Enter', submit word for comparison I guess??

var word : String = DATA.word

func _ready():
	if not is_word_five_letters(word):
		print("ERROR: WORD NOT 5 LETTERS")

func _process(delta):

	#check how many letters are in inputted word currently 
	#update n boxes for n letters in word 
	
	#input of 'Enter' can be dealt with in the input func
	
	pass

func is_word_five_letters(var word):
	if word.length() != 5: return false
	else: return true
