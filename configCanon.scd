

(
//~makeCanon.(~melodyMaker.randomSymmetric4voices);
// ~makeCanon.(~melodyMaker.pyramidalMelody);
// ~makeCanon.(~melodyMaker.simple4NoteMelody(3)).data.voices;
// ~makeVisualization.(~makeCanon.(~melodyMaker.pyramidalMelody));

/*~canon = ~makeConvDivCanon.((
	baseTempo: 1000,
	transps: [1, 2, 3],
	tempos: [(t: 3, percentage: 30), (t: 5, percentage: 50), (t: 2, percentage: 20)],
	melody: [(dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62)]
));
~makeVisualization.(~canon);*/

)


// working area with presets;

~reverb= Synth(\reverb);
~makeVisualization.(~makeCanon.(~melodyMaker.simple4NoteMelody(3)), autoScrollSwitch: false);

~reverb= Synth(\reverb);
~makeVisualization.(~makeCanon.(~melodyMaker.randomSymmetric4voices));


~reverb= Synth(\reverb);
~makeVisualization.(~makeCanon.(~melodyMaker.pyramidalMelody));


// working area to customize melodies;
(
~withChords = ~makeCanon.((
	cp: 2,
	melody: [(dur: 1/4, note: 50), (dur: 1/2, note: [62,73]), (dur: 2/3, note: [71,72,73])],
	voices: [(tempo: 55, transp: 4), (tempo: 51, transp: 1)]
));
~mySound = {|line, index|
    Pbind(
        \instrument, \pianola,
        \dur, Pseq([line.onset.postln] ++ line.durs, 1),
        \freq, Pseq([\rest]++line.notes,inf),
        \out, [0, ~reverbBus.index],
        \amp, 1,
        \pan, 0,
        /*this series will provide an Index for later processes*/
        \series, Pseries(0,1,inf),
        /*messages to change the point positions in the map below*/
        \coordinates, Pfunc({|event|
            NetAddr("127.0.0.1", 57120).sendBundle(s.latency, [("/event"++index), event[\freq], event[\series], event[\dur]])
        })
    )
};

// ~withChords.canon.collect(~mySound).do(_.play);
~makeVisualization.(~withChords);
)