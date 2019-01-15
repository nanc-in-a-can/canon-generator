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
  Can.defaultServerConfig
  Can.registerDefaultSynthDefs
  s.boot
  ThePresetCan.pyramidCanon.play
)

```

Sound and Visualization:

```supercollider
(
  Can.defaultServerConfig
  Can.registerDefaultSynthDefs
  s.boot
  ThePresetCan.pyramidCanon.visualize(s)
)
```

## Basic examples

### Convergence Canon

```supercollider
(
Can.converge(\pachelbel
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
		durs: (1/3!4)++(1/8!4),
		notes: ([62, 57, 59, 54, 55, 50, 55, 57]!2).flatten.rotate(1)
	),
	voices: Can.divoices(
		transps: [0, 0, 5, 7]
	),
	tempos: Can.divtempos(
		tempos: [2, 1, 3, 5],
		percentageForTempo: [2, 3, 5, 5],
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
