+Can {

	*pPlayer {|symbol, canon, instruments, repeat = 1, osc|
		var sym = symbol ? UniqueID.next.asSymbol;

		var oscSender = if(osc != nil, {NetAddr.new("127.0.0.1", osc.port ? 7777)});

		var oscParam = if(osc != nil,
			{
				[
					\osc,
					Pfunc({|event|
						oscSender.sendMsg(
							*([osc.path ? \canosc] ++
								osc.vals.collect(event[_]))
						)
					})
				]
			},
			{[]}
		);

		var pBindVoicePlayer = {|instrument, amp=1, pan=0, out=0, repeat=1|
			{|voice, index|
				Pbind(*[
					\instrument, instrument.wrapAt(index),
					\dur, Pseq([voice.onset] ++ voice.durs ++ [voice.remainder], repeat),
					\midinote, Pseq([\rest] ++ voice.notes ++ [\rest], inf),
					\out, out,
					\amp, amp * (voice.amp ? 1),
					\pan, pan,
				]++oscParam)
			}
		};

		var result = canon
		.collect(
			pBindVoicePlayer.(
				instruments,
				amp: 1,
				repeat: repeat
			)
		);


		^Pdef(sym, Ppar(result), repeat);
	}
}
