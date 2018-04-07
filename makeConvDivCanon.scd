(
var test = false;

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

var processDurationsForVoice = {|totalDur, durs, voiceTempos|

	durs.inject((elapsed: 0, durs: List []), {|acc, dur|
		var currentTempo = findCurrentTempo.(getPercOf.(acc.elapsed, totalDur) ,voiceTempos).t;
		(
			elapsed: acc.elapsed+(dur),
			durs: acc.durs.add(dur*currentTempo)
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


if(test, {
	("rotate: rotates an array once for each element"+ (
		rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)])
		==
		List[ [ ( 'perc': 25, 't': 4 ), ( 'perc': 25, 't': 1 ), ( 'perc': 25, 't': 2 ), ( 'perc': 25, 't': 3 ) ], [ ( 'perc': 25, 't': 3 ), ( 'perc': 25, 't': 4 ), ( 'perc': 25, 't': 1 ), ( 'perc': 25, 't': 2 ) ], [ ( 'perc': 25, 't': 2 ), ( 'perc': 25, 't': 3 ), ( 'perc': 25, 't': 4 ), ( 'perc': 25, 't': 1 ) ], [ ( 'perc': 25, 't': 1 ), ( 'perc': 25, 't': 2 ), ( 'perc': 25, 't': 3 ), ( 'perc': 25, 't': 4 ) ] ]
	))
	// .postln
});

// rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)]);
// ~makeConvDivCanon = {|| nil};

processDurations.(
	rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)]),
	[//each line is a 25% of the duration
		3,
		1,1,1,
		1,2,
		2,1
	]
)
.collect(_.durs).collect(_.sum);

// r = rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)]);
//
// processDurationsForVoice.(
// 	12,
// 	[//each line is a 25% of the duration
// 		3,
// 		1,1,1,
// 		1,2,
// 		2,1
// 	],
// 	r[0]
// ).durs.sum.postln;
//
//
// r = rotate.([(t:1, perc:25), (t:2, perc:25), (t:3, perc:25), (t:4, perc:25)]);
//
// l = [ ( 'perc': 25, 't': 4, 'until': 25 ), ( 'perc': 25, 't': 1, 'until': 50 ), ( 'perc': 25, 't': 2, 'until': 75 ), ( 'perc': 25, 't': 3, 'until': 100 ) ];
//
//
// processDurationsForVoice.(
// 	12,
// 	[//each line is a 25% of the duration
// 		3,
// 		1,1,1,
// 		1,2,
// 		2,1
// 	],
// 	r[1].postln;
// ).durs.sum.postln;


)

(
var voice = [ ( 'perc': 25, 't': 4 ), ( 'perc': 25, 't': 1 ), ( 'perc': 45, 't': 2 ), ( 'perc': 5, 't': 3 ) ];

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


rotate.(voice).do({|v| v.postln});
)


(
var getPercOf = {|part, total|
	part/total*100
};

getPercOf.(25, 100);
)





(

//aka tempos
var voice = [ ( 'perc': 25, 't': 1, until: 25 ), ( 'perc': 25, 't': 2, until: 50 ), ( 'perc': 45, 't': 3, until: 75 ), ( 'perc': 5, 't': 4, until: 100 ) ];

var durs = [//each line is a 25% of the duration
	3,
	1,1,1,
	1,2,
	2,1
];


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

var processDurationsForVoice = {|durs, voiceTempos|
	var total = durs.sum;
	durs.inject((elapsed: 0, durs: List []), {|acc, dur|
		(
			elapsed: acc.elapsed+dur,
			durs: acc.durs.add(dur*findCurrentTempo.(getPercOf.(acc.elapsed, total) ,voiceTempos).t)
		)
	});
};

processDurationsForVoice.(durs, voice);

// findFirst.({|el| el < 3 && el > 1}, [1,2,3,4], );

// findCurrentTempo.(getPercOf.(4, durs.sum), voice);
// getPercOf.(3, durs.sum);
durs.sum
)


(
var voice = [ ( 'perc': 25, 't': 1, until: 25 ), ( 'perc': 25, 't': 2, until: 50 ), ( 'perc': 25, 't': 3, until: 75 ), ( 'perc': 25, 't': 4, until: 100 ) ];

var durs = [//each line is a 25% of the duration
	3,
	1,1,1,
	1,2,
	2,1
];

var getTotalDur = {|voice, durs|
	voice.collect({|tempo|
		durs.sum*tempo.perc/100*tempo.t
	}).sum
};

getTotalDur.(voice, durs);


)


(

var getPercOf = {|part, total|
	part/total*100
};
[1,2,3,4].collect(_*3).collect(getPercOf.(_, 30))
)

