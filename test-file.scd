(
s = Can.defaultServerConfig;
s.waitForBoot({
	var player, canonConfig;
	Can.registerDefaultSynthDefs;
	Can.diverge(
		baseTempo: 60,
		instruments: [\pianola],
		//player: player,
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
	).play
})
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
	//player: player,
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
(
s = Can.defaultServerConfig;
s.waitForBoot({
	var player, canonConfig;
	Can.registerDefaultSynthDefs;
	//
	// // ~config = ~presets.pyramidalMelody;
	// // ~config[\instruments] = [\portamento, \pianola];
	// ~myplayer = {|canon, instruments|
	// 	Task({
	// 		"customplayer".postln;
	// 		1.wait;
	// 		canon.postln;
	// 		1.wait;
	// 		instruments.postln;
	// 	})
	// };
	// c = Can.converge(
	// 	instruments: [\portamento, \pianola],
	// 	// player: ~myplayer,
	// 	cp: 600,
	// 	melody: Can.melody(
	// 		(16..40).pyramid.reciprocal.reverse.mirror,
	// 		((16..40).pyramidg.collect({|arr, i| arr+i})*12).flatten.reverse.mirror.cpsmidi
	// 	),
	// 	voices: Can.convoices(
	// 		[120*7/12, 120*11/12, 120*13/12, 120*17/12, 120*19/12, 120*23/12],
	// 		[0,1,2,3,4,5]
	// 	)
	// );
	// c.visualize;









player = {|self, canon, instruments|
	Task({
		"customplayer".postln;
		1.wait;
		canon.postln;
		1.wait;
		instruments.postln;
	})
};
canonConfig = (
  baseTempo: 60,
  instruments: [\pianola],
	//player: player,
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

Can.divergence(
  baseTempo: 60,
  instruments: [\pianola],
	//player: player,
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
).play
})
)


