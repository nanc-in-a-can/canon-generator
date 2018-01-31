(
~melodyMaker = (
	randomSymmetric4voices: {
        var
            tp = 300,
            cp = (tp/2),
            cP1 = [70],
            makeMelody = {|bcp_length|
                var section1 = bcp_length.collect({
                    [45,46,50,52.5,53,55.2,57,58,60.3,62,63,65.5]
                        .wchoose([4,3,8,2,4,2,7,5,2,5,3,3].normalizeSum)
                    }) -12;
                (section1+12)++cP1++(section1.reverse)++([section1[0]])

            },
            melody = makeMelody.((tp - cp - 2).asInteger),
            rhythmicProportions = 1/[1, 4, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 24, 32],
            rhythm = melody.collect({ rhythmicProportions.wchoose([1,5,4,10,5,8,5,8,5,6,5,10,4,4,4,8,8,10].normalizeSum) }),
    		fullMelody = [melody, rhythm]
    		  .lace(melody.size*2)
    		  .reshape(melody.size, 2)
    		  .collect({|note_dur| (note: note_dur[0], dur: note_dur[1])});

        (
            tp: tp,
			melody: fullMelody,//[(dur, note)]
			voices: [
				(tempo: 60, transp: 0),
				(tempo: 65, transp: -12),
				(tempo: 57, transp: 12),
				(tempo: 63, transp: 8)
			]
        )

	}
);

~melodyMaker.randomSymmetric4voices.();
)