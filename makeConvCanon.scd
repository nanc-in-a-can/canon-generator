(
//data must be an Event object with the following keys
//(
// cp: Int,//Note number on melody on which the convergence point should happen.
// melody: [(dur: Float, note: midiNote)]// Array of Event objects with note and duration
// voices: [(tempo: Float, transp: Int)]//Array of Event objects with tempo and transposition for each voice that will be generated
//)

~makeCanon = {|data|

    var
	makeBcp = {|cp, line| line.copyRange(0, (cp - 2).asInteger)},


        makeTempo = {|speed| 60/(speed/4)},


        makePatt = {|sortedVoices, voice, index|
            var pan = (index/sortedBySpeed.size*2 - 1) + (1/sortedBySpeed.size);//distributes voices evenly across the stereo field, but it avoids the extreme positions (-1 and 1)
            var line  = voice.durs;
            var melody  = voice.notes;
            Pbind(
                \instrument, \pianola,
                \pan, pan,
                \dur, Pseq(line,1),
                \freq, Pseq(melody,inf),
			\out, [0, ~reverbBus.index],
                \amp, 1

            );
        },


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
        sortedBySpeed = (voices.collect({|voice| (
            durs: voice.melody.collect(_.dur),
            notes: voice.melody.collect(_.note),
            bcp: voice.bcp.sum,
        )})
            .sort({|voice1, voice2| voice1.durs.sum < voice2.durs.sum })
        ),


        //Pbinds
        patterns = sortedBySpeed.collect(makePatt.(sortedBySpeed, _, _)),


        //voice onset times
        onsets = sortedBySpeed.reverse.inject([], {|acc, elem|
            acc ++ [(sortedBySpeed.reverse[0].bcp - elem.bcp).abs];
        }),

    	canon = sortedBySpeed.collect({|voice, i|
    		(
    			durs: voice.durs,
    			notes: voice.notes,
    			bcp: voice.bcp,
    			onset: (sortedBySpeed[sortedBySpeed.size - 1].bcp - voice.bcp).abs,
    			cp: data.cp
    		)
    	});

	   (canon: canon, data: data);

    };

    // ~makeCanon.(~melodyMaker.simple4NoteMelody(2));
)


