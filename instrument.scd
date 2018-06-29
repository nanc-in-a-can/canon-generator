// ~instrument :: ([Symbol], [Amp, Pan, Out, Int) -> ((durs, notes, onset), Int) -> Pbind
~instrument = {|instrument, amp=1, pan=0, out=0, repeat=1|
    {|voice, index|
        Pbind(
			\instrument, instrument.wrapAt(index),
			\dur, Pseq([voice.onset.postln] ++ voice.durs ++ [voice.remainder], repeat),
			\midinote, Pseq([\rest]++voice.notes ++ [\rest], inf),
            \out, out,
            \amp, amp * (voice.amp ? 1),
            \pan, pan,
        )
    }
};
