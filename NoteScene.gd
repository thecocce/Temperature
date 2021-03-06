extends Node

var counter = 0
var limit = 150
var end = false
var text_index = 0
var sound_played = 0

func cache_invalidation():
	randomize()
	var value = str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()]) + str(range(1,11)[randi()%range(1,11).size()])
	return value

func _ready():
	var dataurl = "https://coppolaemilio.com/Temperature/data.json?" + cache_invalidation()
	print('Requesting weather data: ' + dataurl)
	$HTTPRequest.request(dataurl,PoolStringArray(), false)
	
	
	$Hand/ShowUp.visible = false
	$Hand/Stay.visible = false
	$Hand/Stay/Label.visible = true
	$Hand/Stay/Label2.visible = false

func _process(delta):
	if end == false:
		counter += 1
	if counter > limit:
		counter = 0
		end = true
		$Hand/ShowUp.visible = true
		$Hand/ShowUp.play('default')

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_utf8())
	global.remote_data = json.result
	
	if global.unit == 'f':
		for val in global.remote_data:
			var celcius = global.remote_data[val]
			global.remote_data[val] = round(9.0/5.0 * celcius + 32)

func _on_ShowUp_animation_finished():
	if sound_played == 0:
		$Sound/Paper.play()
		sound_played = 1
	$Hand/ShowUp.visible = false
	$Hand/Stay.visible = true
	$Hand/Stay.play('default')

func _input(event):
	if $Hand/Stay.visible == true:
		if event.is_action_pressed("ui_accept"):
			if text_index == 0:
				$Sound/Paper.play()
				$Hand/Stay/Label.visible = false
				$Hand/Stay/Label2.visible = true
				text_index += 1
			elif text_index == 1:
				get_tree().change_scene("res://main.tscn")

