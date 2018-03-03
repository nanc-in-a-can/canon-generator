(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.boot;
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;// exports \piano, \reverb
(thisProcess.nowExecutingPath.dirname++"/makeCanon.scd").load;//exports ~makeCanon, that when called export many other globals :/, also \four_v_temporalCanon_v2
(thisProcess.nowExecutingPath.dirname++"/makeMelody.scd").load;//exports ~makeMelody
(thisProcess.nowExecutingPath.dirname++"/melodyMaker.scd").load;// exports ~melodyMaker
(thisProcess.nowExecutingPath.dirname++"/makeVisualization.scd").load;//exports ~makeVisualization
 //~makeCanon.(~melodyMaker.randomSymmetric4voices);
 //~makeCanon.(~melodyMaker.pyramidalMelody);
// ~makeCanon.(~melodyMaker.simple4NoteMelody(3));
~makeVisualization.(~makeCanon.(~melodyMaker.pyramidalMelody));
)