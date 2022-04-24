extends Panel

var black  = Color(0.1, 0.1, 0.1, 1)
var yellow = Color(0.78, 0.66, 0.16, 1)
var green  = Color(0.3, 0.6, 0.18, 1)
var grey   = Color(0.3, 0.3, 0.3, 1)


func _ready():
	
	#Set ColorRect size equal to LetterBox size
	$Colour.rect_size = rect_size
	
	#Set default colour 
	set_colour_black()

func set_colour_black():
	$Colour.color = black

func set_colour_yellow():
	$Colour.color = yellow

func set_colour_green():
	$Colour.color = green

func set_colour_grey():
	$Colour.color = grey

func is_letterbox_green():
	if $Colour.color == green:
		return true
	else:
		return false
