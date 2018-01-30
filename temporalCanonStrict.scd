var 
    arreglo_data,
    bcp1, 
    bcp2, 
    bcp3, 
    bcp4, 
    cp, 
    cP1, 
    cP2, 
    cP3, 
    cP4, 
    hiVal, 
    line1, 
    line2, 
    line3, 
    line4, 
    makePatt,
    melody1, 
    melody2, 
    melody3, 
    melody4, 
    melody_data, 
    onsets, 
    patt1, 
    patt2, 
    patt3, 
    patt4, 
    rhythm, 
    sortedBySpeed,
    tempo1, 
    tempo2, 
    tempo3, 
    tempo4, 
    timeSpan, 
    tp, 
    voices, 
    voice_data, 
    write_t;

// number of beats (timepoints in the structure)
tp= 300; // -1 ;
~tp= tp;

// the tempo and timespan

tempo1= 60;  /*change the tempo here, declare the value of a 1/4 figure*/
tempo1= tempo1/4;
tempo1= (60/tempo1);
~tempo1 = tempo1;

tempo2= 65;  /*change the tempo here, declare the value of a 1/4 figure*/
tempo2= tempo2/4;
tempo2= (60/tempo2);
~tempo2 = tempo2;

tempo3= 57;  /*change the tempo here, declare the value of a 1/4 figure*/
tempo3= tempo3/4;
tempo3= (60/tempo3);
~tempo3 = tempo3;

tempo4= 63;  /*change the tempo here, declare the value of a 1/4 figure*/
tempo4= tempo4/4;
tempo4= (60/tempo4);
~tempo4 = tempo4;

timeSpan= [(1),(1/4),(1/6),  (1/8),(1/9),(1/10),(1/11),(1/12),(1/13),(1/14),(1/15),(1/16),(1/17),(1/18),(1/19),  (1/20),(1/24),(1/32)];

// choose a position for each rhythmic value throughout a weighted randomised process
rhythm= Array.fill(tp, { timeSpan.wchoose([1,5,4, 10,5,8,5,8,5,6,5,10,4,4,4, 8,8,10].normalizeSum) });

line1= Array.fill(tp, {|i| rhythm[i]*tempo1});
// line1.postln; asi se imprimen las duraciones;

line2= Array.fill(tp, {|i| rhythm[i]*tempo2});
line3= Array.fill(tp, {|i| rhythm[i]*tempo3});
line4= Array.fill(tp, {|i| rhythm[i]*tempo4});


~line1= line1;
~line2= line2;
~line3= line3;
~line4= line4;


// the convergence points, the beat in which the lines will converge. Default is a strict Arch Canon (CP in the middle);
// 300-(300/3)   ;
cp= (tp/2); // aquí podrías cambiar el valor;

// the segment of patterns before the convergence point;
bcp1= Array.fill(line1.size-(line1.size-(cp-1)), {|i| line1[i] });
bcp2= Array.fill(line2.size-(line2.size-(cp-1)), {|i| line2[i] });
bcp3= Array.fill(line3.size-(line3.size-(cp-1)), {|i| line3[i] });
bcp4= Array.fill(line4.size-(line4.size-(cp-1)), {|i| line4[i] });

// melodic patterns for the lines;


melody1= Array.fill(bcp1.size,{[45,46,50,52.5,53,55.2,57,58,60.3,62,63,65.5].wchoose([4,3,8,2,4,2,7,5,2,5,3,3].normalizeSum)});


melody2= Array.fill(bcp2.size, {|i| melody1[i] });
melody3= Array.fill(bcp3.size, {|i| melody1[i] });
melody4= Array.fill(bcp4.size, {|i| melody1[i] });

// pitch values for the CP to emphasis it;
cP1= [70];
cP2= [74];
cP3= [77];
cP4= [65];

// full melodic pattern;

melody1= (melody1+12)++cP1++(melody1.reverse+8)++([melody1[0]+8]);
melody2= (melody2-12)++cP2++(melody2.reverse)++([melody2[0]]);
melody3=      melody3++cP3++(melody3.reverse-12)++([melody3[0]-12]);
melody4=  (melody4+8)++cP4++(melody4.reverse+12)++([melody4[0]+12]);


~melody1= melody1;
~melody2= melody2;
~melody3= melody3;
~melody4= melody4;

sortedBySpeed = [
	[line1, melody1, bcp1.sum],
	[line2, melody2, bcp2.sum],
	[line3, melody3, bcp3.sum],
	[line4, melody4, bcp4.sum]
].sort({|line_a, line_b| line_a[0].sum < line_b[0].sum });

melody_data = sortedBySpeed.collect({|l_p| l_p[1]});

voice_data = sortedBySpeed.collect({|l_p| l_p[0]});

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

voices = sortedBySpeed.collect(~makePatt);

onsets = sortedBySpeed.reverse.inject([], {|acc, elem|
	acc ++ [(sortedBySpeed.reverse[0][2] - elem[2]).abs];
});

//exports
~melody_data = melody_data;
~voice_data = voice_data;
~onsets = onsets;
~distances1= ~onsets[0];
~distances2= ~onsets[1];
~distances3= ~onsets[2];
~distances4= ~onsets[3];
Pdef(\four_v_temporalCanon_v2, Ptpar(
	[~onsets, voices.reverse].lace(voices.size * 2)
)).quant([0]);

/*
 write to a pdf file the canon's data
write_t = File("~/convergence_canon_data.txt".standardizePath,"w");

arreglo_data= [rhythm.asFraction.asCompileString++ "\n" ++ ((melody1+12)++cP1++(melody1.reverse+ 8)).asCompileString++ "\n" ++ ((melody2-12)++cP2++(melody2.reverse   )).asCompileString++ "\n"++ ((melody3   )++cP3++(melody3.reverse-12)).asCompileString++ "\n"++((melody4+ 8)++cP4++(melody4.reverse+12)).asCompileString].asCompileString;

write_t.write(arreglo_data);
write_t.close;
*/

