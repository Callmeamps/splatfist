# FILE: scripts/managers/UIManager.gd
# This script is a singleton (Autoload). Its sole responsibility is to manage
# the game's User Interface. It listens for signals from other managers and
# updates the visual elements (health bars, timers, etc.) accordingly.
extends Node

# The _ready function is called when this singleton is loaded at the start of the game.
func _ready():
	# Here, we subscribe to the CombatManager's signal. We are telling the UIManager:
	# "Whenever the CombatManager emits the 'player_stats_changed' signal,
	# you will call your own 'on_player_stats_changed' function."
	CombatManager.player_stats_changed.connect(on_player_stats_changed)

# This function is the "listener" or "callback". It runs automatically whenever the
# signal it's connected to is emitted. It receives the player node that was affected.
func on_player_stats_changed(player):
	# For now, we are just printing the updated data to the console to confirm it works.
	# In the future, this is where the actual UI update logic will go.
	# For example: get_node("Player1_HealthBar").value = player.character_data.vitality
	print("UIManager: Received stats update for " + player.character_name)
	print(" - Vitality: " + str(player.character_data.vitality))
	print(" - Moya: " + str(player.character_data.moya))
