+Can {

	*pPlayer {|symbol, canon, instruments, repeat = 1|

		var pBindVoicePlayer = {|instrument, amp=1, pan=0, out=0, repeat=1|
			{|voice, index|
				Pbind(
					\instrument, instrument.wrapAt(index),
					\dur, Pseq([voice.onset] ++ voice.durs ++ [voice.remainder], repeat),
					\midinote, Pseq([\rest]++voice.notes ++ [\rest], inf),
					\out, out,
					\amp, amp * (voice.amp ? 1),
					\pan, pan,
				)
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

		^Pdef(symbol ? UniqueID.next.asSymbol, Ppar(result), repeat);
	}
}
