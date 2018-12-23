+Can {
	*registerDefaultSynthDefs {
		SynthDef(\pianola,
			{ |freq=1.0, decayTime=0.5, amp=0.75, temp=100, out=0, done=2, pan=0, att=0.001, sus=0.1, rel=0.1, object=0.005, which=0|
				var sig, env, strike, envAttack, noise, delayTime, deTune;


				strike= Trig.ar(Impulse.ar((freq.asFloat)/temp),0.0001);
				envAttack= Decay2.ar(strike, 0.008, 0.03);
				noise= Mix(LFNoise2.ar([375,750,1500,3000], envAttack));

				sig= Mix(Array.fill(4,{|i|
					deTune= #[-0.05,0.01,0.04,-0.01].at(i);
					delayTime= 1/((freq.asFloat)+deTune);

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

		SynthDef(\portamento, {|
			freq = 400,
			portamento = 0,
			portamento_amp = 0.3,
			portamento_amp_speed = 0.3,
			amp = 0.3,
			gate=1
			|
			var sig = {
				SinOsc.ar(Lag.kr(freq, portamento), 0, Lag.kr(portamento_amp, portamento_amp_speed)) * EnvGen.kr(Env.asr(0.1, amp, 1.3), gate, doneAction:2)
			} ;
			Out.ar(0, sig ! 2);
		}).add;

	}
}


/*SynthDef(\blipo, {|out, freq=60, amp=0.003, ampC, att=0.2, dur, sus=1, rel, nharm=1, dtime|
	var sig, env, comv;
	amp = amp * AmpCompA.kr(freq);
	ampC = Select.kr(freq> (65.midicps), [0.01, 0.08]);
	dtime = Select.kr(freq> (50.midicps), [freq*1.77, freq * 0.67]);
	sus = dur * sus;
	att = att*sus;
	rel = rel*sus;
	rel = Select.kr(dur>0.47, [0.2, 1.4]);
	nharm = Select.kr(freq>(60.midicps), [{rrand(6, 9)}, {rrand(7,19)}]);
	sig = Blip.ar(freq, nharm);
	comv = CombC.ar(sig, 0.2, dtime.reciprocal, dur, ampC);
	env =	EnvGen.kr(Env.perc(0.01, rel), doneAction:2);
	sig = Mix.new([sig, comv]);
	sig= sig * env;
	// sig = Pan2.ar(sig, pan, amp);
	sig = Spreader.ar(sig)*amp;
	OffsetOut.ar(out, Limiter.ar(sig, 0.1));//1, 2
}).add;*/
