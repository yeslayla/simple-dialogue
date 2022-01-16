class_name SChoice

export(Dictionary) var raw_data = {}
export(Array) var event_data = []

var SEVENT = load("res://addons/simple_dialogue/scripts/sevent.gd")

var events : Array setget ,_get_events
var choice : String setget ,_get_choice

func _init(data : Dictionary):
	raw_data = data

func _get_events() -> Array:
	var event_array = []
	if "events" in raw_data:
		for event in raw_data["events"]:
			var dialogue = SEVENT.new(event)
			event_array.append(dialogue)
	return event_array

func _get_choice() -> String:
	var locale = TranslationServer.get_locale()
	if locale in raw_data["choice"]:
		return raw_data["choice"][locale]
	elif SEVENT.DEFAULT_LOCALE in raw_data["choice"]:
		return raw_data["choice"][SEVENT.DEFAULT_LOCALE]
	
	push_error("Choice property does not exist with translation %s and %s"
	 % [locale, SEVENT.DEFAULT_LOCALE])
	return "INVALID"
