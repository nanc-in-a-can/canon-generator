// float -> string -> [[float], [float]]

// answers tempos that will be equivalent to either arbitrary tempos or to the proportional tempos in the first array, the second array contains transposition values added in the argument transp (midi), if transp == nil then the transp values are taken from the tempo;


~tempoFunc= { | tempo, proportions="1", transp|

	var baseTempo= tempo;

	var propsTe= baseTempo*proportions.split($:).asFloat;

	var tempoToTransp= if(transp== nil, {if( proportions == 1, { baseTempo.cpsmidi}, {propsTe.cpsmidi})}, {transp});

	if(proportions != "1"  && baseTempo.isArray, {"inconsistent tempos declared, tempos may be weird".warn});

	if( baseTempo.isArray && baseTempo.size == 1, {"inconsistent tempos declared, tempos may be weird".warn});


	if( proportions == 1, {[baseTempo, tempoToTransp]},
		{[propsTe, tempoToTransp]});


}


// try me
//~tempoFunc.(tempo: [ 180, 240, 300, 360 ]);
//~tempoFunc.(tempo: 60, proportions: "3:4:5:6");
//~tempoFunc.(tempo: 60, proportions: "3:4:5:6", transp: [12, 24, -12, -15]);






