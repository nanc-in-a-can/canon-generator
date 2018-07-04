

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
~makeVisualization.(~makeConvCanon.(~melodyMaker.randomSymmetric4voices), autoScroll: true);


~reverb= Synth(\reverb);
~makeVisualization.(~makeConvCanon.(~melodyMaker.pyramidalMelody), autoScroll: true);

(
// working area to customize melodies;
(
~withChords = ~makeConvCanon.((
	cp: 4,
	melody: [
		(dur: 1/14,     note: [130,130.2, 130.3]),
		(dur: 1/16/3,     note: \rest),
		(dur: 1/16/3,     note: \rest),
		(dur: 1/16*2,     note: \rest),
		(dur: 1/15,     note: [60.5]),
		(dur: 1/16,     note: \rest),
		(dur: 1/16,     note: \rest),
		(dur: 1/16/4,     note: \rest),
		(dur: 1/17/3,     note: [161.5, 2]),
		(dur: 1/18/3,     note: \rest),
		(dur: 1/16,     note: \rest),
		(dur: 1/20/4,     note: [160.5, 401])
	]
	// .pipe({|a| 6.collect([a.choose]).flatten})
	,
	voices: [
		(tempo: 920,   transp: 17.5),
		(tempo: 940,   transp: 14.5),
		(tempo: 910,   transp: 14.7),
		(tempo: 920,   transp: 13.2),
		(tempo: 950,   transp: 13.8)
	]
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

(
// working area to customize melodies;
(
~withChords = ~makeConvCanon.((
	cp: 10,
	melody: [
		(dur: 8/14/30,     note: [10]),
		(dur: 8/10,     note: [160.5, 2]*30.5),
		(dur: 15/16,     note: \rest),
		(dur: 8/10/13,     note: [160.5]*2),
		(dur: 8/10/13,     note: [60.3]*2),
		(dur: 80/170,     note: [160.5, 20]*5/3),
		(dur: 8/16/20,     note: \rest),

		(dur: 8/20/4,     note: [160.5, 401]/2),
		(dur: 600/18/3,     note: \rest),

	],
	voices: [
		(tempo: 190,   transp: 20),
		(tempo: 150,   transp: 29),
		(tempo: 120,   transp: -20),
		(tempo: 90,   transp: 12.2),
		(tempo: 197,   transp: 13.5)
	]
));


~withChords.canon.collect(~mySound).do(_.play);

// ~instrument.(\pianola, ~withChords.canon).do(_.play);

~mispbinds2 = ~withChords.canon
.collect(~instrument.([\pianola, \default], amp: 1, repeat: inf)));
// .collect(~sound.(\otra))
// .do(_.play);

// ~withChords.canon.collect(~sound.(\pianola, _, _)).do(_.play);

// ~makeVisualization.(~withChords);
Pdef(\mipidef2, Ppar(~mispbinds2, inf))
// ~mipdef2 = Pdef(\mipidef2, Ppar(~mispbinds, inf))
)



(
~canonConfig = (
  baseTempo: 60,
  melody: [
    (dur: 1, note: 60),
    (dur: 1/2, note: 61),
    (dur: 1/3, note: 62),
    (dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1, note: 60),
    (dur: 1/2, note: 61),
    (dur: 1/3, note: 62),
    (dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
		(dur: 1/4, note: 63),
  ],
  voices: [ // Note that voices and tempos should be arrays of the same size
    (transp: 2, amp: 0.7),
    (transp: 10, amp: 0.5),
    (transp: -12, amp: 1),
    (transp: -8, amp: 1)
  ],
  tempos: [
    (tempo: 70, percentage: 20),
    (tempo: 40, percentage: 30),
    (tempo: 120, percentage: 10),
    (tempo: 300, percentage: 40)
  ]
);
~myCanon = ~makeDivCanon.(~canonConfig);

~makeVisualization.(~myCanon);
)