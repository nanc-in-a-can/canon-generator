(
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

//~makeMelody ::[Float] -> [Float] -> [(dur, note)]
~makeMelody = {|durs_arr, notes_arr|
    [durs_arr.size, notes_arr.size].minItem.collect({|i|
        (dur: durs_arr[i], note: notes_arr[i])
    })
};

//~makeConvVoices :: ([Float], [Float], [Float]) -> [(tempo, transp, amp)]
~makeConvVoices = { | tempo_arr, transp_arr, amp_arr = ([])|
    [tempo_arr.size, transp_arr.size].minItem.collect({|i|
		(tempo: tempo_arr[i], transp: transp_arr[i], amp: amp_arr[i] ? 1)
    })
};

//~makeDivVoices :: ([Float], [Float]) ->[(transp: Float, amp: Float)]
~makeDivVoices = { |transp_arr, amp_arr = ([])|
    transp_arr.collect({|transp, i|
        (transp: transp, amp: amp_arr[i] ? 1)
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