# Nanc-in-a-can Canon Generator

Nanc-in-a-can Canon Generator is a series of sc patches that can be used to produce temporal canons as the ones created by Conlon Nancarrow. The patches are 7 that contain a function each, 2 that contain synthdefs and 1 that loads the modules, boots server and other processes that enables the program. The functions ~makeConvCanon and ~makeDivCanon are the core of the program, however, two other auxiliary functions have been created to generate meoldies, transposition patterns and tempos algorithmically instead of hardcoding them. The function ~makeVisualization incorporates a visual timeline of each canon made as well as creates the pbinds necessary to reproduce them as audio signal. The function ###~mySound### produces pbinds to perform the sound patterns skipping the visualization. 


## Functions.


### ~makeMelody

Is a function that generates an array of Event objects with durations and notes necessary to create a musical object that might be a simple monody (one pitch value per duration) or a melodic structure with various degrees of density (two or more pitch values per duration) including rests. In case size of the arrays is not the same, the size of the array of events it returns will be equal to the size of the smaller array it took.

#### Type Signature
Takes an array of durations and an array of midi pitch values and returns an array of Event object with the keys `dur` and `note`. 
```
~makeMelody :: [Float] -> [Float] -> [(durs: Float, notes: Float)]


#### Example
```
(
~myMelody= 

~makeMelody.( 
	Array.fill(35, { [4, 8, 16].wchoose([0.2, 0.3, 0.5].normalizeSum).reciprocal } ) 
	,
	Array.fill(35, { [60, 67,[38, 72], 68, 63, 63.5].wchoose([6, 4, 3, 2, 1, 1].normalizeSum) } )
		);

);

~myMelody.postln;

Arguments:

durs_arr. `[Float]`. Duration array. An array of floats that represents in durations in which 1 is equivalent to a bpm of tempo provided in Voices argument of ~makeConvCanon or ~makeDivCanon. Reciprocal of 2, 4, 8, 16 creates half, quarter, eighth and sixteenth notes respectively.  

notes_arr. `[Float] / [Float]]`. An array of a) floats, b) arrays of floats c) \rest symbols that represents the pitch value(s) in midi notes. If b) is taken then a chord will be returned. If the symbol \rest is taken then a silence value will be returned. The values are midi notes, if floats of midi notes provided then it will produce microtonal values. In the above example 63.5 will produce a E quarter note flat. 

----------------
### ~makeVoices

Similar to makeMelody however it generates tempos and transposition values.

#### Type Signature
Takes an array of tempos and transposition values and returns an array of Event object with the keys `tempo` and `transp`. 
```
~makeVoices :: [Float] -> [Float] -> [(tempo: Float, transp: Float)]


#### Example
```
(

~myVoices= 

~makeVoices.( 
	Array.series(7, 60, 10)
	,
	Array.series(7, -12, 4)
		);

);

~myVoices.postln;

#### Arguments:

tempo. An array of floats that generates tempo in bpm for each voice. 

transp. An array of floats that generates a series of transposition values in midi notes. Negative floats will generate descending intervals in relationship to the midi values passed down from melody, positive ones will generate ascending intervales. 

----------
### ~makeConvCanon
A function that generates a convergence-divergence temporal canon using a configuration object defining a convergence point, a melody, and the number of voices (with tempo and transposition).

#### Type Signature
Takes an Event Object with the keys `cp`, `melody` and `voices` and returns a `MadeCanon` (see below for the MadeCanon type definition)
```
~makeConvCanon ::
  (
    cp: Int, 
    melody: [(dur: Float, note:[midiNote])], 
    voices: [(tempo: Float, transp: Int)]
  ) -> MadeCanon
```

#### Example
```
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
~myCanon = ~makeConvCanon.(canonConfig);

~makeVisualization(~myCanon);
```
#### Arguments: 

`~makeConvCanon` takes a single argument, an Event Object with the following keys:

`cp`: `Int`. **Convergence point**. An _integer_ that represents the index of the melodic structure at which all the different voices have the same structural and chronological position simultaneously.  The convergence point might be at any given onset value of the melody.

`melody`: `[(dur: Float, note: [midiNote])]`. A melodic structure represented as an array of Event objects with a duration and a note values. `dur` is float representing rhythmic proportions. `note` may be a midi note -`Int`-, an array of midiNotes -`[Int]`- o the `\rest` keyword `Symbol`. The function `~makeMelody`(#makeMelody) may be used to generate this structure from a pair of arrays.

`voices`: `[(tempo: Float, transp: Int)]`. An array of Event objects with tempo and transposition. The size of the array determines the number of voices of the temporal canon. Tempo is a float that represents a BPM value.  Transp represent a midi note value that will be added to the midi notes established in the melody. Negative numbers are descending intervals, positive numbers are ascending ones. The helper function `~makeVoices` provides an API that allows for the simplified creation of this array, using either tempos or proportions, and generating automatic transpositions relating the temporal propotions to pitch (as proposed by Henry Cowell).

<!-- Inconsistencia entre la ~makeVoices y el modo en el que se construyen las melod�as. Resolver aquello urgentemente.  -->


----------------------
~makeDivCanon

Is a function that generates a divergence-convergence temporal canon based on a musical object that might be a monody or a melodic structure with various degrees of density per attack including rests. 

Arguments:
####
####
#####
#######



----------------------------
### ~makeVisualization.(MadeCanon, autoScrollSwitch: Bool) 

Is a function that generates a Window object in which a dynamic timeline shows pitch and duration as cartesian coordinates in a visual field. The colour key represent the different voices of the temporal canon. It also generates a pbind per voice that is played synchronously with the visualization. 

#### Type Signature
Takes an Event Object MadeCanon and returns , , , , .
```
~makeVisualization ::



Arguments:

MadeCanon. 

autoScrollSwitch. Accepts a Boolean, if true the scroll maintains the "present moment" of the canon in the centre of the view window. If false the user can navigate the score map of the time canon freely.  Default is true.


-----------------------------
### ~canonPreConfigs

A set of canon configurations that function as examples for the Nanc in a Can project. Each melody was design at some point of development of the program and is the outcome of the implementation of one or many ideas concerning the temporal canon concept. 

Configurations:

randomSymmetric4voices. A four voice canon configuration that creates a different melody everytime. The melody is generated using a weighted random process. The pitch set is modal /phrygian depending the octave with microtonal inflections. The durations are based in the theory of harmonic rhythm and the rhythm device of complex denomitar (irrational measures). 

pyramidalMelody. Using the parcials 16 to 40 of a sound with a root in 12 htz we create a pitch configuration that is simultaneously expressed in duration values using the theory of harmonic rhythm. We used the function ~makeMelody to then apply several methods to such an array. The tempo was design proportionally.

Fragment of Study 37 (sonido 13 version)

Fragment of Study 33 

chido_melody

----------------------------
instrument module.

Contains two sound-generating synthdefs. The first based in an algorithm by James McCartney that emulates a piano-player with the feature that may emulate a limited "prepared" piano timbre. 

----------------------------
filter module

Contains a reverb filter synthdef. 

----------------------------
load module.

Loads all the functions and compiles all the synths necessary to operate the Nanc-in-a-Can program. 

