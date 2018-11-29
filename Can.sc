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

	*getPlayer {|player, canon, instruments|
		^if(player != nil,
			{player.(canon, instruments)},
			{this.pPlayer(canon, instruments)}
		)
	}
}
