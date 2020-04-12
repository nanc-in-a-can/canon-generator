Can {
	classvar <defaultInstruments;

	*initClass {|self|
		defaultInstruments = [\pianola];
	}

	*getInstruments {|instruments|
		^if(instruments != nil,
			{instruments},
			{this.defaultInstruments}
		)
	}

	*init {
		Can.registerDefaultSynthDefs;
		Can.defaultServerConfig;
	}

	*getPlayer {|symbol, player, canon, instruments, repeat, osc, meta|
		^if(player != nil,
			{player.(symbol, canon, instruments, repeat, osc, meta)},
			{this.pPlayer(symbol, canon, instruments, repeat, osc, meta)}
		)
	}

	// Can.dur :: Canon -> Float
	*dur {|canon| //duration in seconds
		^canon.canon[0].durs.sum
	}

	// Can.durm :: Canon -> Float
	*durm {|canon| // duration in minutes
		^Can.dur(canon)/60
	}
}
