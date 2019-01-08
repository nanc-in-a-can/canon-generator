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

	*getPlayer {|symbol, player, canon, instruments, repeat, osc|
		^if(player != nil,
			{player.(symbol, canon, instruments, repeat, osc)},
			{this.pPlayer(symbol, canon, instruments, repeat, osc)}
		)
	}
}
