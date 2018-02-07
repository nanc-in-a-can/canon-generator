(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.5;
s.boot;
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;// exports \piano, \reverb
(thisProcess.nowExecutingPath.dirname++"/temporalCanonStrict.scd").load;//exports ~makeCanon, that when called export many other globals :/, also \four_v_temporalCanon_v2
(thisProcess.nowExecutingPath.dirname++"/melodyMaker.scd").load;// exports ~melodyMaker
// ~makeCanon.(~melodyMaker.randomSymmetric4voices);
// ~makeCanon.(~melodyMaker.simple4NoteMelody(3));
~makeCanon.((
            cp: 34,
            melody: [
		(dur: 0.21, note: 60), (dur: 0.35, note: 61), (dur: 0.45, note: 62), (dur: 0.17, note: 63), (dur: 0.24, note: 59),
		(dur: 0.21, note: 60), (dur: 0.35, note: 62), (dur: 0.45 - 0.20, note: 62), (dur: 0.17 - 0.01, note: 65), (dur: 0.24 - 0.02, note: 52),
		(dur: 0.21, note: 60), (dur: 0.35, note: 63), (dur: 0.45 - 0.22, note: 62), (dur: 0.17 - 0.02, note: 66), (dur: 0.24 - 0.03, note: 53),
		(dur: 0.21, note: 60), (dur: 0.35, note: 64), (dur: 0.45 - 0.24, note: 62), (dur: 0.17 - 0.03, note: 67), (dur: 0.24 - 0.02, note: 54),
		(dur: 0.21, note: 60), (dur: 0.35, note: 65), (dur: 0.45 - 0.26, note: 62), (dur: 0.17 - 0.04, note: 68), (dur: 0.24 - 0.01, note: 55),
		(dur: 0.21, note: 60), (dur: 0.35, note: 66), (dur: 0.45 - 0.28, note: 62), (dur: 0.17 - 0.05, note: 69), (dur: 0.24 - 0.02, note: 56),
		(dur: 0.21, note: 60), (dur: 0.35, note: 67), (dur: 0.45 - 0.31, note: 62), (dur: 0.17 - 0.06, note: 71), (dur: 4, note: 57)
	],
            voices: [
                (tempo: 90, transp: 0),
                (tempo: 95, transp: -12),
                (tempo: 100, transp: 12),
                (tempo: 83, transp: 8)
            ]
        ));
);


(/*play Canon!!*/
// s.record;
~reverb= Synth(\reverb);
Pdef(\four_v_temporalCanon_v2).play;
);

(/*stop Canon*/
Pdef(\four_v_temporalCanon).stop;
~reverb.set(\gate, 0);
);
