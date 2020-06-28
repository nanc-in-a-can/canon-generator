Canon {
	var <canon, <data, <>player;

	*new { | canon, data, player|
        ^super.newCopyArgs(canon, data, player);
    }

	rebuildPlayer {
		this.player = Can.getPlayer(data.symbol, data.player, canon, data.instruments, data.repeat, data.osc, data.meta);
	}

	play {
		// if the player is not playing, attempt to rebuild the player, just to make sure that the canon plays with a new version, in case the def name on a Pdef or Tdef is being overwritten
		if(player.respondsTo('isPlaying'),
			{if(player.isPlaying.not, {this.rebuildPlayer})}
		);
		player.play;
	}

	stop {
		player.stop;
	}

	pause {
		player.pause;
	}

	resume {
		player.resume;
	}
}
