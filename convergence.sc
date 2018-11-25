+Can {
	*convergence {|data|

    var
	    makeBcp = {|cp, line| line.copyRange(0, (cp - 2).asInteger)},

        makeTempo = {|speed| 60/(speed/4)},

        //creates voices [(melody: [(note, dur)], bcp)]
        voices = (data.voices
            .collect({|voice|
                //for each melody set the correct durations and transposition
                data.melody.collect({|event|
                    (dur: event.dur*makeTempo.(voice.tempo), note: event.note+voice.transp)
                })
            })
            //get the durations of all notes Before the Convergence Point
            .collect({|voice|
                var bcp = makeBcp.(data.cp, voice.collect(_.dur));
			    (melody: voice, bcp: bcp)
            })
        ),


        //sorted voices from shortes to longest
    	//[(durs: [Float], notes: [midiNote], bcp: [Float])]
        sortedBySpeed = (voices.collect({|voice, i| (
            durs: voice.melody.collect(_.dur),
            notes: voice.melody.collect(_.note),
            bcp: voice.bcp.sum,
		    amp: data.voices[i].amp
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
    			cp: data.cp
    		)
    	});

	   ^(canon: canon, data: data);
	}
}