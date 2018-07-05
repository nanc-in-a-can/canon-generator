# Nanc-in-a-can Canon Generator
<p align="center">
   <img width="100%" src="nanc-in-a-can.jpg">
</p>

Nanc-in-a-can Canon Generator is a series of sc files that can be used to produce temporal canons as the ones created by Conlon Nancarrow. The files are 7 and mostly contain a function each, 1 of them contains `SynthDefs`. The functions `~convCanon` and `~divCanon` are the core of the program, however, three other auxiliary functions have been added to aid the creation of melodies, transposition patterns and tempos. The function `~visualize` generates a visual timeline for each canon and plays it back. The function `~instrument` produces `Pbinds` for each of the canon's voices. Finally there is a init file that compiles all the functions and modules design for it to run.

- [Nanc-in-a-can Canon Generator](#nanc-in-a-can-canon-generator)
  * [Installation](#installation)
    + [Using git](#using-git)
    + [Manual download](#manual-download)
  * [Loading the project files](#loading-the-project-files)
  * [Basic Examples](#basic-examples)
  * [Functions (API)](#functions--api-)
    + [Types](#types)
    + [Creating your own custom Pbinds to play a canon.](#creating-your-own-custom-pbinds-to-play-a-canon)
    + [~convCanon](#convcanon)
    + [~divCanon](#divcanon)
    + [~visualize](#visualize)
  * [Helper Functions](#helper-functions)
    + [~makeMelody](#makemelody)
    + [~makeConvVoices](#makeconvvoices)
    + [~makeDivTempo](#makedivtempo)
    + [~instrument](#instrument)
    + [Presets](#presets)
      - [~canonPreConfigs](#canonpreconfigs)
  * [synthdef-instrument module.](#synthdef-instrument-module)
  * [init module.](#init-module)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## Installation
### Using git
`git clone <path-to-folder>`

### Manual download
[Click here](https://github.com/nanc-in-a-can/canon-generator/archive/master.zip) and save the zip file wherever you want.


## Loading the project files
Open Supercollider and add and compile the following line of code.

```supercollider
("path/to/nanc-in-a-can/init.scd").load;
```

This starts up the server and loads all the necessary files and functions.

## Basic examples
Sound Only:

```supercollider
(
var melody = ~melodyMaker.pyramidalMelody;
~convCanon.(melody).canon
  .collect(~instrument.([\pianola]))
  .do({|synthVoice| synthVoice.play})
)
```

Sound and Visualization:
```supercollider
(
var melody = ~melodyMaker.pyramidalMelody;
~visualize.(~convCanon.(melody));
)
```

## Functions (API)
### Types
A type is basically a label that indicates the category to which some data or event in a program belongs. 

We are using a form of *Hindley-Milner type notation* to describe the data structures that the functions in this software take and return. By providing a function with the correct data types, we ensure that the program will run correctly no matter what.

 A thorough explanation of what a type is might be found in the following links:

http://learnyouahaskell.com/types-and-typeclasses 

(For people familiar with Javascript) https://mostly-adequate.gitbooks.io/mostly-adequate-guide/ch07.html


```haskell
CanonVoice :: (
  notes: [Float],
  durs: [Float],
  onset: Float, -- duration of time before canon starts
  remainder: Float, -- duation of time left after canon ends
  bcp: Float, -- duration of time before convergence point
  cp: Int, -- convergence point
)

Canon :: (
  canon: [CanonVoice],
  data: (
    voices: [(transp: Float, tempo: Float )]
  )
)
```
`Canon` is the main data structure of the program.  It is returned by `~convCanon` and `~divCanon` and can be used to make a visualization or to play a canon (as shown in the [examples above](#basic-examples)).

One could read this type signature as: `Canon` is a structure consisting of an Event object that has two keys, `canon` and `data`.  The key `canon` holds an array of `CanonVoice`s, which are also `Event` objects that hold several other keys: `notes` and `durs` are `Arrays` of `Floats`, while `onset` and `bcp` are just Floats and `cp` is an `Int`.

The next signatures are more simple:
```
Note :: (
  durs: Float, 
  notes: [Float] || \rest
)

Melody :: [Note]

Voice :: (tempo: Float, transp: Float)

Voices :: [Voice]

```

```haskell
Index :: Int

MakePbind :: (CanonVoice, Index) -> Pbind 
```

`MakePbind` is a very important type that is used for playing back the canon.  An example can be seen in [~instrument](#~instrument).

One could read this signature as: `MakePbind` is the type of a function (denoted by the `->`) that takes two arguments, a `CanonVoice` and an `Index` which is an `Int`, and **returns** a `Pbind`.  This function literally transforms the data held in a canon voice into a `Pbind` ready for playback. The function may be implemented in several ways depending on the user's needs. In the file `~instrument.scd` you may find a somewhat complex implementation of it. 

### Creating your own custom Pbinds to play a canon.

Let's make a simple example of a function of type `MakePbind`:

```supercollider
(
//We use the melody of a previous example
var melody = ~melodyMaker.pyramidalMelody;

~makePbind = {|voice, index|
  /* We will coordinate the convergence point of the voices of our canon. For this we have to do the following: on the Pseqs of \dur and \midinote we concatenate the voice.onset time at the beginning of \dur, this corresponds to a \rest  on \midinote, and will allow the different voices to start at the correct time when we play our Pbinds (see below) 
  
  Here we will not use the index argument, but it might be of use in some cases.
  */

  Pbind(
    \instrument, \default,
    \dur, Pseq([voice.onset] ++ voice.durs),
    \midinote, Pseq([\rest]++voice.notes, inf),
  )
};


//Now we create our canon
//The call on `.collect` will return the following: [Pbind, Pbind, Pbind, Pbind] -- `.collect` is a method that iterates over the the array of CanonVoices, it will call ~makePbind on each voice and collect the result in a new array. (.collect is often called `map` in other languages).

~canon = ~convCanon.(melody).canon
  .collect(~makePbind)
  .do({|pbind| pbind.play}); //finally we iterate again but this time we call play on each Pbind
)
```

----------
### ~convCanon
A function that generates a convergence-divergence temporal canon using a configuration object defining a convergence point, a melody, and the number of voices (with tempo and transposition).

#### Type Signature
Takes an Event Object with the keys `cp`, `melody` and `voices` and returns a `MadeCanon` (see below for the MadeCanon type definition)
```haskell
~convCanon :: (
  cp: Int, 
  melody: Melody
  voices: Voices
) -> Canon
```

#### Example
```supercollider
(
~canonConfig = (
  cp: 2,
  melody: [
    (dur: 1, note: 60), 
    (dur: 1, note: 61), 
    (dur: 1, note: 62), 
    (dur: 1, note: 63)
  ],
  voices: [
    (tempo: 70, transp: 0),
    (tempo: 65, transp: -12),
    (tempo: 57, transp: 12),
    (tempo: 43, transp: 8)
  ]
);
~myCanon = ~convCanon.(~canonConfig);

~visualize.(~myCanon);
)
```
#### Arguments: 

`~convCanon` takes a single argument, an Event Object with the following keys:

`cp`: `Int`. **Convergence point**. An _integer_ that represents the index of the melodic structure at which all the different voices have the same structural and chronological position simultaneously.  The convergence point might be at any given onset value of the melody.

`melody`: `[(dur: Float, note: [midiNote])]`. A melodic structure represented as an array of Event objects with a duration and a note values. `dur` is float representing rhythmic proportions. `note` may be a midi note -`Int`-, an array of midiNotes -`[Int]`- o the `\rest` keyword `Symbol`. The function `~makeMelody`(#makeMelody) may be used to generate this structure from a pair of arrays.

`voices`: `[(tempo: Float, transp: Int)]`. An array of Event objects with tempo and transposition. The size of the array determines the number of voices of the temporal canon. Tempo is a float that represents a BPM value.  Transp represent a midi note value that will be added to the midi notes established in the melody. Negative numbers are descending intervals, positive numbers are ascending ones. The helper function `~makeConvVoices` provides an API that allows for the simplified creation of this array.


----------------------
### ~divCanon

Is a function that generates a divergence-convergence temporal canon. All voices start and end simultaneously, however each voice switches from one tempo to another. In the end all voices pass through all tempos, but each one at different moments.

#### Type Signature

```haskell
~divCanon :: (
  baseTempo: Float,
  voices: [(transp: Float, amp: Float)],
  melody: Melody,
  tempos: [(tempo: Float, percentage: Float)],
) -> Canon
```
#### Example
```supercollider
(
~canonConfig = (
  baseTempo: 60,
  melody: [
    (dur: 1, note: 60), 
    (dur: 1/2, note: 61), 
    (dur: 1/3, note: 62), 
    (dur: 1/4, note: 63)
  ],
  voices: [ // Note that voices and tempos should be arrays of the same size
    (transp: 2, amp: 0.7),
    (transp: 10, amp: 0.5),
    (transp: -12, amp: 1),
    (transp: -8, amp: 1)
  ],
  tempos: [
    (tempo: 70, percentage: 20),
    (tempo: 40, percentage: 30),
    (tempo: 120, percentage: 10),
    (tempo: 300, percentage: 40)
  ]
);
~myCanon = ~divCanon.(~canonConfig);

~visualize.(~myCanon);
)
```
#### Arguments: 

`~divCanon` takes a single argument, an `Event` Object with the following keys:

`baseTempo`: `Float`.

`melody`: `[(dur: Float, note: [midiNote])]`. A melodic structure represented as an array of Event objects with a duration and a note values. `dur` is float representing rhythmic proportions. `note` may be a midi note -`Int`-, an array of midiNotes -`[Int]`- o the `\rest` keyword `Symbol`. The function `~makeMelody`(#makeMelody) may be used to generate this structure from a pair of arrays.

`voices`: `[(transp: Float, amp: Float)]`. An array of Event objects with transposition and amplitude for each voice. The size of the array determines the number of voices of the temporal canon, but it should be the same as the size of the `tempos` array (see below). `transp` represent a midi note value that will be added to the midi notes established in the melody. Negative numbers are descending intervals, positive numbers are ascending ones. `amp` must be a number between 0 and 1.

`tempos`: `[(tempo: Float, percentage: Float)]`. An array of Event objects with transposition and amplitude for each voice. The size of the array determines the number of voices of the temporal canon, but it should be the same as the size of the `voices` array (see above). `percentage` determines the amount of time each voice spends in a given tempo. `tempo` is the speed of the voice. The user is responsible for having all percentages sum up to `100`. The helper function `~makeDivTempo` provides an API that allows a simpler way to create this arrays.

----------------------------
### ~visualize

#### Type Signature
Takes an Event Object MadeCanon and creates a window object that visualizes and plays back the canon.

```haskell
~visualize :: Canon -> Nil
```

#### Example
```supercollider
(
var melody = ~melodyMaker.pyramidalMelody;
~visualize.(~convCanon.(melody));
)
```

#### Arguments:

`madeCanon` : `Canon`. A canon of the same type as the one returned by functions such as `~convCanon` or `~divCanon`.

`autoScroll`: `Boolean`.  Default is true.

---

## Helper Functions

### ~makeMelody

Is a function that generates an array of `Event` objects with durations and notes necessary to create a musical object that might be a single sound (one pitch value per duration) or a melodic structure with various degrees of density (two or more pitch values per duration) including rests. In case size of the arrays is not the same, the size of the array of events it returns will be equal to the size of the smaller array it took.

#### Type Signature
Takes an array of durations and an array of midi pitch values and returns an array of Event object with the keys `dur` and `note`. 
```haskell
~makeMelody :: ([Float], [Float]) -> Melody
```


#### Example
```supercollider
(
~myMelody = ~makeMelody.( 
	Array.geom(2, 8, 2).stutter(2).scramble.mirror2,
	Array.series(4, 60, 2).mirror
);

~myMelody.postln; // [ ( 'note': 60, 'dur': 16 ), ( 'note': 62, 'dur': 8 ), ( 'note': 64, 'dur': 8 ), ( 'note': 66, 'dur': 16 ), ( 'note': 64, 'dur': 16 ), ( 'note': 62, 'dur': 8 ), ( 'note': 60, 'dur': 8 ) ]
)
```

#### Arguments:

`durs_arr`. `[Float]`. Duration array. An array of floats that represents in durations in which 1 is equivalent to a bpm of tempo provided in Voices argument of ~convCanon or ~divCanon. Reciprocal of 2, 4, 8, 16 creates half, quarter, eighth and sixteenth notes respectively.  

`notes_arr`. `[Float] || [[Float]]`. An array of a) floats, b) arrays of floats c) \rest symbols that represents the pitch value(s) in midi notes. If b) is taken then a chord will be returned. If the symbol \rest is taken then a rest value will be returned. The values are midi notes, if floats of midi notes provided then it will produce microtonal values. 

----------------
### ~makeConvVoices

Similar to makeMelody however it generates tempos and transposition values.

#### Type Signature
Takes an array of tempos and transposition values and returns an array of Event object with the keys `tempo` and `transp`. 
```haskell
~makeConvVoices :: ([Float], [Float]) -> Voices
```


#### Example

```supercollider
(
~myVoices= ~makeConvVoices.( 
    Array.series(3, 60, 10),
    Array.series(3, -12, 8)
);

~myVoices.postln; // [(transp: -12, tempo: 60), (transp: -4, tempo: 70), (transp: 4, tempo: 80 )]
)
```
#### Arguments:

`tempo`. `[Float]`. An array of floats that generates tempo in bpm for each voice. 

`transp`. `[Float]`. An array of floats that generates a series of transposition values in midi notes. Negative floats will generate descending intervals in relationship to the midi values passed down from melody, positive ones will generate ascending intervales. 

----------------
### ~makeDivTempo

Similar to makeMelody and makeVoices however it generates tempo values and a percentage value. A boolean may determine whether the percentage values are normalized or not.

#### Type Signature
Takes an array of tempos and percentage values and returns an array of Event object with the keys `tempo` and `percentage`. 
```
~makeDivTempo :: ([Float], [Float], Bool) -> Tempo
```


#### Example

```supercollider
(
~myTempos= ~makeDivTempo.( 
    Array.series(4, 4, 2),
	  (30!2) ++ (20!2),
	  norm: true
);

~myTempos.postln; //[ ( 'percentage': 30, 'tempo': 4 ), ( 'percentage': 30, 'tempo': 6 ), ( 'percentage': 20, 'tempo': 8 ), ( 'percentage': 20, 'tempo': 10 ) ]
)
```
#### Arguments:

`tempo`. `[Float]`. An array of floats that generate tempos for the function. 

`percentage`. `[Float]`. An array of floats that generates a percentage value in which the rotation of the tempo switch happens.

`norm`. `Bool` If false the percentages may be more or less than 100% in which case the final convergence point will not happen. If true the values given to percentage will be normalized so it always sums 100.

----------------------------
### ~instrument
```haskell
Amp :: Float
Pan :: Float
Out :: [Float]
Repeat :: Int

~instrument :: ([Symbol], [Amp, Pan, Out, Repeat) -> ((durs: [Float], notes: [Float], onset: Float, amp: Float), Index) -> Pbind 

--It can otherwise be expressed like this
~instrument :: ([Symbol], [Amp, Pan, Out, Repeat) -> MakePbind
```

`Amp`, `Pan`, `Out` and `Repeat` have default values and are optional.

##### Example
```supercollider
(
~canonConfig = (
  cp: 2,
  melody: [
    (dur: 1, note: 60), 
    (dur: 1, note: 61), 
    (dur: 1, note: 62), 
    (dur: 1, note: 63)
  ],
  voices: [
    (tempo: 70, transp: 0),
    (tempo: 65, transp: -12),
    (tempo: 57, transp: 12),
    (tempo: 43, transp: 8)
  ]
);

~convCanon.(~canonConfig)
.canon //we extract the canon from the data structure that is returned
.collect(~instrument.([\pianola], amp: 1, repeat: 2)) // we pass each voice into our ~instrument. At this point ~instrument is returning a `MakePbind`, because it has been partially applied with `([Symbol], Amp, Repeat)`. This line will return: `[Pbind, Pbind, Pbind, Pbind]`
.do({|pbind| pbind.play})// finally we play each voice
)
```


### Presets
-----------------------------
#### ~canonPreConfigs

A set of canon configurations that function as examples for the `Nanc-in-a-Can` project.

Configurations:


`simple4NoteMelody`. Just that, a `hello world` for `Nanc-in-a-Can`.  It accepts one parameter and `Int` which should be a number between 0 and 3, and which defines the convergence point of the melodies.

```supercollider
~visualize.(~convCanon.(~melodyMaker.simple4NoteMelody(3)), autoScroll: false);
```

`randomSymmetric4voices`. A four voice canon configuration that creates a different melody everytime. The melody is generated using a weighted random process. The pitch set is modal /phrygian depending the octave with microtonal inflections. The durations are based in the theory of harmonic rhythm and the rhythm device of complex denomitar (irrational measures). 
```supercollider
~visualize.(~convCanon.(~melodyMaker.randomSymmetric4voices), false);
```

`pyramidalMelody`. Using the partials 16 to 40 of a sound with a root at 12hz we create a pitch configuration that is simultaneously expressed in duration values using the theory of harmonic rhythm. The function `~makeMelody` is used, and several algorithmic methods are used to generate the result.
```supercollider
~visualize.(~convCanon.(~melodyMaker.pyramidalMelody));
```

Fragment of Study 37 (sonido 13 version)

Fragment of Study 33 

----------------------------
## synthdef-instrument module.

Contains two sound-generating synthdefs. The first based in an algorithm by James McCartney that emulates a piano-player with the feature that may emulate a limited "prepared" piano timbre. 

----------------------------
## init module.

Loads all the functions and compiles all the synths necessary to operate the Nanc-in-a-Can program. 

