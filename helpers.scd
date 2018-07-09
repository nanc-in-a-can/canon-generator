(
// ~instrument :: ([Symbol], [Amp, Pan, Out, Int) -> ((durs, notes, onset), Int) -> Pbind
~instrument = {|instrument, amp=1, pan=0, out=0, repeat=1|
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

//~makeMelody ::[Float] -> [Float] -> [(dur, note)]
~makeMelody = {|durs, notes|
    [durs.size, notes.size].minItem.collect({|i|
        (dur: durs[i], note: notes[i])
    })
};

//~makeConvVoices :: ([Float], [Float], [Float]) -> [(tempo, transp, amp)]
~makeConvVoices = { | tempos, transps, amps = ([])|
    [tempos.size, transps.size].minItem.collect({|i|
		(tempo: tempos[i], transp: transps[i], amp: amps[i] ? 1)
    })
};

//~makeDivVoices :: ([Float], [Float]) ->[(transp: Float, amp: Float)]
~makeDivVoices = { |transps, amps = ([])|
    transps.collect({|transp, i|
        (transp: transp, amp: amps[i] ? 1)
    })
};

//~makeDivTempos :: ([Float], [Float], Boolean) ->[(tempo: Float, percentage: Float)]
~makeDivTempos = { | tempos, percentageForTempo, normalize= false|
    var percentages = if(normalize, {percentageForTempo.normalizeSum*100}, {percentageForTempo});

    [tempos.size, percentageForTempo.size].minItem.collect({|i|
        (tempo: tempos[i], percentage: percentages[i])
    });
};
)