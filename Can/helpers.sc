+Can {
	*prGetAmp {|amps, i|
		^if(
			amps.isArray && amps.size > 0,
			{amps.wrapAt(i)},
			{1})
	}
	//melody :: ([Float], [Float], [Float]) -> [(dur, note, amp)]
	*melody {|durs, notes, amps = ([1])|
		^[durs.size, notes.size].minItem.collect({|i|
			(dur: durs[i], note: notes[i], amp: Can.prGetAmp(amps, i))
		})
	}
	//isomelody ::([Float], [Float], [Float], Int) -> [(dur, note, amp)]
	*isomelody {|durs, notes, amps = ([1]), len|
		var len_ = len ? max(durs.size, notes.size);
		^len_.collect({|i|
			(dur: durs.wrapAt(i), note: notes.wrapAt(i), amp: Can.prGetAmp(amps, i))
		});
	}

	//convvoices :: ([Float], [Float], [Float]) -> [(tempo, transp, amp)]
	*convoices { | tempos, transps, amps = ([1])|
		^[tempos.size, transps.size].minItem.collect({|i|
			(tempo: tempos[i], transp: transps[i], amp: Can.prGetAmp(amps, i))
		})
	}

	//divoices :: ([Float], [Float]) ->[(transp: Float, amp: Float)]
	*divoices { |transps, amps = ([1])|
		^transps.collect({|transp, i|
			(transp: transp, amp: Can.prGetAmp(amps, i))
		})
	}

	//divtempos :: ([Float], [Float], Boolean) ->[(tempo: Float, percentage: Float)]
	*divtempos { | tempos, percentageForTempo, normalize= true|
		var min = [tempos.size, percentageForTempo.size].minItem;

		var percentages = if(normalize, {percentageForTempo[0..min - 1].normalizeSum*100}, {percentageForTempo[0..min - 1]});

		^min.collect({|i|
			(tempo: tempos[i], percentage: percentages[i])
		});
	}

	//mergeCanons :: Canon -> Canon -> Canon
	*mergeCanons {|a, b|
		var canon = a.canon ++ b.canon;
		var player = this.getPlayer(a.data.player, canon, a.data.instruments);
		^Canon(
			canon: canon,
			player: player,
			data: (
				voices: a.data.voices ++ b.data.voices,
				cp: [a.data.cp, b.data.cp].minItem,//for now we keep only the first cp, for the visualizer purposes, it does not affect the cp in the canons that will sound
				//for now we forgoe the "melody" key in the data array
			)
		)
	}
}
