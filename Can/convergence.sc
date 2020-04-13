+Can {
	*converge {|symbol, melody, cp, voices, instruments, period, player, repeat = 1, osc, meta|

		var
		cp_ = cp.isFunction.if({cp.(melody)}, {cp}),

		makeBcp = {|cp, line| line.copyRange(0, (cp - 2).asInteger).sum},

		makeTempo = {|speed| 60/(speed/4)},

		slowestTempo = voices.collect(_.tempo).minItem,

		totalDur = melody.collect(_.dur).sum*makeTempo.(slowestTempo),

		scalingFactor = period.isNil.if({1}, {period/totalDur}),

		notes = melody.collect(_.note),// used on transposition when voice.transp.isFunction, not the most efficient implementation, because we go back to what Can.melody takes as input, but may do for now

		//creates voices [(melody: [(note, dur, amp)], bcp)]
		voices1 = (voices
			.collect({|voice, voiceIndex|
				var voiceNotes = voice[\transp].isFunction.if(
					{voice[\transp].(notes)}
				);
				//for each melody set the correct durations and transposition
				melody.collect({|event, i|
					var note = voice[\transp].isFunction.if(
						{voiceNotes[i]},
						{event.note+voice.transp}
					);
					(
						dur: event.dur*makeTempo.(voice.tempo)*scalingFactor,
						note: note,
						amp: event.amp*voices[voiceIndex].amp
					)
				})
			})
			//get the durations of all notes Before the Convergence Point
			.collect({|voice, i|
				var cp = if(cp_.isArray, {cp_.wrapAt(i)}, {cp_});
				var bcp = makeBcp.(cp, voice.collect(_.dur));
				(melody: voice, bcp: bcp, cp: cp)
			})
		),


		//sorted voices from longest to shortes
		//[(durs: [Float], notes: [midiNote], bcp: [Float])]
		sortedBySpeed = (voices1.collect({|voice, i| (
			durs: voice.melody.collect(_.dur),
			notes: voice.melody.collect(_.note),
			amps: voice.melody.collect(_.amp),
			bcp: voice.bcp,
			cp: voice.cp
		)})
		.sort({|voice1, voice2| voice1.durs.sum > voice2.durs.sum })
		),

		canon = sortedBySpeed.collect({|voice, i|
			var onset = (sortedBySpeed[0].durs.copyRange(0, voice.cp -2 ).sum - voice.bcp).abs;
			(
				durs: voice.durs,
				notes: voice.notes,
				amps: voice.amps,
				remainder: sortedBySpeed[0].durs.sum - (onset + voice.durs.sum),
				bcp: voice.bcp,
				onset: onset,
				cp: cp_
			)
		}),

		instruments_ = this.getInstruments(instruments),

		player_ = this.getPlayer(symbol, player, canon, instruments_, repeat, osc, meta),

		data = (
			symbol: symbol,
			melody: melody,
			cp: cp_,
			voices: voices,
			instruments: instruments_,
			player: {player}, //we put the player function inside a function, because otherwise the Event object will excute it, we want to keep it as metadata, and for the Event object to return it
			repeat: repeat,
			osc: osc
		);

		^Canon(
			canon: canon,
			data: data,
			player: player_,
			// play: {player_.play},
			// visualize: {|server, autoscroll = true| this.visualize(server, (canon: canon, data: data), autoscroll)}
		);
	}
}
