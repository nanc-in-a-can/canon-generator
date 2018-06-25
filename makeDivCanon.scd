(
//data must be an Event object with the following keys
//(
// baseTempo: Float,
// transps: [Int], // Array of transpositions, should equal in size the tempos array
// melody: [(dur: Float, note: midiNote)], // Array of Event objects with note and duration
// tempos: [(t: Float, percentage: Int)], //Array of Event objects with tempo proportion (t) and the percentage of time it should occupy in the melody. The user is responsible for the percentage that will add up in the end. It might be above 100 or below it depending on the sum of the "perc"s passed in.
//)
~makeDivCanon = {|data|
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
    				t: tempo.t,
    				until: until
    			))
    		)
    	}).tempos
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

    processDurationsForVoice = {|totalDur, durs, voiceTempos|
    	durs.inject((elapsed: 0, durs: List []), {|acc, dur|
    		var
                currentTempo = findCurrentTempo.(getPercOf.(acc.elapsed, totalDur) ,voiceTempos),
                nextTempo = findCurrentTempo.(getPercOf.(acc.elapsed + dur, totalDur) ,voiceTempos) ? currentTempo,
                nextElapsed = getPercOf.(acc.elapsed+dur, totalDur),
                durationAfterTempoChange_ = acc.elapsed+dur - getFromPercentage.(currentTempo.until, totalDur),
                durationAfterTempoChange = if(durationAfterTempoChange_ > 0, {durationAfterTempoChange_}, {0}),
                durationBeforeTempoChange = dur - durationAfterTempoChange,
                duration = (durationBeforeTempoChange*currentTempo.t) + (durationAfterTempoChange*nextTempo.t);
    		(
    			elapsed: acc.elapsed+(dur),
    			durs: acc.durs.add(duration)
    		)
    	});
    },

    getTotalDur = {|voice, durs|
    	voice.collect({|tempo|
    		durs.sum*tempo.percentage/100*tempo.t
    	})
    },


    processDurations = {|rotations, dur_arr|
    	var totalDur = dur_arr.sum;
    	rotations.collect(processDurationsForVoice.(totalDur,dur_arr, _))
    },

	//initAndLast :: [a] -> (init:[a], last: a)
	initAndLast = {|arr| (init: arr[..arr.size -2], last: arr[arr.size - 1])},
	durations_ = initAndLast.(data.melody.collect(_.dur)),
	notes = data.melody.collect(_.note),
	rotations = rotate.(data.tempos),
	toSeconds = {|tempo, propotion| 60*propotion/tempo},
	durations = processDurations.(rotations, durations_.init)
	    .collect(_.durs)
	    .collect(_.collect(toSeconds.(data.baseTempo, _))),
	canon = durations.collect({|voiceDurs, i|
		(
			notes: data.transps[i]+notes,
			durs: voiceDurs++[durations_.last],
			onset: 0,
			bcp: 0,
			cp: 0
		)
	}),

    tests = {
        var r1, r2;// rotations for each test
        var test1, test2; //tests
        //TEST
        r = rotate.([(t:1, percentage:25), (t:2, percentage:25), (t:3, percentage:25), (t:4, percentage:25)]); //rotations

        test1 = processDurations.(
            r,
            [//each line is a 25% of the duration
                3,
                1,1,1,
                1,2,
                2,1
            ]
        ).collect(_.durs).collect(_.asArray);
        ("TEST 1 Passes:" + (test1.collect(_.sum) == [ 30, 30, 30, 30 ])).postln;
        /*
        "Order of tempos".postln;
        r.collect(_.collect(_.t)).do(_.postln);

        "Durations arrays for each voice:".postln;
        test.do(_.postln);

        "Durations of each part shoulde be equal".postln;
        test.collect(_.sum).postln;
        */

        //TEST 2 Works with percentages that do not divide evenly the durations
        r2 = rotate.([(t:1, percentage:10), (t:2, percentage:32), (t:3, percentage:28), (t:4, percentage:30)]); //rotations

        test2 = processDurations.(
        	r2,
        	[//each line is a 25% of the duration
        		3,
        		1,1,1,
        		1,2,
        		2,1
        	]
        ).collect(_.durs).collect(_.asArray);
        ("TEST 2 Passes:" + (test2.collect(_.sum) == [ 33.36, 33.36, 33.36, 33.36 ])).postln;
        /*
        "Order of tempos".postln;
        r2.collect(_.collect(_.t)).do(_.postln);

        "Durations arrays for each voice:".postln;
        test2.do(_.postln);

        "Durations of each part shoulde be equal".postln;
        test2.collect(_.sum).postln;
        */
    };

	// tests.()// run tests
	(
		canon: canon,
		data: (
			voices: [ ( 'transp': 0, 'tempo': 60 ), ( 'transp': -12, 'tempo': 65 ), ( 'transp': 12, 'tempo': 57 ), ( 'transp': 8, 'tempo': 63 ) ] // TODO ARREGLAR ESTO!!!!!!!!!!!!!!!!!!!!!
		)
	);
};
~makeDivCanon.((
	baseTempo: 60,
	transps: [1, 2, 3],
	tempos: [(t: 3, percentage: 30), (t: 5, percentage: 30), (t: 2, percentage: 40)],
	melody: [(dur: 1, note: 60), (dur: 2, note: 61), (dur: 3, note: 62), (dur: 4, note: 63)]
));
)
