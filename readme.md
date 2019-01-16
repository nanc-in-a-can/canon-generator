# Nanc-in-a-can Canon Generator

<p align="center">
   <img width="100%" src="nanc-in-a-can.jpg">
</p>

## Installation

### Using git

`git clone https://github.com/nanc-in-a-can/canon-generator.git nanc-in-a-can`

Ths will clone the proyect into `<your-current-path>/nanc-in-a-can`

### Manual download

[Click here](https://github.com/nanc-in-a-can/canon-generator/archive/master.zip) and save the zip file wherever you want.

## Preset examples

Sound Only:

```supercollider
(
  Can.defaultServerConfig;
  Can.registerDefaultSynthDefs;
  s.boot;
  ThePresetCan.pyramidCanon.play;
)

```

Sound and Visualization:

```supercollider
(
  Can.defaultServerConfig;
  Can.registerDefaultSynthDefs;
  s.boot;
  ThePresetCan.pyramidCanon.visualize(s);
)
```

## Basic examples

### Convergence Canon

```supercollider
(
Can.converge(\pachelbel,
	melody: Can.melody(
		durs: (1/4!8),
		notes: [62, 57, 59, 54, 55, 50, 55, 57]
	),
	cp: 6,
	voices: Can.convoices(
		tempos: [50, 50*3/2, 50*4/3, 50*5/4],
		transps: [0, -12, 12, 7]
	),
	repeat: inf
).play;
)
```

### Divergence Canon

```supercollider
(
Can.diverge(\pachelbel,
	repeat: inf,
	instruments: [\pianola],
	melody: Can.melody(
		durs: (1/3!4)++(1/18!4)++(1/9!4),
		notes: ([62, 57, 59, 54, 55, 50, 55, 57]!3).flatten.rotate(4)
	),
	voices: Can.divoices(
		transps: [0, 0, 5, 7, 10]
	),
	tempos: Can.divtempos(
		tempos: [2, 1, 3, 5, 1],
		percentageForTempo: [2, 3, 5, 5, 1],
		normalize: true
	),
	baseTempo: 120
).play
)
```

### Visualization

```supercollider
(
Can.converge(\pachelbel,
  melody: Can.melody(
    durs: (1/4!8),
    notes: [62, 57, 59, 54, 55, 50, 55, 57]
  ),
    cp: 6,
    voices: Can.convoices(
      tempos: [50, 50*3/2, 50*4/3, 50*5/4],
      transps: [0, -12, 12, 7]
    ),
    repeat: inf
).visualize(s);
)
```

## OSC

Default OSC behviour has been implemented for the default player.

```
s.boot
Can.defaultServerConfig
Can.registerDefaultSynthDefs
o = OSCFunc(_.postln, \canosc, recvPort: 7777);
~osc  = (net: NetAddr("localhost", 7777), send: [\dur, \midinote]);
(
Can.converge(\can,
  melody: Can.melody(
    durs: [1, 1/5],
    notes: [56, 58]
  ),
  cp: 2,
  voices: Can.convoices(
    tempos: [90, 120],
    transps: [0, 1]
  ),
  osc: ~osc
).play
)

(
Can.diverge(\divergre,
  melody: Can.melody(
    durs: [1, 1/5, 5],
    notes: [56, 58, 70]
  ),
  voices: Can.divoices(
    transps: [1,2]
  ),
  tempos: Can.divtempos(
    tempos: [60, 70],
    percentageForTempo: [40, 60]
  ),
  osc: ~osc
).play
)
```
