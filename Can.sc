Can {
	classvar <defaultInstruments;

	*initClass {|self|
		defaultInstruments = [\pianola];
	}

	*getInstruments {|data|
		^if(data.instruments != nil,
			{data.instruments},
			{this.defaultInstruments}
		)
	}

	*getPlayer {|data, canon, instruments|
		^if(data.player != nil,
			{data.player(canon, instruments)},
			{this.pPlayer(canon, instruments)}
		)
	}
}
