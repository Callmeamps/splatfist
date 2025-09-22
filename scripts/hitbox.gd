# FILE: scripts/hitbox.gd (Refactored for Manager System)
extends Area2D

# This variable will be set by the attack state that spawns the hitbox.
var damage: int = 0

# Ensure this signal is connected to this function in the Godot Editor's Node tab.
func _on_body_entered(body: Node2D):
	# We check if the body we hit is a player and is not the person who spawned this hitbox.
	if body != owner and body.is_in_group("Player"): # Using groups is a robust way to identify players.
		
		# Report the successful hit to the global CombatManager.
		# The CombatManager will now handle all the rules and consequences.
		CombatManager.process_hit(self, body)
		
		# Deactivate the hitbox's collision shape to prevent it from hitting the same
		# target multiple times during a single attack animation (a multi-hit).
		get_node("CollisionShape2D").set_deferred("disabled", true)
