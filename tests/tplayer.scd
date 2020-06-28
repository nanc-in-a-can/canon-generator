Can.init
s.boot

// alternating between these two canons should be seamless
(

	c = Can.converge(
		symbol: \def,
		instruments: [\sin],
		meta: (gain: 1),
	//	player: {|symbol, canon, instruments, repeat, osc, meta| CanPlayer.setupInCan(symbol, canon, instruments, repeat, osc, meta)},
		repeat: inf,
	    cp: [2],
		melody: Can.isomelody(
			durs: [1,1,1, 1]/5,
			notes: [60],
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			[50],
			(0..4),
			[0.7, 0.3, 0.5]
		)
	);
	d = Can.converge(
		symbol: \def,
		instruments: [\sin],
		meta: (gain: 1),
		repeat: inf,
	    cp: [2],
		melody: Can.isomelody(
			durs: [1,1,1,1]/5,
			notes: [70],
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			[50],
			(0..2),
			[0.7, 0.3, 0.5]
		)
	);
)
p = c.rebuildPlayer.player.play;
p.stop;

// alternating between these two canons should be seamless as well
p.changeCanon(c.canon);
p.changeCanon(d.canon);

CanPlayer.get(\def).play
CanPlayer.get(\def).stop
p.speed(2);

(// lower amp
p.onEvent({|event|
	//"corre".postln;
	//1.at(1).postln; // uncomment to try and test setting onEvent functions that fail
	(
	instrument: \sin,
	freq: event.note.midicps,
	dur: event.dur,
	amp: event.amp*1
	).play
;});
)
Can.init
s.boot
(
	~osc = (net: NetAddr("localhost", 57101));
e = Can.converge(
	symbol: \def,
	instruments: [\sin],
	meta: (gain: 1),
	osc: ~osc,
	repeat: inf,
	cp: [1],
	melody: Can.isomelody(
		durs: [1,1,1,1]/5,
		notes: [70, 77, 60, 50],
		amps: [0.4, 0.2, 1]
	),
	voices: Can.convoices(
		[50, 70],
		(0..2),
		[0.7, 0.3, 0.5]
	)
);
e.reset.play
)
e.stop
