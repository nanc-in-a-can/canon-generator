(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.boot;
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;// exports \piano, \reverb
(thisProcess.nowExecutingPath.dirname++"/temporalCanonStrict.scd").load;//exports ~makeCanon, that when called export many other globals :/, also \four_v_temporalCanon_v2
(thisProcess.nowExecutingPath.dirname++"/melodyMaker.scd").load;// exports ~melodyMaker
// ~makeCanon.(~melodyMaker.randomSymmetric4voices.());
~makeCanon.((
            cp: 2,
	        melody: [(dur: 1, note: 60), (dur: 1, note: 61), (dur: 1, note: 62), (dur: 1, note: 63)],
			voices: [
				(tempo: 60, transp: 0),
				(tempo: 65, transp: -12),
				(tempo: 57, transp: 12),
				(tempo: 63, transp: 8)
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
