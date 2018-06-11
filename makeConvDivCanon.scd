(
/**

setUntil :: [(perc: Number)] -> [(perc: Number, until: Number)]

Adds an "until" field to tempo, which determines the moment in which the voice should switch to the next tempo. i.e.

[(perc:50), (perc:25), (perc:25)] ->
   [(perc:50, until: 50), (perc:25, until: 75), (perc:25, until: 100)]

The user is responsible for the percentage that will add up in the end. It might be above 100 or below it depending on the sum of the "perc"s passed in.

*/

var setUntil = {|voice|
	voice.inject((percPassed:0, tempos: List []), {|acc, tempo|
		var until = acc.percPassed+tempo.perc;
		(
			percPassed: until,
			tempos: acc.tempos.add((
				perc: tempo.perc,
				t: tempo.t,
				until: until
			))
		)
	}).tempos
};

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

var rotate = {|arr|
	(0..arr.size - 1)
	  .inject(List [], {|acc, i|
	     if(i=== 0 ,
			{acc.add(arr.rotate)},
			{acc.add(acc[i-1].rotate)}
		)
	}).collect(setUntil)
};


var findFirst = {|pred, arr|
	arr.inject(nil, {|acc, el|
		if(acc === nil,
			{if(pred.(el), {el}, {nil})},
			{acc});
	});
};

var findCurrentTempo = {|percElapsed, tempos|
	findFirst.({|tempo| tempo.until > percElapsed}, tempos)
};

var getPercOf = {|part, total|
	part/total*100
};

var getFromPercentage = {|perc, total|
    perc*total/100
};

var processDurationsForVoice = {|totalDur, durs, voiceTempos|
	// ("totalDur" + totalDur ).postln;
	durs.inject((elapsed: 0, durs: List []), {|acc, dur|
		var currentTempo = findCurrentTempo.(getPercOf.(acc.elapsed, totalDur) ,voiceTempos);
		var nextTempo = findCurrentTempo.(getPercOf.(acc.elapsed + dur, totalDur) ,voiceTempos) ? currentTempo;
		var nextElapsed = getPercOf.(acc.elapsed+dur, totalDur);
        var durationAfterTempoChange_ = acc.elapsed+dur - getFromPercentage.(currentTempo.until, totalDur);
		var durationAfterTempoChange = if(durationAfterTempoChange_ > 0, {durationAfterTempoChange_}, {0});
		var durationBeforeTempoChange = dur - durationAfterTempoChange;
		var duration = (durationBeforeTempoChange*currentTempo.t) + (durationAfterTempoChange*nextTempo.t);
		// "durations".postln;
		// [dur*currentTempo.t, duration, durationBeforeTempoChange, durationAfterTempoChange].postln;
		(
			elapsed: acc.elapsed+(dur),
			durs: acc.durs.add(duration)
		)
	});
};

var getTotalDur = {|voice, durs|
	voice.collect({|tempo|
		durs.sum*tempo.perc/100*tempo.t
	})
};


var processDurations = {|rotations, dur_arr|
	var totalDur = dur_arr.sum;
	rotations.collect(processDurationsForVoice.(totalDur,dur_arr, _))
};

//TEST
~r = rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)]); //rotations

~test1 = processDurations.(
    ~r,
    [//each line is a 25% of the duration
        3,
        1,1,1,
        1,2,
        2,1
    ]
).collect(_.durs).collect(_.asArray);
("TEST 1 Passes:" + (~test1.collect(_.sum) == [ 30, 30, 30, 30 ])).postln; // Durations of each part should be equal
/*
"Order of tempos".postln;
~r.collect(_.collect(_.t)).do(_.postln);

"Durations arrays for each voice:".postln;
~test.do(_.postln);

"Durations of each part shoulde be equal".postln;
~test.collect(_.sum).postln;
*/

//TEST 2 Works with percentages that do not divide evenly the durations
~r2 = rotate.([(t:1, perc:10), (t:2, perc:32), (t:3, perc:28), (t:4, perc:30)]); //rotations

~test2 = processDurations.(
	~r2,
	[//each line is a 25% of the duration
		3,
		1,1,1,
		1,2,
		2,1
	]
).collect(_.durs).collect(_.asArray);
("TEST 2 Passes:" + (~test2.collect(_.sum) == [ 33.36, 33.36, 33.36, 33.36 ])).postln; // Durations of each part should be equal
/*
"Order of tempos".postln;
~r2.collect(_.collect(_.t)).do(_.postln);

"Durations arrays for each voice:".postln;
~test2.do(_.postln);

"Durations of each part shoulde be equal".postln;
~test2.collect(_.sum).postln;
*/
)


(
// getPercOf :: Number -> Number -> Percentage
var getPercOf = {|part, total|
    part/total*100
};
// getPercOf :: Percentage -> Number -> Number
var getFromPercentage = {|perc, total|
    perc*total/100
};
var total = 10;
var elapsed = 8;
var dur = 1;
var currentTempo = (until: 92, t: 2); //percentage
var nextTempo = (until: 94, t: 1); //percentage
var nextElapsed = getPercOf.(elapsed+dur, total);
var currentElapsed = getPercOf.(elapsed, total).postln;
var durationAfterTempoChange = if(nextElapsed > currentTempo.until,
    {elapsed+dur - getFromPercentage.(currentTempo.until, total)},
    {0}
);
var durationBeforeTempoChange = dur - durationAfterTempoChange;
var duration = durationBeforeTempoChange*currentTempo.t + durationAfterTempoChange*nextTempo.t;
[durationAfterTempoChange, durationBeforeTempoChange].postln;
(
    durs: [1,2,3, duration]
)
.postln;
)
