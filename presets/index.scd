(
~presets = (
    nancarrow: (), //studies are defined on  "/nancarrow"
	randomSymmetric4voices: {
        var
            tp = 300,
            cp = (tp/2),
            cP1 = [70],
            makeMelody = {|bcp_length|
                var section1 = bcp_length.collect({
                    [45,46,50,52.5,53,55.2,57,58,60.3,62,63,65.5]
                        .wchoose([4,3,8,2,4,2,7,5,2,5,3,3].normalizeSum)
                    });
                (section1)++cP1++(section1.reverse)++([section1[0]])

            },
            melody = makeMelody.((tp - cp - 1).asInteger),
            rhythmicProportions = 1/[1, 4, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 24, 32],
            rhythm = melody.collect({ rhythmicProportions.wchoose([1,5,4,10,5,8,5,8,5,6,5,10,4,4,4,8,8,10].normalizeSum) }),
    		fullMelody = [melody, rhythm]
    		  .lace(melody.size*2)
    		  .reshape(melody.size, 2)
    		  .collect({|note_dur| (note: note_dur[0], dur: note_dur[1])});

        (
            cp: cp,
			melody: fullMelody,//[(dur, note)]
			voices: [
				(tempo: 60, transp: 0),
				(tempo: 65, transp: -12),
				(tempo: 57, transp: 12),
				(tempo: 63, transp: 8)
			]
        )

	},
	simple4NoteMelody: {|this_, convergence_point| /*for some reason SC automatically passes the Event object as the first parameter, but the function just needs to receive the convergence point as the first parameter when being called. E.g.: ~presets.simple4NoteMelody(2)*/

		(
            cp: convergence_point,
	        melody: [(dur: 1, note: 60), (dur: 1, note: 61), (dur: 1, note: 62), (dur: 1, note: 63)],
			voices: [
				(tempo: 70, transp: 0),
				(tempo: 65, transp: -12),
				(tempo: 57, transp: 12),
				(tempo: 43, transp: 8)
			]
        )
	},

	pyramidalMelody: {
		(
        	cp: 600,
        	melody: ~makeMelody.(
        		(16..40).pyramid.reciprocal.reverse.mirror,
				((16..40).pyramidg.collect({|arr, i| arr+i})*12).flatten.reverse.mirror.cpsmidi
        	),
        	voices: [
        		(tempo: 120*7/12, transp: 0),
                (tempo: 120*11/12, transp: 1),
                (tempo: 120*13/12, transp: 2),
                (tempo: 120*17/12, transp: 3),
        		(tempo: 120*19/12, transp: 4),
        	    (tempo: 120*23/12, transp: 5)
        	]
        )
	},

	chido_melody:  {
    	(
                cp: 32,
                melody: [
				(dur: 0.21, note: 60), (dur: 0.35, note: 61), (dur: 0.45, note: 62), (dur: 0.17, note: 63), (dur: 0.24, note: 59),
				(dur: 0.21, note: 60), (dur: 0.35, note: 62), (dur: 0.45 - 0.20, note: 62), (dur: 0.17 - 0.01, note: 65), (dur: 0.24 - 0.02, note: 52),
				(dur: 0.21, note: 60), (dur: 0.35, note: 63), (dur: 0.45 - 0.22, note: 62), (dur: 0.17 - 0.02, note: 66), (dur: 0.24 - 0.03, note: 53),
				(dur: 0.21, note: 60), (dur: 0.35, note: 64), (dur: 0.45 - 0.24, note: 62), (dur: 0.17 - 0.03, note: 67), (dur: 0.24 - 0.02, note: 54),
				(dur: 0.21, note: 60), (dur: 0.35, note: 65), (dur: 0.45 - 0.26, note: 62), (dur: 0.17 - 0.04, note: 68), (dur: 0.24 - 0.01, note: 55),
				(dur: 0.21, note: 60), (dur: 0.35, note: 66), (dur: 0.45 - 0.28, note: 62), (dur: 0.17 - 0.05, note: 69), (dur: 0.24 - 0.02, note: 56),
				(dur: 0.21, note: 60), (dur: 0.35, note: 67), (dur: 0.45 - 0.31, note: 62), (dur: 0.17 - 0.06, note: 71), (dur: 4, note: 57)
    	],
			voices: [
				(tempo: 90, transp: 0),
                (tempo: 95, transp: -12),
                (tempo: 100, transp: 12),
                (tempo: 83, transp: 8),
				(tempo: 110, transp: 24),
                (tempo: 105, transp: 19),
                (tempo: 113, transp: 10),
                (tempo: 87, transp: 24),
				(tempo: 80, transp: -24),
                (tempo: 87, transp: -15),
                (tempo: 117, transp: 36),
                (tempo: 75, transp: -10),
				(tempo: 70, transp: -36),
                (tempo: 77, transp: -12),
                (tempo: 120, transp: 12),
                (tempo: 80, transp: 8),
				(tempo: 115, transp: 36),
                (tempo: 97, transp: 5),
                (tempo: 125, transp: 33),
                (tempo: 65, transp: -36),
			]
    	)
    }
);

// ~presets.chido_melody.();
// ~presets.randomSymmetric4voices.();
// ~presets.simple4NoteMelody(2)
)

(thisProcess.nowExecutingPath.dirname++"/nancarrow/index.scd").load;
