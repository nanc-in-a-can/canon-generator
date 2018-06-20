// symbol -> float -> string -> [float]

// answers tempos that will be equivalent to either arbitrary tempos or to the proportional tempos;

// always answers whole notes, quarter = 60 bpm the function answers 15, half = 60 bpm the function answers 30, etc.

~funcTempo= { | tempo, proportions="1"|

	var tempoPerFigure= tempo;

	var props= tempoPerFigure*proportions.split($:).asFloat;

	if(proportions != "1"  && tempo.isArray, {"inconsistent tempos declared, tempos may be weird".warn});

	if( tempo.isArray && tempo.size == 1, {"inconsistent tempos declared, tempos may be weird".warn});


	if( proportions == 1, {tempoPerFigure},
		{props});

}


// try me
//~funcTempo.(tempo: [ 180, 240, 300, 360 ]);
//~funcTempo.(tempo: 60, proportions: "3:4:5:6");


// falta establecer: funcion para transponer de manera arbitraria, con intervalos tipo "2:3:7" o traduciendo tempo a freq;

