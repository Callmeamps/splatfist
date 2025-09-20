# FILE: scripts/Grabbox.gd
extends Area2D

# This signal will be sent when we successfully grab someone.
signal grab_successful(body)

func _on_body_entered(body):
	# We need to make sure we're not grabbing ourselves and that the body is an opponent.
	# For now, we'll just check that it's not the owner (the player who spawned it).
	if body != owner:
		print("Grab successful on: ", body.name)
		grab_successful.emit(body)
		# We delete the grabbox after it connects to prevent multiple hits.
		queue_free()
