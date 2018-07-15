(
var makeDivCanonnn = {
	var myDivVoices = ~makeDivVoices.(Array.geom(5, 1, 2.2), (0.2!5));
	var myDivTempo= ~makeDivTempos.(
		(6..10),
		(2, 5..15).scramble,
		normalize: true
	);
	var myAlgoMelody= ~makeMelody.(
		Array.fill(35, { [4, 8, 16].wchoose([0.2, 0.3, 0.5].normalizeSum).reciprocal }),
		Array.fill(35, { [60, 67,[38, 72], 68, 63, 63.5].wchoose([6, 4, 3, 2, 1, 1].normalizeSum) } )
	);
	(
		baseTempo: 15,
		voices: myDivVoices,
		tempos: myDivTempo,
		melody: myAlgoMelody
	)
};

var allEqual = {|arr|
	arr.inject(List [], {|acc, el|
		acc.add(arr[0] == el);
	})
	.inject(true, {|acc, el| acc && el})
};

100.collect({
	~divCanon.(makeDivCanonnn.()).canon
	.collect(_.durs)
	.collect(_.sum)
	.collect(_.asFloat)
	.collect(_.asStringPrec(8))
	.pipe(allEqual)
	.postln;
}).pipe(allEqual)
)
