# FILE: scripts/grabbox.gd (Refactored for Manager System)
extends Area2D

# Ensure this signal is connected to this function in the Godot Editor's Node tab.
func _on_body_entered(body: Node2D):
	# Check if we've collided with a player that isn't ourselves.
	if body != owner and body.is_in_group("Player"):
	
		# Report the grab attempt to the global CombatManager.
		# The CombatManager will decide if it was successful based on the rules.
		CombatManager.process_grab(self, body)
		
		# A grabbox should only ever connect once, so we delete it immediately after the report.
		queue_free()
