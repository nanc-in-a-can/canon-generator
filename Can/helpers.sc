+Can {
	//melody ::[Float] -> [Float] -> [(dur, note)]
	*melody {|durs, notes|
		^[durs.size, notes.size].minItem.collect({|i|
			(dur: durs[i], note: notes[i])
		})
	}

	//convvoices :: ([Float], [Float], [Float]) -> [(tempo, transp, amp)]
	*convoices { | tempos, transps, amps = ([])|
		^[tempos.size, transps.size].minItem.collect({|i|
			(tempo: tempos[i], transp: transps[i], amp: amps[i] ? 1)
		})
	}

	//divoices :: ([Float], [Float]) ->[(transp: Float, amp: Float)]
	*divoices { |transps, amps = ([])|
		^transps.collect({|transp, i|
			(transp: transp, amp: amps[i] ? 1)
		})
	}

	//divtempos :: ([Float], [Float], Boolean) ->[(tempo: Float, percentage: Float)]
	*divtempos { | tempos, percentageForTempo, normalize= false|
		var percentages = if(normalize, {percentageForTempo.normalizeSum*100}, {percentageForTempo});

		^[tempos.size, percentageForTempo.size].minItem.collect({|i|
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