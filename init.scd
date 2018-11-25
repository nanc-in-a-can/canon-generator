(//compile to initialize Nanc-in-a-Can
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
	var baseDir = thisProcess.nowExecutingPath.dirname; // if you are not in an evironment where thisProcess.nowExecutingPath.dirname exists you can configure the path to the library
	(baseDir++"/synthdef-instruments.scd").loadPaths;// add \pianola synthdef,
	(baseDir++"/helpers.scd").load;// exports ~instrument, ~makeMelody, ~makeConvVoices, ~makeDivVoices, ~makeDivTempos, ~mergeCanons
	(baseDir++"/visualize.scd").load;//exports ~visualize
	(baseDir++"/convCanon.scd").load; //exports ~convCanon
	(baseDir++"/divCanon.scd").load;//exports ~divCanon
	(baseDir++"/presets/index.scd").load;// exports ~presets

});
)

(
~config = ~presets.pyramidalMelody;
~config[\instruments] = [\portamento, \pianola];
/*~config[\player] = {|self, canon, instruments|
	Task({
		"customplayer".postln;
		1.wait;
		canon.postln;
		1.wait;
		instruments.postln;
	})
};*/
c = Can.convergence(~config);
c.play;
nil
)
// c.player.pause



(
a = ();
a.player = {|self, x| ("Hola"+x).postln};
a.player(5)

)



(
var player = {|self, canon, instruments|
	Task({
		"customplayer".postln;
		1.wait;
		canon.postln;
		1.wait;
		instruments.postln;
	})
};
var canonConfig = (
  baseTempo: 60,
  instruments: [\pianola],
	player: player,
  melody: [
    (dur: 1, note: 60),
    (dur: 1/2, note: 61),
    (dur: 1/3, note: 62),
    (dur: 1/4, note: 63)
  ],
  voices: [ // Note that voices and tempos should be arrays of the same size
    (transp: 2, amp: 0.7),
    (transp: 10, amp: 0.5),
    (transp: -12, amp: 1),
    (transp: -8, amp: 1)
  ],
  tempos: [
    (tempo: 70,  percentage: 20),
    (tempo: 40,  percentage: 30),
    (tempo: 120, percentage: 10),
    (tempo: 300, percentage: 40)
  ]
);

Can.divergence(canonConfig).play
)

Can.makeMelody([1,2,3], [4,5,6])

s = Can.defaultServerConfig
s.waitForBoot({
	Can.registerDefaultSynthDefs
})
