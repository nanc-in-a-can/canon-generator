# Nanc-in-a-can Canon Generator <!-- omit in toc -->

<p align="center">
   <img width="100%" src="nanc-in-a-can.jpg">
</p>

- [Installation](#Installation)
	- [Manual download](#Manual-download)
	- [Updating the library](#Updating-the-library)
- [Nanc-In-A-Can Canon Generator](#Nanc-In-A-Can-Canon-Generator)
	- [Temporal Canons](#Temporal-Canons)
- [Preset examples](#Preset-examples)
- [Basic examples](#Basic-examples)
	- [Convergence Canon](#Convergence-Canon)
	- [Divergence Canon](#Divergence-Canon)
	- [Visualization](#Visualization)
- [Nicer examples](#Nicer-examples)
- [Symbol, Period and Meta](#Symbol-Period-and-Meta)
- [Isomelody and Functions as arguments](#Isomelody-and-Functions-as-arguments)
- [OSC](#OSC)


## Installation

`Nanc-in-a-Can` provides a set of classes, and thus the need to be installed in specific folder to be available.

If you have `git` installed (highly recommended, https://git-scm.com/downloads), the easiest way to install this software is by compiling this line in the SuperCollider IDE:

```
Quarks.install("https://github.com/nanc-in-a-can/canon-generator.git");
```

Then you need to recompile the class library. In the menu bar: `Language > Recompile Class Library`


### Manual download
Otherwise you can follow this guide to find the paths in which you may install this software: http://doc.sccode.org/Guides/UsingExtensions.html

For that you will need to download this repository.
[Click here](https://github.com/nanc-in-a-can/canon-generator/archive/master.zip) and save the zip file wherever you want.


### Updating the library
With git it is as simple as 
```
Quarks.update("https://github.com/nanc-in-a-can/canon-generator.git");
```


## Nanc-In-A-Can Canon Generator

This program aims to provide the user with a robust, explicit and clear api that allows for an easy under-standing and manipulation of the parameters of different temporal canons. With a minimum knowledge of SCLang it is possible to design melodies and express them as canons of convergence or divergence. On the one hand this offers compositional or pedagogical tools for musicians and teachers, on the other, the novel ability to create sets of live coding with tempo canons (a new addition to the enormous arsenal of resourcesthat have been created for these practices).

### Temporal Canons
Temporal canons are defined when the information of a voice in a contrapuntal work is usually reproduced simultaneously in another voice with a different temporal proportion, and transposition values. This strategy that allows musicians to explore polytemporality was deviced by the Mexican socialist artist Conlon Nancarrow. 

## Preset examples

The PresetCan contains some examples of compositions made with this library.

Sound Only:

```supercollider
(
  Can.init; 
  s.boot;
)

(
  ThePresetCan.pyramidCanon.play;
)

```

Sound and Visualization:

```supercollider
(
  Can.init;
  s.boot;
)

(
  ThePresetCan.pyramidCanon.visualize(s);
)
```

## Basic examples

The basic components of a canon are the melodic information in itself divided in notes (pitch information) and durs (rhythmic information) and the voice information that defines the transposition and the tempo-related information of the already defined melodic material. 

### Convergence Canon

```supercollider
(
Can.converge(\pachelbel,
	melody: Can.melody(
		durs: [1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4],
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

## Nicer examples

```
(
Can.converge(
	melody: Can.melody(
		(1!100), // this canon may last ca. 18 minutes, change 1 to 1/2, 1/3 etc. your suit your needs, multiple simultaneous canons at different speeds also work well
		//longer durations of a canon help on percieving the "echoic distance" of the voices as they approach or distance themselves from the convergence point
		((40..90).scramble.mirror*rrand(0.6, 1.2))+10
	),
	repeat: 1,
	cp: rrand(0, 100),
	voices: Can.convoices(
		tempos: (Array.series(50, 30, 5)*rrand(0.5, 1)),
		transps: (Array.series(50, -20, 1))*rrand(0.5, 0.7)
	),
	instruments: [\sin],
	meta: (amp: 0.2),
).play;
)
```

## Symbol, Period and Meta

A symbol can be added as a first argument to a canon (or with the key symbol: \myCanonName) to identify it to later control de player as it is suggested in this example.

The period is a absolute duration for the canon. In the example below the total duration of the canon will be 5 seconds given that the default TempoClock is 1.

Meta allows you to control the overall access to arguments of the instrument or pattern definition in the player that are unrelated to the canonic data defined in the keys melody, voices, cp, osc, instrument, etc.

```supercollider
// TempoClock.default.tempo = 1;

(
Can.converge(\myCanon,
	melody: Can.melody([1,1,1,1],[60,67,72,74]),
	voices: Can.convoices([60,75],[0,12]),

	cp: 3,
	period: 5,

	repeat: inf,
	instruments: [\pianola],
	meta: (chooseObject: 1, object: 0.005), // "prepared piano sound" from pianola, choose between 0 and 1
                                          // object works as karlplus-strong synthesis, between 0.1 and 0.0001
);
)

Pdef(\myCanon).play;
Pdef(\myCanon).pause;
Pdef(\myCanon).resume;
Pdef(\myCanon).stop;

```

## Isomelody and Functions as arguments

The method isomelody allows to fix the size of the melody by providing a length, an integer that is the number of events per melody. The sequence of durs and notes will cycle until 8 events are provided. In this case the events of durs and notes will be: ``[(1,60),(0.5,72),(0.75,84),(1,65),(0.5,60),(0.75,72),(1,84),(0.5,65)]``

Tempo, Transpose and cp can be a function as exemplified below.


```supercollider

(
Can.converge(\myCan2,
	melody: Can.isomelody( durs: [1,0.5,0.75], notes: [[60,72,84,65]], len: 8 ),
	
	cp: {|melody| [1,2,3,4, melody.size].choose}, 
	voices: Can.convoices( 
		tempos: [3/2, 5, 9/7, 10*2],
		transps: [ 0, _.choose, _[0], -12, -24, _.choose, {|item| item*2}] 
	),		
	
	instruments: [\pianola], 
	period: 5, 
	meta: (amp: 1),
	repeat: inf
); 
)

Pdef(\myCan2).play

```

## OSC

Default OSC behavior has been implemented for the default player.

```supercollider
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
