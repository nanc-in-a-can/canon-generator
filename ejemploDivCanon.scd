(
(
~myDivVoices=

~makeDivVoices.(
	Array.geom(5, 1, 2.2), (0.2!5)
);
);

(
~myDivTempo=

~makeDivTempos.(
		(6..10),

		(2, 5..15).scramble,

		normalize: true)
);
// ~myDivTempo.postln;

(
~myAlgoMelody=

~makeMelody.(
	Array.fill(5, { [4, 8, 16].wchoose([0.2, 0.3, 0.5].normalizeSum).reciprocal } )
	,
	Array.fill(5, { [60, 67,[38, 72], 68, 63, 63.5].wchoose([6, 4, 3, 2, 1, 1].normalizeSum) } )
		);

);
//~myAlgoMelody.postln;

(
// ~visualize.(
~configFails = (
	baseTempo: 15,
	voices: ~myDivVoices,
	tempos: ~myDivTempo,

	melody: ~myAlgoMelody
)

// autoScroll: false
// )
);
nil
)


(

var
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
    };

~processDurationsForVoice = {|totalDur, durs, voiceTempos|
	var newDurs = durs.inject((elapsed: 0, durs: List []), {|acc, dur|
		acc.elapsed = acc.elapsed + dur;
		acc.durs.add((val: dur, until: getPercOf.(acc.elapsed, totalDur)));
		acc;
	}).durs;//sacar de aquí porque corre muchas veces
	// voiceTempos.postln;
	"====================new voice".warn;
	// durs.postln;
	newDurs.inject((elapsed: 0, durs: List []), {|acc, dur|
		var finalElapsed = acc.elapsed+dur.val.pipe(~tapWarn.("new dur", _));
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

					).postln
			    },
				{//dur.until > tempo.until
					var elapsedPerc2 = getElapsedPerc.(acc2.elapsed);
					var percentageElapsed = getPercOf.(tempo.until - elapsedPerc2, percSpan).pipe(~log.("percentageElapsed", _));
					var durUsed = getFromPercentage.(dur.val, percentageElapsed);
					var durOnTempo = durUsed*tempo.tempo;
					"sub".postln;
					durUsed.postln;
					(
					    durLeft: (acc2.durLeft - durUsed),
						totalDur: acc2.totalDur+durOnTempo,
						elapsed: (acc2.elapsed+durUsed);
						// elapsed: 1
					).postln;
				}
			);
		});
		// "dur".warn;
		// dur.postln;
		// "elapsed".postln;
		// acc.elapsed.postln;
		// getElapsedPerc.(acc.elapsed).postln;
		// "tempos".postln;
		// tempos.postln;
		// "nextDur".postln;
		// nextDur.postln;
		(
			elapsed: nextDur.elapsed,
			durs: acc.durs.add(nextDur.totalDur)
		)
	})
	// .durs
	// .sum
	// .postln
	;

/*   durs.inject((elapsed: 0, durs: List []), {|acc, dur|
    	var
          currentTempo = findCurrentTempo.(getPercOf.(acc.elapsed, totalDur), voiceTempos),
          nextTempo = findCurrentTempo.(getPercOf.(acc.elapsed + dur, totalDur),voiceTempos) ? currentTempo,
          nextElapsed = getPercOf.(acc.elapsed+dur, totalDur),
          durationAfterTempoChange_ = acc.elapsed+dur - getFromPercentage.(currentTempo.until, totalDur),
          durationAfterTempoChange = if(durationAfterTempoChange_ > 0, {durationAfterTempoChange_}, {0}),
          durationBeforeTempoChange = dur - durationAfterTempoChange,
          duration = (durationBeforeTempoChange*currentTempo.tempo) + (durationAfterTempoChange*nextTempo.tempo);
		(
    		elapsed: acc.elapsed+(dur),
    		durs: acc.durs.add(duration)
    	)
    });*/
};

~divCanon.(~canonConfig).canon
// ~divCanon.(~configFails).canon
.collect(_.durs)
.collect(_.sum)
.postln
.collect(_.asFloat)
.collect(_.asStringPrec(8))
.pipe(~allEqual)
)








~divTempo = ~myDivTempo.postln;
~durs = Array.fill(35, { [4, 8, 16].wchoose([0.2, 0.3, 0.5].normalizeSum).reciprocal } );

(
a = ~rotate.(~divTempo);
b = ~processDurations.(
	a,
    ~durs
).collect(_.durs)
.collect(_.asArray)
.collect(_.sum);

// ~allEqual.(b)
)




(
a = ~rotate.(~divTempo);
b = ~processDurations.(
	a,
    ~durs
).collect(_.durs)
.collect(_.asArray)
.collect(_.sum);

~allEqual.(b)
)

(
// a = ~rotate.(~makeDivTempos.((6..10), (2, 5..15).scramble, normalize: true));
a = ~rotate.([(tempo: 1, percentage: 2), (tempo: 5, percentage: 38), (tempo: 4, percentage: 20), (tempo: 3, percentage: 20), (tempo: 2, percentage: 20),]);
b = ~processDurations.(
	a,
    ~durs
).collect(_.durs)
.collect(_.asArray)
.collect(_.sum);
~allEqual.(b);

)


(
a = ~rotate.([(tempo: 1, percentage: 20), (tempo: 5, percentage: 20), (tempo: 4, percentage: 20), (tempo: 3, percentage: 20), (tempo: 2, percentage: 20),]);
b = ~processDurations.(
	a,
	[1,2,3,4,5, 6, 7,8]
).collect(_.durs)
.collect(_.asArray)
.collect(_.sum);
~allEqual.(b);//false
)




(
a = ~rotate.([(tempo: 1, percentage: 2), (tempo: 5, percentage: 20), (tempo: 4, percentage: 20), (tempo: 3, percentage: 20), (tempo: 2, percentage: 20),]);
b = ~processDurations.(
	a,
	[1,2,3,4,5, 6, 7,8]
).collect(_.durs)
.collect(_.asArray)
.collect(_.sum);
~allEqual.(b);//false
)





(
~allEqual = {|arr|
	arr
	.inject((fst: arr[0], dif: List []), {|acc, el|
		acc.dif.add(acc.fst == el);
		acc;
	})
	.dif
	// .postln
	// .collect(_==0)
	.inject(true, {|acc, el| acc && el})
};
)


20.0172934.asFloat.asStringPrec(8)





(
var tempos = List[ ( 'tempo': 1, 'percentage': 30, 'until': 30 ), ( 'tempo': 1.75, 'percentage': 20, 'until': 50 ), ( 'tempo': 3, 'percentage': 10, 'until': 60 ), ( 'tempo': 7.5, 'percentage': 40, 'until': 100 ) ];
var getNextTempos = {|currentlyElapsed/*percentage*/, durUntil/*percentage*/, tempos|
	var first = tempos.detectIndex(_.until >= currentlyElapsed);
	var last =  tempos.detectIndex(_.until >= durUntil);
	tempos[first..last];
};

getNextTempos.(66, 100, tempos)

)


(
var getPercOf = {|part, total|
    	part/total*100
    };

var span = 20;

getPercOf.(70 - 60, span)
)


2*25/100

~tapWarn = {|msg, x| ("========="++msg).warn;x }
~log = {|msg, x| ("===="++msg+x).postln;x }