Can.init
s.boot
(

	c = Can.converge(
		instruments: [\sin],
		meta: (gain: 1),
	//	player: {|symbol, canon, instruments, repeat, osc, meta| CanPlayer.setupInCan(symbol, canon, instruments, repeat, osc, meta)},
		repeat: inf,
	    cp: [2],
		melody: Can.isomelody(
			durs: [1,1,2,1]/5,
			notes: [50, 30, 80],
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			[50, 60, 70],
			(0..4),
			[0.7, 0.3, 0.5]
		)
	);
	Can.dur(c);

	d = Can.converge(
		instruments: [\sin],
		meta: (gain: 1),
		repeat: inf,
	    cp: [2],
		melody: Can.isomelody(
			durs: [1,1,2,1]/5,
			notes: [50, 30, 80] + 20,
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			[50, 60, 70],
			(0..2),
			[0.7, 0.3, 0.5]
		)
	);
	Can.dur(d);
	p = CanPlayer(\def, d.canon, repeat: inf).play;
)
Can.init
s.boot
w = CanPlayer.setupInCan(\una, c.canon, [\sin], 3, nil, ())
w.play
p.player.wasStopped
p.reset;
p.isFinished
p.newCanon
p.currentCanon;
q = CanPlayer(\def, c.canon, repeat: 3);

Can.dur(c)
CanPlayer.prCalculateNewState(d.canon, c.canon,3, 3)
CanPlayer.prMakeNextStateForNewCanon(d.canon, 10)

q.reset;
p.changeCanon(c.canon);
c.canon.postln;
CanPlayer.get(\def).play
CanPlayer.get(\def).stop
p.speed(2);
p.player.isPlaying
(
p.onEvent({|event|
	(
	instrument: \sin,
	freq: event.note.midicps,
	dur: event.dur,
	amp: event.amp*0.1
	).play
;});
)
p.stop;
(pero el mito perdura)

a = (sum: {|a, b = 3| a +b})
a.sum.(1, nil)



(
	e = Can.converge(
		symbol: \def,
		instruments: [\sin],
		meta: (gain: 1),
		player: {|symbol, canon, instruments, repeat, osc, meta|
			CanPlayer.setupInCan(symbol, canon, instruments, repeat, osc, meta)},
		repeat: inf,
	    cp: [1],
		melody: Can.isomelody(
			durs: [1,1,2,1]/30,
			notes: (60..63) + 20,
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			[50, 60, 70],
			[0, 7, 12, 20],
			[0.7, 0.3, 0.5]
		)
	);

	e;
	)

	e.player.play
