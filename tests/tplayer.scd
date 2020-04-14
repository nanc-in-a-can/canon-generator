Can.init

(10..20).do{|e, i| e.postln}
s.boot
(
c = Can.converge(
	instruments: [\sin],
	meta: (gain: 1),
	repeat: inf,
    cp: [2],
	melody: Can.isomelody(
		durs: [1,1,2,1]/5,
		notes: (60..63).scramble,
		amps: [0.4, 0.2, 1]
	),
	voices: Can.convoices(
		(60..65),
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
		notes: ((60..63)+20).scramble,
		amps: [0.4, 0.2, 1]
	),
	voices: Can.convoices(
		(60..65),
		(0..2),
		[0.7, 0.3, 0.5]
	)
);
Can.dur(d)
)


(
~makeNextStateForNewCanon = {|newCanon, nextAt|
	newCanon.inject(
		List [],
		{|acc, voice, voiceIndex|
			var res = voice.durs.inject(
				(nextSoundAt: 0, nextIndex: 0),
			{|result, dur, i|
				if(result.nextSoundAt >= nextAt,
					{result},
					{(
						nextSoundAt: result.nextSoundAt+dur,
						nextIndex: i + 1,
						data: voice,
						voiceIndex: voiceIndex
					)}
				)
			});
			acc.add(res);
		}
	)
};

CanPlayer.prMakeNextStateForNewCanon(d.canon, 3)
)

d.canon[4].durs[0..2].sum
d.canon[1].durs.sum
(
~calculateNewState = {|oldCanon, newCanon, nextAt/*in ms*/, elapsed /*in ms*/|
	var oldCanDur = oldCanon[0].durs.sum.postln;
	var newCanDur = newCanon[0].durs.sum.postln;
	var nextAtPercentage = (nextAt/1000)/oldCanDur;
	var elapsedPercentage = (elapsed/1000)/oldCanDur;
	var nextEventForNewCanon = newCanDur*nextAtPercentage;
	var elapsedForNewCanon = newCanDur*elapsedPercentage*1000;
	var newState = ~makeNextStateForNewCanon.(newCanon, nextEventForNewCanon);
	(
		elapsed: elapsedForNewCanon,
		numVoices: newCanon.size,
		voicesState: newState
	);

};
p = CanPlayer.prCalculateNewState(c.canon, d.canon, 3000, 2000);
)

(

	c = Can.converge(
		instruments: [\sin],
		meta: (gain: 1),
		repeat: inf,
	    cp: [2],
		melody: Can.isomelody(
			durs: [1,1,2,1]/5,
			notes: (60..63).scramble,
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			(60..65),
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
			notes: ((60..63)+20).scramble,
			amps: [0.4, 0.2, 1]
		),
		voices: Can.convoices(
			(60..65),
			(0..2),
			[0.7, 0.3, 0.5]
		)
	);
	Can.dur(d);

	~controls = (tempoScale: 1, hamp: 1, vdensity: 1);
~eventPlayer = Ref()
)
p = CanPlayer(\def, d.canon).play;
CanPlayer.get(\def).stop
p.speed(2);
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
(

	~controls.tempoScale = 1;
	~controls.hamp = 0.2;
	~controls.vdensity = 1;
~eventPlayer.set({|dur, note, amp|
	(
	instrument: \sin,
	freq: note.midicps,
	dur: if(dur === inf, {0}, {dur}),
	amp: amp*1
	).play
;})
)
Can.dur(c)
(
~makeTaskPlayer = {|def, controls, canon, eventPlayer|
	var makeVoicesState = {|canon|
		(0..canon.size - 1).inject(List [], {|acc, i|
			acc.add((
				voiceIndex: (i - (canon.size -1)).abs,
				data: canon[i],
				nextIndex: 0,
				nextSoundAt: canon[i].onset*1000, // in ms
			))
		});
	};
	var currentCanon = canon;
	var globalNextSoundAt = 0;
	var elapsed = 0;
	var numVoices = canon.size;
	var voicesState = makeVoicesState.(canon);
	var newCanon = nil;
	var changeCanon = {|self, canon|
		canon.postln;
		newCanon = canon;
		currentCanon = canon;
		// newCanon.p/ostm(newCanon);
	};
	var updateState = {|newState|
		"uuuuuuuuuuuuuuuuuuuuupp".postln;
		numVoices.postln;
		newState.numVoices.postln;
		newCanon = nil;
		elapsed = newState.elapsed;
		numVoices = newState.numVoices;
		voicesState = newState.voicesState;
		"done".postln;
	};
	var getState = {[newCanon, numVoices, voicesState]};
	var player = Tdef(def, {
		var finishedCanons = 0;
		inf.do({|i|
			var iterateVoices = globalNextSoundAt <= elapsed;

			if(iterateVoices, { // basic optimization to avoid iteration of voicesState every 1ms
				var nextSoundsAt = List [];
				// elapsed.postln;
				voicesState.do({|voice|
					nextSoundsAt.add(voice.nextSoundAt); // build a list of the nextSoundAt to get the next value for globalNextSoundAt

					if(voice.nextSoundAt <= elapsed, { // check if `voice` shouldPlay it's next sound
						var currentIndex = voice.nextIndex;
						var dur = voice.data.durs[currentIndex] ? inf;
						var note = voice.data.notes[currentIndex];
						var amp = voice.data.amps[currentIndex];

						// update voice state
						voice.nextIndex = voice.nextIndex + 1;
						voice.nextSoundAt = elapsed + (dur * 1000);

						if(dur == inf,
							{finishedCanons = finishedCanons + 1},
							{eventPlayer.value.(dur, note, amp)}
						);
					});
				});

				//update globalNextSoundAt
				globalNextSoundAt = nextSoundsAt.minItem
				//.postm("nextAt")
				;
			});

			elapsed = elapsed+(1*controls.tempoScale); // update elapsed time, ~tempoScale changes the value by which `elapsed` is updated, by this, the "interal time of the canon" go faster or slower.  If ~tempoScale is > 1 it goes faster than it's original tempo, if < 1 it goes slower.
			if(newCanon.isNil.not,
				{
					"updating".postln;
					updateState.(~calculateNewState.(canon, newCanon, globalNextSoundAt, elapsed));
					"updated".postln;});
			if(finishedCanons >= numVoices, {
				elapsed = 0;
				voicesState = makeVoicesState.(currentCanon)
				//.postm("init state")
				;
				numVoices = currentCanon.size;
				finishedCanons = 0;
				globalNextSoundAt = 0;
			});
			if(~read, {elapsed.postln});
			0.001.wait; // iterate every 1ms
		})
	});
	(player: player, changeCanon: changeCanon, getState: getState);
};
t = ~makeTaskPlayer.(\def, ~controls, c.canon, ~eventPlayer);
t.player.play;
)
t.getState
(
	t.changeCanon(d.canon);
	)
t.player.stop
t.reset
d.canon[0].durs.sum
c.canon[0].durs.sum
5%10

~read = false;
