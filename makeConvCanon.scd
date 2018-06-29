(
//data must be an Event object with the following keys
//(
// cp: Int,//Note number on melody on which the convergence point should happen.
// melody: [(dur: Float, note: midiNote)]// Array of Event objects with note and duration
// voices: [(tempo: Float, transp: Int)]//Array of Event objects with tempo and transposition for each voice that will be generated
//)

~makeConvCanon = {|data|

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

	   (canon: canon, data: data);

    };

~makeConvCanon.((
            cp: 3,
	        melody: [(dur: 1, note: 60), (dur: 1, note: 61), (dur: 1, note: 62), (dur: 1, note: 63)],
			voices: [
				(tempo: 70, transp: 0, amp: 1),
				(tempo: 65, transp: -12, amp: 0.5),
				(tempo: 57, transp: 12, amp: 0.7),
				(tempo: 43, transp: 8, amp: 0.2)
			]
));
)

