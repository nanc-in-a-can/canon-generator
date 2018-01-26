(
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.boot;
);

(
(
/*microtonal piano Synth!  the low keys are not quite there yet*/
SynthDef(\piano,
{ |freq=1.0, decayTime=0.5, amp=0.75, temp=100, out=10, done=2, pan=0, att=0.001, sus=0.1, rel=0.1, object=0.005, which=0|
	var sig, env, strike, envAttack, noise, delayTime, deTune;


		strike= Trig.ar(Impulse.ar((freq.asFloat.midicps)/temp),0.0001);
envAttack= Decay2.ar(strike, 0.008, 0.03);
noise= Mix(LFNoise2.ar([375,750,1500,3000], envAttack));

	sig= Mix(Array.fill(4,{|i|
		deTune= #[-0.05,0.01,0.04,-0.01].at(i);
	delayTime= 1/((freq.asFloat.midicps)+deTune);

	CombL.ar(
	noise, delayTime, delayTime, decayTime
			)

	}));
		sig= sig;
		sig= SelectX.ar(which,[sig, CombC.ar(sig, 1, object, 0.3, 1)]);

		env= EnvGen.kr(Env([0,1,1,0],[att,sus,rel]),doneAction: done);

		Out.ar(out, Limiter.ar(Pan2.ar(Mix(sig),pan)*amp,0.1)*env)
};
).add;
);


(
SynthDef(\reverb, {|in=10, out=0, gate=1|
	var sig, env;
	sig= FreeVerb2.ar(In.ar(in), In.ar(in+1), 0.2, 0.3, 0.2);
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add
);
);



(
var line1, line2, line3, line4, tp, tempo1, tempo2, tempo3, tempo4, rhythm, timeSpan, cp, bcp1, bcp2, bcp3, bcp4, patt1, patt2, patt3, patt4, hiVal, onset, voice, melody1, melody2, melody3, melody4, cP1, cP2, cP3, cP4, voice_data, melody_data, write_t, arreglo_data;

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

// the patterns with their respective tempi;
patt1= Pbind(\instrument, \piano, \pan, -1,
	\dur, Pseq(line1,1),
	\freq, Pseq(melody1,inf),
	\out, 10, \amp, 1);

patt2= Pbind(\instrument, \piano, \pan,-0.5,
	\dur, Pseq(line2,1),
	\freq, Pseq(melody2,inf),
	\out, 10, \amp, 1);

patt3= Pbind(\instrument, \piano, \pan, 0.5,
	\dur, Pseq(line3,1),
	\freq, Pseq(melody3,inf),
	\out, 10, \amp, 1);

patt4= Pbind(\instrument, \piano, \pan,  1,
	\dur, Pseq(line4,1),
	\freq, Pseq(melody4,inf),
	\out, 10, \amp, 1);


hiVal= [line1.sum, line2.sum, line3.sum, line4.sum].sort;


voice_data= Array.fill(hiVal.size, {|i| if(hiVal[i]==line1.sum, {line1},{ if( hiVal[i]==line2.sum, {line2},{ if(hiVal[i]==line3.sum, {line3}, { line4 }) } ) }) });

melody_data= Array.fill(hiVal.size, {|i| if(hiVal[i]==line1.sum, {melody1},{ if( hiVal[i]==line2.sum, {melody2},{ if(hiVal[i]==line3.sum, {melody3}, { melody4 }) } ) }) });

// hiVal.size.postln;
/*line2.sum.postln;
line4.sum.postln;
line1.sum.postln;
line3.sum.postln;*/
//We add the each voice in sorted from shortest to longest
voice= Array.fill(hiVal.size, {|i|
	if(hiVal[i]==line1.sum,
		{"pat1".postln;patt1},
		{if(hiVal[i]==line2.sum,
			{"pat2".postln;patt2},
			{ if(hiVal[i]==line3.sum,
				{"pat3".postln;patt3},
				{ "pat4".postln;patt4 }
			)}
		)}
	)
});

//podemos sustituir los algoritmos anteriores por algo usando sort como funcion [2,1,3].sort({|a, b| a < b})
//con esto podemos eventualmente arribar a una generalización del algoritmo para cualquier número de voces
~sortedBySpeed = [
	[line1, patt1, melody1],
	[line2, patt2, melody2],
	[line3, patt3, melody3],
	[line4, patt4, melody4]
].sort({|line_a, line_b| line_a[0].sum < line_b[0].sum });

~melody_data_b = ~sortedBySpeed.collect({|l_p| l_p[2]});
{melody_data[0] === ~melody_data_b[0]}.().postln;//test
{melody_data[1] === ~melody_data_b[1]}.().postln;//test
{melody_data[2] === ~melody_data_b[2]}.().postln;//test
{melody_data[3] === ~melody_data_b[3]}.().postln;//test

~voice_data_b = ~sortedBySpeed.collect({|l_p| l_p[0]});
{voice_data[0] === ~voice_data_b[0]}.().postln;//test

~voice_b = ~sortedBySpeed.collect({|l_p| l_p[1]});
{voice[0] === ~voice_b[0]}.().postln;//test

onset= Array.fill(hiVal.size, {|i| if(hiVal[i]==line1.sum, {bcp1.sum},{ if( hiVal[i]==line2.sum, {bcp2.sum},{ if(hiVal[i]==line3.sum, {bcp3.sum}, { bcp4.sum }) } ) }) });

~distances1= (onset[3]-onset[3]).abs;
~distances2= (onset[3]-onset[2]).abs;
~distances3= (onset[3]-onset[1]).abs;
~distances4= (onset[3]-onset[0]).abs;

Pdef(\four_v_temporalCanon, Ptpar(
	[
		(onset[3]-onset[3]).abs,
		voice[3],
		(onset[3]-onset[2]).abs,
		voice[2],
		(onset[3]-onset[1]).abs,
		voice[1],
		(onset[3]-onset[0]).abs,
		voice[0]
])).quant([0]);

/*
 write to a pdf file the canon's data
write_t = File("~/convergence_canon_data.txt".standardizePath,"w");

arreglo_data= [rhythm.asFraction.asCompileString++ "\n" ++ ((melody1+12)++cP1++(melody1.reverse+ 8)).asCompileString++ "\n" ++ ((melody2-12)++cP2++(melody2.reverse   )).asCompileString++ "\n"++ ((melody3   )++cP3++(melody3.reverse-12)).asCompileString++ "\n"++((melody4+ 8)++cP4++(melody4.reverse+12)).asCompileString].asCompileString;

write_t.write(arreglo_data);
write_t.close;
*/

);

(/*play Canon!!*/
// s.record;
~reverb= Synth(\reverb);
Pdef(\four_v_temporalCanon).play;
);

(/*stop Canon*/
Pdef(\four_v_temporalCanon).stop;
~reverb.set(\gate, 0);
);
