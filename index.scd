(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.boot;
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;// exports \piano, \reverb
(thisProcess.nowExecutingPath.dirname++"/makeCanon.scd").load;//exports ~makeCanon
(thisProcess.nowExecutingPath.dirname++"/makeConvDivCanon.scd").load;//exports ~makeConvDivCanon
(thisProcess.nowExecutingPath.dirname++"/makeMelody.scd").load;//exports ~makeMelody
(thisProcess.nowExecutingPath.dirname++"/melodyMaker.scd").load;// exports ~melodyMaker
(thisProcess.nowExecutingPath.dirname++"/makeVisualization.scd").load;//exports ~makeVisualization

//(thisProcess.nowExecutingPath.dirname++"/makeGUI.scd").load;//generates GUI to use with presets

 //~makeCanon.(~melodyMaker.randomSymmetric4voices);
// ~makeCanon.(~melodyMaker.pyramidalMelody);
// ~makeCanon.(~melodyMaker.simple4NoteMelody(3)).data.voices;
// ~makeVisualization.(~makeCanon.(~melodyMaker.pyramidalMelody));
~canon = ~makeConvDivCanon.((
	baseTempo: 1000,
	transps: [1, 2, 3],
	tempos: [(t: 3, percentage: 30), (t: 5, percentage: 50), (t: 2, percentage: 20)],
	melody: [(dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62)]
));
~makeVisualization.(~canon);

)