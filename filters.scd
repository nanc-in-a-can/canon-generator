// filters;

(
// Busses;
~reverbBus= Bus.audio(s, 2);

~otherBus= Bus.audio(s, 2);

~andOtherbBus= Bus.audio(s,2);
);


// filter synths

(
SynthDef(\reverb, {|in= 0, out= 0, gate= 1|
	var sig, env;
	sig= FreeVerb2.ar(In.ar(in), In.ar(in+1), 0.2, 0.3, 0.2);
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;
)