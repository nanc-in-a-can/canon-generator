

(
//~makeConvCanon.(~melodyMaker.randomSymmetric4voices);
// ~makeConvCanon.(~melodyMaker.pyramidalMelody);
// ~makeConvCanon.(~melodyMaker.simple4NoteMelody(3)).data.voices;
~makeVisualization.(~makeConvCanon.(~melodyMaker.simple4NoteMelody(3)));
//
// ~canon = ~makeDivCanon.((
// 	baseTempo: 1000,
// 	transps: [1, 2, 3],
// 	tempos: [(tempo: 3, percentage: 30), (tempo: 5, percentage: 50), (tempo: 2, percentage: 20)],
// 	melody: [(dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62)]
// ));
// ~makeVisualization.(~canon);

)


// working area with presets;

~reverb= Synth(\reverb);
~makeVisualization.(~makeConvCanon.(~melodyMaker.simple4NoteMelody(3)), autoScroll: false);

~reverb= Synth(\reverb);
~makeVisualization.(~makeConvCanon.(~melodyMaker.randomSymmetric4voices), false);


~reverb= Synth(\reverb);
~makeVisualization.(~makeConvCanon.(~melodyMaker.pyramidalMelody));

(
// working area to customize melodies;
(
~withChords = ~makeConvCanon.((
	cp: 2,
	melody: [(dur: 1/4, note: [30, 50]), (dur: 1/4, note: [76, 90]), (dur: 1/4, note: 50), (dur: 1/2, note: [62,73]), (dur: 2/3, note: [71,72,73]), (dur: 1/4, note: 50), (dur: 1/2, note: [62,73]), (dur: 2/3, note: [71,72,73])],
	voices: [(tempo: 170, transp: 20), (tempo: 120, transp: 1), (tempo: 130, transp: 86)]
));


~withChords.canon.collect(~mySound).do(_.play);

// ~instrument.(\pianola, ~withChords.canon).do(_.play);

~mispbinds = ~withChords.canon
.collect(~instrument.([\pianola], amp: 1, repeat: inf)));
// .collect(~sound.(\otra))
// .do(_.play);

// ~withChords.canon.collect(~sound.(\pianola, _, _)).do(_.play);

// ~makeVisualization.(~withChords);
~mipdef = Pdef(\mipidef, Ppar(~mispbinds, inf))
// ~mipdef2 = Pdef(\mipidef2, Ppar(~mispbinds, inf))
)


~mipdef.play
~mipdef.stop