
// ~visualize.(~makeCanon.(~melodyMaker.simple4NoteMelody(3)));
// ~visualize.(~canon);
(
~withChords = ~convCanon.((
 cp: 3,
 melody: [(dur: 1/4, note: [60, 80]), (dur: 1/5, note: 50),
     (dur: 1/2, note: \rest), (dur: 1/2, note: \rest),
 (dur: 2/3, note: [60,70,80]), (dur: 1/4, note: 60)],

 voices: [(tempo: 55, transp: 4), (tempo: 51, transp: 1)]
));

~mySound = {|line, index|
 Pbind(
     \instrument, \pianola,
     \dur, Pseq([line.onset.postln] ++ line.durs, 1),
     \freq, Pseq([\rest]++line.notes,inf),
     \out, [0, ~reverbBus.index],
     \amp, 1,
     \pan, 0,
     /*this series will provide an Index for later processes*/
     \series, Pseries(0,1,inf),
     /*messages to change the point positions in the map below*/
     \coordinates, Pfunc({|event|
         NetAddr("127.0.0.1", 57120).sendBundle(s.latency, [("/event"++index), event[\freq], event[\series], event[\dur]])
     })
 )
};

// ~withChords.canon.collect(~mySound).do(_.play);
~visualize.(~withChords);
)