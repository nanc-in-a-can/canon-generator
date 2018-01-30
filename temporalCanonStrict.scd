(
~makeCanon = {|data|

var line1, line2, line3, line4, tp, tempo1, tempo2, tempo3, tempo4, rhythm, timeSpan, cp, bcp1, bcp2, bcp3, bcp4, patt1, patt2, patt3, patt4, hiVal, onset, voice, melody1, melody2, melody3, melody4, cP1, cP2, cP3, cP4, voice_data, melody_data, write_t, arreglo_data;

tp= data.tp;
bcp1= data.bcp1;
bcp2= data.bcp2;
bcp3= data.bcp3;
bcp4= data.bcp4;
line1= data.line1;
line2= data.line2;
line3= data.line3;
line4= data.line4;
melody1= data.melody1;
melody2= data.melody2;
melody3= data.melody3;
melody4= data.melody4;


//con esto podemos eventualmente arribar a una generalización del algoritmo para cualquier número de voces
~sortedBySpeed = [
	[line1, melody1, bcp1.sum],
	[line2, melody2, bcp2.sum],
	[line3, melody3, bcp3.sum],
	[line4, melody4, bcp4.sum]
].sort({|line_a, line_b| line_a[0].sum < line_b[0].sum });

melody_data= ~sortedBySpeed.collect({|l_p| l_p[1]});

voice_data = ~sortedBySpeed.collect({|l_p| l_p[0]});

//con esto podemos quitar la declaración de los patterns de allá arriba y reducirla a una función que los genere
~makePatt = {|line_melody_pair, index|
	var pan = (index/~sortedBySpeed.size*2 - 1) + (1/~sortedBySpeed.size);//distributes voices evenly across the stereo field, but it avoids the extreme positions (-1 and 1)
	var line  = line_melody_pair[0];
	var melody  = line_melody_pair[1];
	Pbind(
		\instrument, \piano,
		\pan, pan,
		\dur, Pseq(line,1),
		\freq, Pseq(melody,inf),
		\out, 10,
		\amp, 1

	);
};

	voice  = ~sortedBySpeed.collect(~makePatt);

	~onsets = ~sortedBySpeed.reverse.inject([], {|acc, elem|
		acc ++ [(~sortedBySpeed.reverse[0][2] - elem[2]).abs];
	});

	~distances1= ~onsets[0];
	~distances2= ~onsets[1];
	~distances3= ~onsets[2];
	~distances4= ~onsets[3];


	Pdef(\four_v_temporalCanon_v2, Ptpar(
		[~onsets, voice.reverse].lace(voice.size * 2)
	)).quant([0]);

/*
 write to a pdf file the canon's data
write_t = File("~/convergence_canon_data.txt".standardizePath,"w");

arreglo_data= [rhythm.asFraction.asCompileString++ "\n" ++ ((melody1+12)++cP1++(melody1.reverse+ 8)).asCompileString++ "\n" ++ ((melody2-12)++cP2++(melody2.reverse   )).asCompileString++ "\n"++ ((melody3   )++cP3++(melody3.reverse-12)).asCompileString++ "\n"++((melody4+ 8)++cP4++(melody4.reverse+12)).asCompileString].asCompileString;

write_t.write(arreglo_data);
write_t.close;
*/

};

)

