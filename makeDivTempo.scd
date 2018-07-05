//~makeTempoSwitch ::[Float] -> [Float] -> Bool -> [(tempoRatio, percentageForTempo)]

~makeDivTempo= { | tempoRatio, percentage, norm= false|

	var normPercent_arr= percentage.normalizeSum*100;

	if(norm==true,
		{
			[tempoRatio.size, percentage.size].minItem.collect({|i|
				(tempoRatio: tempoRatio[i], percentage: normPercent_arr[i])
    })
		},

		{
			[tempoRatio.size, percentage.size].minItem.collect({|i|
				(tempoRatio: tempoRatio[i], percentage: percentage[i])
    })

	});

};


// ~makeTempoSwitch.([2, 3, 4, 5], [30, 30, 30, 30], norm: true)
