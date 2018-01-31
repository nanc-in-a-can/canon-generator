(
~makeCanon = {|data|

var
    makeBcp = {|cp, line| line.copyRange(0, (line.size - cp - 2).asInteger)},
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
    sortedBySpeed,
    melody_data,
    onsets,
    voices,
	patterns,
    voice_data;



	voices = data.voices
	.collect({|voice|
		data.melody.collect({|event|
			(dur: event.dur*makeTempo.(voice.tempo), note: event.note+voice.transp)
	    })
	})
	.collect({|voice|
		var bcp = makeBcp.(150, voice.collect(_.dur));
		(melody: voice, bcp: bcp)
	});

	sortedBySpeed = voices.collect({|voice| (
		durs: voice.melody.collect(_.dur),
		notes: voice.melody.collect(_.note),
		bcp: voice.bcp.sum,
	)}).sort({|voice| voice.durs.sum < voice.durs.sum });

	melody_data= sortedBySpeed.collect({|voice| voice.notes});

    voice_data = sortedBySpeed.collect({|voice| voice.durs});

	patterns  = sortedBySpeed.collect(makePatt.(sortedBySpeed, _, _));

	onsets = sortedBySpeed.reverse.inject([], {|acc, elem|
		acc ++ [(sortedBySpeed.reverse[0].bcp - elem.bcp).abs];
	});



    Pdef(\four_v_temporalCanon_v2, Ptpar(
        [onsets, patterns.reverse].lace(patterns.size * 2)
    )).quant([0]);

    ~melody_data = melody_data;
    ~voice_data = voice_data;
    ~tp= data.tp;
    ~bcp1= sortedBySpeed[0].bcp;
    ~bcp2= sortedBySpeed[1].bcp;
    ~bcp3= sortedBySpeed[2].bcp;
    ~bcp4= sortedBySpeed[3].bcp;
    ~line1= sortedBySpeed[0].durs;
    ~line2= sortedBySpeed[1].durs;
    ~line3= sortedBySpeed[2].durs;
    ~line4= sortedBySpeed[3].durs;
    ~melody1= sortedBySpeed[0].notes;
    ~melody2= sortedBySpeed[1].notes;
    ~melody3= sortedBySpeed[2].notes;
    ~melody4= sortedBySpeed[3].notes;
	~distances1= onsets[0];
	~distances2= onsets[1];
	~distances3= onsets[2];
	~distances4= onsets[3];


};
//
// ~makeCanon.(~melodyMaker.randomSymmetric4voices.());
// (/*play Canon!!*/
// // s.record;
// ~reverb= Synth(\reverb);
// Pdef(\four_v_temporalCanon_v2).play;
// );

)

