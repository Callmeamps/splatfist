# FILE: scripts/managers/CombatManager.gd
# This script is a singleton (Autoload). It acts as the central authority for all
# combat-related logic. Instead of players calculating their own damage and meter gain,
# they report events to this manager, which then applies the game's rules.
extends Node


# It announces that a player's stats have changed and passes a reference
# to the player node that was affected.
signal player_stats_changed(player)

var attacker

# This is the main function that processes a combat interaction.
# It is called by a Hitbox when it collides with a player.
func process_hit(hitbox, victim):
	# The 'owner' of the hitbox is the player who spawned it (the attacker).
	attacker = hitbox.owner
	
	# A safety check to prevent the game from crashing if the hitbox or victim is invalid.
	if not attacker or not victim:
		print("CombatManager: ERROR - Hit processed with invalid attacker or victim.")
		return
		
	# The manager ASKS the victim for its current state. This is good decoupling,
	# as the manager doesn't need to know *how* the player blocks, only *if* they are.
	var was_blocked = victim.is_blocking()
	
	# Apply the game rules based on whether the attack was blocked.
	if was_blocked:
		# Rule: Gain 8 Moya on a successful block.
		victim.gain_moya(8)
	else:
		# Rule: If not blocked, take damage...
		victim.take_damage(hitbox.damage)
		# ...and gain 12 Moya for taking a hit.
		victim.gain_moya(12)
	
	# Rule: The attacker always gains 20 Moya for landing a hit (blocked or not).
	attacker.gain_moya(20)
	
	# After applying the rules, we must notify the rest of the game.
	# We emit the signal for both the victim and the attacker, because both of their stats changed.
	emit_signal("player_stats_changed", victim)
	emit_signal("player_stats_changed", attacker)
	
func process_grab(grabbox, victim):
	attacker = grabbox.owner
	
	if not attacker or not victim:
		push_error("CombatManager: ERROR - Grab processed with invalid attacker or victim.")
		return

	# Rule: Grabs only succeed against a blocking opponent (as per our current design).
	# We can add more complex rules here later (e.g., grabs fail against attacking opponents).
	if not victim.is_blocking():
		# The grab whiffed. We can add a sound effect or visual effect here later.
		print("Grab whiffed against non-blocking player.")
		return

	# If the rules are met, the grab is successful.
	# The manager tells the victim's script what to do.
	victim.get_grabbed_by(attacker)
	
	# The manager also tells the victim to take the appropriate grab damage.
	victim.take_damage(attacker.character_data.grab_dmg)
	
	# Announce that stats have changed for both players.
	emit_signal("player_stats_changed", victim)
	emit_signal("player_stats_changed", attacker)
