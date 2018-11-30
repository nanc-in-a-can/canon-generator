+Can {
	*converge {|melody, cp, voices, instruments, player|

    var
	    makeBcp = {|cp, line| line.copyRange(0, (cp - 2).asInteger)},

        makeTempo = {|speed| 60/(speed/4)},

        //creates voices [(melody: [(note, dur)], bcp)]
        voices1 = (voices
            .collect({|voice|
                //for each melody set the correct durations and transposition
                melody.collect({|event|
                    (dur: event.dur*makeTempo.(voice.tempo), note: event.note+voice.transp)
                })
            })
            //get the durations of all notes Before the Convergence Point
            .collect({|voice|
                var bcp = makeBcp.(cp, voice.collect(_.dur));
			    (melody: voice, bcp: bcp)
            })
        ),


        //sorted voices from shortes to longest
    	//[(durs: [Float], notes: [midiNote], bcp: [Float])]
        sortedBySpeed = (voices1.collect({|voice, i| (
            durs: voice.melody.collect(_.dur),
            notes: voice.melody.collect(_.note),
            bcp: voice.bcp.sum,
		    amp: voices1[i].amp
        )})
            .sort({|voice1, voice2| voice1.durs.sum < voice2.durs.sum })
        ),

        //voice onset times
        onsets = sortedBySpeed.reverse.inject([], {|acc, elem|
            acc ++ [(sortedBySpeed.reverse[0].bcp - elem.bcp).abs];
        }),

    	canon = sortedBySpeed.collect({|voice, i|
		    var onset = (sortedBySpeed[sortedBySpeed.size - 1].bcp - voice.bcp).abs;
    		(
    			durs: voice.durs,
    			notes: voice.notes,
			    remainder: sortedBySpeed[sortedBySpeed.size - 1].durs.sum - (onset + voice.durs.sum),
    			bcp: voice.bcp,
    			onset: onset,
			    amp: voice.amp,
    			cp: cp
    		)
    	}),

		instruments_ = this.getInstruments(instruments),

		player_ = this.getPlayer(player, canon, instruments_),

		data = (melody: melody, cp: cp, voices: voices, instruments: instruments_, player: player);

		^(
			canon: canon,
			data: data,
			player: player_,
			play: {player_.play},
			visualize: {|server, autoscroll = true| this.visualize(server, (canon: canon, data: data), autoscroll)}
		);
	}
}