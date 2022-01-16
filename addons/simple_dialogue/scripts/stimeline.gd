class_name STimeline

export(String) var file_path = ""
export(Array) var events = []

var _event_stream = []
var _pos_lifo = []
var _event_lifo = []
var _pos : int = 0
var _yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()

func _init(path : String):
	var file : File = File.new()
	if !file.file_exists(path):
		push_error("Could not load timeline at path: %s" % path)
		return
	file_path = path
	file.open(path, File.READ)
	
	var raw_data = _yaml.parse(file.get_as_text())
	file.close()
	
	if not "apiVersion" in raw_data or raw_data["apiVersion"] != 1.0:
		push_error("'%s' is using an outdated timeline!" % file_path)
		return
	if not "kind" in raw_data or raw_data["kind"] != "timeline":
		push_error("'%s' is not a timeline!" % file_path)
		return
	if "events" in raw_data:
		for event in raw_data["events"]:
			var dialogue = SEvent.new(event)
			events.push_back(dialogue)
	else:
		push_warning("'%s' timeline does not have any events!" % file_path)
	
	_event_stream = events
	_pos = 0

func get_cursor() -> int:
	return _pos

func seek(new_pos : int) -> void:
	_pos = new_pos

func get_event(offset : int = 0) -> SEvent:
	if _pos + offset < len(_event_stream):
		return _event_stream[_pos + offset]
	return null

func read() -> SEvent:
	var event = get_event()
	if event == null and len(_event_lifo) > 0:
		_event_stream = _event_lifo.pop_back()
		_pos = _pos_lifo.pop_back()
		event = get_event()
	_pos += 1
	return event

func get_choices() -> Array:
	var choices = []
	var event = get_event(-1)
	if event:
		for choice in event.choices : choices.append(choice.choice)
	return choices

func is_choice() -> bool:
	return len(get_choices()) > 0

func make_choice(choice : int) -> void:
	var event = get_event(-1)
	if not event:
		push_error("Attempted to find choice at invalid event! Pos '%s' Event Stream: %s"
			% [_pos, _event_stream])
		return
	if choice > len(event.choices):
		push_error("Attempted to make an out of bounds choice! Timeline '%s': choice '%s' while expected size is '%s'"
			% [self.file_path, choice, len(event.choices)])
		return
	var choice_obj : SChoice = event.choices[choice]
	_event_lifo.push_back(_event_stream)
	_event_stream = choice_obj.events
	_pos_lifo.push_back(_pos)
	_pos = 0
