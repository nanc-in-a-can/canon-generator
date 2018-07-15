(
//data must be an Event object with the following keys
//(
// baseTempo: Float,
// voices: [(transp: Float, amp: Float)], // Array of transpositions, should equal in size the tempos array
// melody: [(dur: Float, note: midiNote)], // Array of Event objects with note and duration
// tempos: [(tempo: Float, percentage: Float)], //Array of Event objects with tempo and percentage (the percentage of the melody that runs at that tempo). The user is responsible for the percentage that will add up in the end. It might be above 100 or below it depending on the sum of the "perc"s passed in.
//)
var divCanon = {|data|
    var
    /**

    setUntil :: [(percentage: Number)] -> [(percentage: Number, until: Number)]

    Adds an "until" field to tempo, which determines the moment in which the voice should switch to the next tempo. i.e.

    [(percentage:50), (percentage:25), (percentage:25)] ->
       [(percentage:50, until: 50), (percentage:25, until: 75), (percentage:25, until: 100)]

    The user is responsible for the percentage that will add up in the end. It might be above 100 or below it depending on the sum of the "perc"s passed in.

    */
	setUntil = {|voice|
    	voice.inject((percPassed:0, tempos: List []), {|acc, tempo|
    		var until = acc.percPassed+tempo.percentage;
    		(
    			percPassed: until,
    			tempos: acc.tempos.add((
    				percentage: tempo.percentage,
    				tempo: tempo.tempo,
    				until: until
    			))
    		)
    	}).tempos
    },

	setUntilForDurs = {|durs, totalDur|
		durs.inject((elapsed: 0, durs: List []), {|acc, dur|
			acc.elapsed = acc.elapsed + dur;
			acc.durs.add((val: dur, until: getPercOf.(acc.elapsed, totalDur)));
			acc;
		}).durs
	},

    /**
    rotate :: [a] -> [[a]]

    Generates the various "permutations" for the tempos for each voice i.e.:
    [(t: 1), (t: 2), (t: 3)] -> [
        [(t: 3), (t: 1), (t: 2)],
        [(t: 2), (t: 3), (t: 1)],
        [(t: 1), (t: 2), (t: 3)]
    ]

    Notice how tempos are distributed veritcally and horizontally, as a Sudoku, this allows for an easy combination of tempos.

    Notice also that fo clairty we are ommiting the "perc" property in the example above.
    */

	rotate = {|arr|
    	(0..arr.size - 1)
    	  .inject(List [], {|acc, i|
    	     if(i=== 0 ,
    			{acc.add(arr.rotate)},
    			{acc.add(acc[i-1].rotate)}
    		)
    	}).collect(setUntil)
    },


    findFirst = {|pred, arr|
    	arr.inject(nil, {|acc, el|
    		if(acc === nil,
    			{if(pred.(el), {el}, {nil})},
    			{acc});
    	});
    },

    findCurrentTempo = {|percElapsed, tempos|
    	findFirst.({|tempo| tempo.until > percElapsed}, tempos)
    },

    getPercOf = {|part, total|
    	part/total*100
    },

    getFromPercentage = {|perc, total|
        perc*total/100
    },

	getNextTempos = {|currentlyElapsed/*percentage*/, durUntil/*percentage*/, tempos|
	    var first = tempos.detectIndex(_.until >= currentlyElapsed);
	    var last =  tempos.detectIndex(_.until >= durUntil);
	    tempos[first..last];
    },

    processDurationsForVoice = {|totalDur, durs, voiceTempos|
		durs.inject((elapsed: 0, durs: List []), {|acc, dur|
			var finalElapsed = acc.elapsed+dur.val;
			var getElapsedPerc = getPercOf.(_, totalDur);
			var initialPerc = getElapsedPerc.(acc.elapsed);
			var finalPerc = getElapsedPerc.(finalElapsed);
			var percSpan = finalPerc - initialPerc;
			var tempos = getNextTempos.(initialPerc, finalPerc, voiceTempos);
			var nextDur = tempos.inject((elapsed: acc.elapsed ,totalDur: 0, durLeft: dur.val), {|acc2, tempo|
				if(dur.until <= tempo.until,
					{
						(
							totalDur: acc2.totalDur + (acc2.durLeft*tempo.tempo),
							durLeft: 0,
							elapsed: acc2.elapsed+acc2.durLeft

						)
					},
					{//dur.until > tempo.until
						var elapsedPerc2 = getElapsedPerc.(acc2.elapsed);
						var percentageElapsed = getPercOf.(tempo.until - elapsedPerc2, percSpan);
						var durUsed = getFromPercentage.(dur.val, percentageElapsed);
						var durOnTempo = durUsed*tempo.tempo;
						(
							durLeft: (acc2.durLeft - durUsed),
							totalDur: acc2.totalDur+durOnTempo,
							elapsed: (acc2.elapsed+durUsed);
						);
					}
				);
			});

			(
				elapsed: nextDur.elapsed,
				durs: acc.durs.add(nextDur.totalDur)
			)
		});
	},

    processDurations = {|rotations, dur_arr, totalDur|
    	rotations.collect(processDurationsForVoice.(totalDur,dur_arr, _))
    },

	//initAndLast :: [a] -> (init:[a], last: a)
	initAndLast = {|arr| (init: arr[..arr.size -2], last: arr[arr.size - 1])},
	durations_ = initAndLast.(data.melody.collect(_.dur)),//we do this so that the last note of each voice will fall in unison with the rest
	notes = data.melody.collect(_.note),
    convertTemposToPropotions = {|tempos|
        var sorted = tempos.sort({|a, b| a.tempo < b.tempo});
        var first = sorted[0];
        sorted.collect({|t| (tempo: t.tempo/first.tempo, percentage: t.percentage)})
    },
	rotations = rotate.(convertTemposToPropotions.(data.tempos)),
	toSeconds = {|tempo, propotion| 60*propotion/tempo},
	totalDur = durations_.init.sum,
	durations = processDurations.(rotations, setUntilForDurs.(durations_.init, totalDur), totalDur)
	    .collect(_.durs)
	    .collect(_.collect(toSeconds.(data.baseTempo, _))),
	canon = durations.collect({|voiceDurs, i|
		(
			notes: data.voices[i].transp+notes,
			durs: voiceDurs++[durations_.last],
			onset: 0,
			bcp: 0,
			amp: data.voices[i].amp,
			cp: 0
		)
	});
	(
		canon: canon,
		data: (
			voices: data.tempos
		)
	);
};
~divCanon = {|data|
	if(data.voices.size != data.tempos.size,
		{"divCanon requires that arguments \"voices\" and \"tempos\" should be arrays of the same size.".throw},
		{divCanon.(data)}
	)

};
)

