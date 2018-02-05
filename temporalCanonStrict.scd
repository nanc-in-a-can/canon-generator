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
                \instrument, \piano,
                \pan, pan,
                \dur, Pseq(line,1),
                \freq, Pseq(melody,inf),
                \out, 10,
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
        });


        //Globals
        Pdef(\four_v_temporalCanon_v2, Ptpar(
            [onsets, patterns.reverse].lace(patterns.size * 2)
        )).quant([0]);

        ~melody_data = sortedBySpeed.collect({|voice| voice.notes});
	/*voice data debería generar durs ordenadas de más lenta a más rápida? entonces hay una discrepancia. Con el canon que generé ene sta sesión d etrabajo voice_data[2].sum me da el canon más grande, necesito entender como conseguir la voz más lenta para poder sincronizar la visualización con el sonido*/
        ~voice_data = sortedBySpeed.collect({|voice| voice.durs});
        ~tp = ~melody_data[0].size;
        ~bcp1 = sortedBySpeed[0].bcp;
        ~bcp2 = sortedBySpeed[1].bcp;
        ~bcp3 = sortedBySpeed[2].bcp;
        ~bcp4 = sortedBySpeed[3].bcp;
        ~line1 = sortedBySpeed[0].durs;
        ~line2 = sortedBySpeed[1].durs;
        ~line3 = sortedBySpeed[2].durs;
        ~line4 = sortedBySpeed[3].durs;
        ~melody1 = sortedBySpeed[0].notes;
        ~melody2 = sortedBySpeed[1].notes;
        ~melody3 = sortedBySpeed[2].notes;
        ~melody4 = sortedBySpeed[3].notes;
    	~distances1 = onsets[3];
    	~distances2 = onsets[2];
    	~distances3 = onsets[1];
    	~distances4 = onsets[0];
        ~tempo1 = data.voices[0].tempo;
        ~tempo2 = data.voices[1].tempo;
        ~tempo3 = data.voices[2].tempo;
        ~tempo4 = data.voices[3].tempo;


    };
    //
// ~makeCanon.(~melodyMaker.randomSymmetric4voices.());
    // (/*play Canon!!*/
    // // s.record;
    // ~reverb= Synth(\reverb);
    // Pdef(\four_v_temporalCanon_v2).play;
    // );



)


