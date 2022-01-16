class_name SEvent

const DEFAULT_LOCALE = "en_US"

var raw_data = {}
var name : String setget ,_get_name
var message : String setget ,_get_message
var portrait : Texture setget ,_get_portrait
var choices : Array setget ,_get_choices

func _init(data : Dictionary):
	raw_data = data

func get_locale(property, locale = TranslationServer.get_locale()) -> String:
	if locale in raw_data[property]:
		return raw_data[property][locale]
	elif DEFAULT_LOCALE in raw_data[property]:
		return raw_data[property][DEFAULT_LOCALE]

	push_error("%s property does not exist with translations %s and %s"
	 % [property, locale, DEFAULT_LOCALE])
	return "INVALID"

func _get_choices() -> Array:
	var data = []
	if "choices" in raw_data:
		for choice in raw_data["choices"]:
			var choice_obj = SChoice.new(choice)
			data.append(choice_obj)
	return data

func _get_name() -> String:
	return get_locale("name")

func _get_message() -> String:
	return get_locale("message")

func _get_portrait() -> Texture:
	if raw_data.get("portrait","") != "":
		return load(raw_data["portrait"]) as Texture
	return null
