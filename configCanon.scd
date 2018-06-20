

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