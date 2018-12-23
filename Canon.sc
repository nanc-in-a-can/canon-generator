Canon {
	var <canon, <data, <player;

	*new { | canon, data, player|
        ^super.newCopyArgs(canon, data, player)
    }

	play {
		player.play
	}

	stop {
		player.stop
	}

	pause {
		player.pause
	}

	resume {
		player.resume
	}
}