~makeCanon = {

var line1, line2, line3, line4, tp, tempo1, tempo2, tempo3, tempo4, rhythm, timeSpan, cp, bcp1, bcp2, bcp3, bcp4, patt1, patt2, patt3, patt4, hiVal, onset, voice, melody1, melody2, melody3, melody4, cP1, cP2, cP3, cP4, voice_data, melody_data, write_t, arreglo_data;

// number of beats (timepoints in the structure)
tp= 300; // -1 ;
~tp= tp;

~makeTempo = {|speed| 60/(speed/4)};

tempo1= ~makeTempo.(60);  /*change the tempo here, declare the value of a 1/4 figure*/
tempo2= ~makeTempo.(65);  /*change the tempo here, declare the value of a 1/4 figure*/
tempo3= ~makeTempo.(57);  /*change the tempo here, declare the value of a 1/4 figure*/
tempo4= ~makeTempo.(63);  /*change the tempo here, declare the value of a 1/4 figure*/


timeSpan= [(1),(1/4),(1/6),  (1/8),(1/9),(1/10),(1/11),(1/12),(1/13),(1/14),(1/15),(1/16),(1/17),(1/18),(1/19),  (1/20),(1/24),(1/32)];

// choose a position for each rhythmic value throughout a weighted randomised process

// choose a position for each rhythmic value throughout a weighted randomised process
rhythm = tp.collect({ timeSpan.wchoose([1,5,4, 10,5,8,5,8,5,6,5,10,4,4,4, 8,8,10].normalizeSum) });

line1= rhythm.collect(_*tempo1);
line2= rhythm.collect(_*tempo2);
line3= rhythm.collect(_*tempo3);
line4= rhythm.collect(_*tempo4);

~line1= line1;
~line2= line2;
~line3= line3;
~line4= line4;


// the convergence points, the beat in which the lines will converge. Default is a strict Arch Canon (CP in the middle);
// 300-(300/3)   ;
cp= (tp/2); // aquí podrías cambiar el valor;

~makeBcp = {|line| line.copyRange(0, (line.size - cp - 2).asInteger)};
// the segment of patterns before the convergence point;
bcp1 = ~makeBcp.(line1);
//(Array.fill(line1.size-(line1.size-(cp-1)), {|i| line1[i] }) == bcp1).postln;//verificamos funcionalidad anterior
bcp2 = ~makeBcp.(line2);
bcp3 = ~makeBcp.(line3);
bcp4 = ~makeBcp.(line4);

// melodic patterns for the lines;



melody1= bcp1.collect({[45,46,50,52.5,53,55.2,57,58,60.3,62,63,65.5].wchoose([4,3,8,2,4,2,7,5,2,5,3,3].normalizeSum)});


// pitch values for the CP to emphasis it;
cP1= [70];

// full melodic pattern;

melody1 =  (melody1+12)++cP1++(melody1.reverse)++([melody1[0]]);
melody2 =  melody1 - 12;
melody3 =  melody1 + 12;
melody4 =  melody1 + 8;



~melody1= melody1;
~melody2= melody2;
~melody3= melody3;
~melody4= melody4;


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
makePatt = {|line_melody_pair, index|
	var pan = (index/sortedBySpeed.size*2 - 1) + (1/sortedBySpeed.size);//distributes voices evenly across the stereo field, but it avoids the extreme positions (-1 and 1)
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

}