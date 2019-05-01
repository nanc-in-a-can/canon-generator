+Can {
	*pPlayer {|symbol, canon, instruments, repeat = 1, osc, meta = (())|
		var pdef;
		var sym = symbol ? UniqueID.next.asSymbol;

		var oscParam = {|voiceIndex, cp|
			if(osc != nil,
				{
					[
						\osc,
						Pfunc({|event|
							osc.net.sendMsg(
								*([osc.path ? \canosc, rrand(0,34), cp] ++
									osc.send.collect(event[_])).flatten
							)
						})
					]
				},
				{[]}
			)
		};

		var pBindVoicePlayer = {|instrument, amp=1, pan=0, out=0, repeat=1|
			{|voice, index|
				var pairs = [
					\instrument, instrument.wrapAt(index),
					\dur, Pseq([voice.onset] ++ voice.durs ++ [voice.remainder], repeat),
					\midinote, Pseq([\rest] ++ voice.notes ++ [\rest], inf),
					\out, out,
					\amp, (amp * (voice.amp ? 1)),
					\pan, pan
				]
				++oscParam.(index, voice.cp)
				++(meta.pbind ? []);
				Pbind(*pairs)
			}
		};

		var result = canon
		.collect(
			pBindVoicePlayer.(
				instruments,
				amp: meta.amp ? 1,
				repeat: repeat,
				out: meta.out ? 0
			)
		);

		pdef = Pdef(sym, Ppar(result), repeat);
		pdef.quant = meta.quant ? 1;
		^pdef;
	}
}
