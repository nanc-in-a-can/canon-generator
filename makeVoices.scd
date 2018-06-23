// float / [float] -> string -> [float] -> [(tempo: float), (transp: float)]

// answers tempos that will be equivalent to either arbitrary tempos or to the proportional tempos in the first array, the second array contains transposition values added in the argument transp (midi), if transp == nil then the transp values are taken from the tempo;


~voicesFunc= { | tempo, proportions="1", transp|

	var baseTempo= tempo;

	var propsTe= baseTempo*proportions.split($:).asFloat;

	var tempoToTransp= if(transp== nil, {if( proportions == 1, { baseTempo.cpsmidi}, {propsTe.cpsmidi})}, {transp});

	if(proportions != "1"  && baseTempo.isArray, {"inconsistent tempos declared, tempos may be weird".warn});

	if( baseTempo.isArray && baseTempo.size == 1, {"inconsistent tempos declared, tempos may be weird".warn});


	if( proportions.asFloat == 1, {
	[baseTempo.size, baseTempo.size].minItem.collect({|i|
        (tempo: baseTempo[i], transp: tempoToTransp[i])
    })
	},
	{
	[propsTe.size, propsTe.size].minItem.collect({|i|
        (tempo: propsTe[i], transp: tempoToTransp[i])
    })
	}
	);


}


// try me
~voicesFunc.(tempo: [ 180, 240, 300, 360 ]);
// just arbitrary tempo, automatically generates transp with harmonic rhythm principle
~voicesFunc.(tempo: 60, proportions: "3:4:5:6");
// tempi generated proportionally, automatically generates transp with harmonic rhythm principle
~voicesFunc.(tempo: 60, proportions: "3:4:5:6", transp: [12, 24, -12, -15]);
// tempi generated proportionally, transposition values generated arbitrarily
~voicesFunc.(tempo: [ 180, 240, 300, 360 ], transp: [12, 24, -12, -15]);
// tempo and transposition generated arbitrarily


"1".asFloat


