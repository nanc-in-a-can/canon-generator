+Can {
	*converge {|symbol, melody, cp, voices, instruments, period, player, repeat = 1, osc, meta|

    var
        cp_ = cp.isFunction.if({cp.(melody)}, {cp}),

	    makeBcp = {|cp, line| line.copyRange(0, (cp - 2).asInteger)},

        makeTempo = {|speed| 60/(speed/4)},

		slowestTempo = voices.collect(_.tempo).minItem,

		totalDur = melody.collect(_.dur).sum*makeTempo.(slowestTempo),

		scalingFactor = period.isNil.if({1}, {period/totalDur}),
		notes = melody.collect(_.note),// used on transposition when voice.transp.isFunction, not the most efficient implementation, because we go back to what Can.melody takes as input, but may do for now

        //creates voices [(melody: [(note, dur)], bcp)]
        voices1 = (voices
            .collect({|voice|
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
                        note: note
                    )
                })
			})
            //get the durations of all notes Before the Convergence Point
            .collect({|voice|
                var bcp = makeBcp.(cp_, voice.collect(_.dur));
			    (melody: voice, bcp: bcp)
            })
		),


        //sorted voices from longest to shortes
		//[(durs: [Float], notes: [midiNote], bcp: [Float])]
		sortedBySpeed = (voices1.collect({|voice, i| (
			durs: voice.melody.collect(_.dur),
			notes: voice.melody.collect(_.note),
			bcp: voice.bcp.sum,
		    amp: voices1[i].amp
		)})
            .sort({|voice1, voice2| voice1.durs.sum > voice2.durs.sum })
        ),

        //voice onset times
        onsets = sortedBySpeed.reverse.inject([], {|acc, elem|
            acc ++ [(sortedBySpeed[0].bcp - elem.bcp).abs];
        }),

    	canon = sortedBySpeed.collect({|voice, i|
		    var onset = (sortedBySpeed[0].bcp - voice.bcp).abs;
    		(
    			durs: voice.durs,
    			notes: voice.notes,
			    remainder: sortedBySpeed[0].durs.sum - (onset + voice.durs.sum),
    			bcp: voice.bcp,
    			onset: onset,
			    amp: voice.amp,
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
