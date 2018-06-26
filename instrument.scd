// ~instrument :: ([Symbol], [Amp, Pan, Out, Int) -> ((durs, notes, onset), Int) -> Pbind
~instrument = {|instrument, amp=1, pan=0, out=0, repeat=1|
    {|line, index|
        Pbind(
			\instrument, instrument.wrapAt(index),
			\dur, Pseq([line.onset.postln] ++ line.durs ++ [line.remainder], repeat),
			\midinote, Pseq([\rest]++line.notes ++ [\rest], inf),
            \out, out,
            \amp, amp,
            \pan, pan,
        )
    }
};