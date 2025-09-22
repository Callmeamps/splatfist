# FILE: scripts/managers/ResourceManager.gd
# This script is a singleton (Autoload), corrected for Godot 4.
# Its purpose is to load and provide all character data resources.
extends Node

const META_DATA_PATH = "res://data/character_meta/"
var meta_data_cache = {}

func _ready():
	print("ResourceManager: Loading character meta data...")
	
	var dir = DirAccess.open(META_DATA_PATH)
	
	# We check if the directory was opened successfully.
	if dir:
		# --- CORRECTED for Godot 4 ---
		# 'list_dir_begin()' is no longer needed. We can just loop directly.
		var file_name = dir.get_next()
		while file_name != "":
			# 'current_is_dir()' is now 'dir_exists(file_name)'.
			if not dir.dir_exists(file_name) and file_name.ends_with(".tres"):
				var path = META_DATA_PATH.path_join(file_name) # Using path_join is safer.
				var meta_data = load(path)
				
				# 'get_basename()' is now a property of the String class.
				var char_key = file_name.get_basename()
				meta_data_cache[char_key] = meta_data
				print(" - Loaded MetaData for " + char_key)
			
			file_name = dir.get_next()
	else:
		print("ResourceManager: ERROR - Could not open directory: " + META_DATA_PATH)

func get_character_meta_data(character_name: String) -> MetaData:
	if meta_data_cache.has(character_name):
		return meta_data_cache[character_name]
	
	# If not in cache, try to load it directly.
	# This handles cases where this function is called before _ready() completes.
	var path = META_DATA_PATH.path_join(character_name + ".tres")
	if ResourceLoader.exists(path):
		print("ResourceManager: WARNING - MetaData for '%s' was not pre-cached. Loading on demand." % character_name)
		var meta_data = load(path)
		meta_data_cache[character_name] = meta_data # Add to cache for next time
		return meta_data
	else:
		print("ResourceManager: ERROR - MetaData not found for: " + character_name)
		return null
