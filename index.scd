(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.boot;
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;
(thisProcess.nowExecutingPath.dirname++"/temporalCanonStrict.scd").load;
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
