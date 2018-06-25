# Nanc-in-a-can Canon Generator

Nanc-in-a-can Canon Generator is a series of sc patches that can be used to produce temporal canons as the ones created by Conlon Nancarrow. The patches are 6 that contain a function each, 2 that contain synthdefs and 1 that loads the modules, boots server and other processes that enables the program. 




## Functions.


~makeMelody.(durs_arr: [float], notes_arr: [float / [float]])

Is a function that generates an Event object with dur and notes necessary to create a musical object that might be a simple monody (one pitch value per event) or a melodic structure with various degrees of density (two or more pitch values per event) including rests. 

Arguments:

durs_arr. An array of floats that represents in durations in which 1 is equivalent to a bpm of tempo provided in Voices argument of ~makeConvCanon or ~makeDivCanon. 

notes_arr. An array of floats or arrays of floats that represents the pitch value(s) in midi notes.  (que pedo con transp entonces deben de girar en torno a 0 y agregar el centro tonal m�s tarde o los valores que aqu� se generen entren en la funcion ~makeVoices para producir los valores en relacion al centro tonal sugerido en melody con sus respectivas transposiciones)

----------------
~makeVoices.(tempo: float / [float], proportions: String, transp: [float])

Is a function that generates number of voices by declaring the tempo of each and its transposition value.

Arguments:

tempo. It accepts an array of floats that arbitrarily determines the tempo of each voice. In case a single tempo (float) is decided it generates a value from which a relationship of proportional tempi is determined in the second argument.

proportions. In case tempo is a float proportions is a string that describes a set of temporal relationships with the structure �t1:t2:t3:t4� in which each t is multiplied by the float in tempo answering an array of floats that represent a series of tempi that hold a proportional relationship among themselves.

transp. An array of floats that represent a series of transposition values in midi notes. If transp is nil the transp values is taken from the temporal proportions determined in the last two arguments. The relationship between pitch and tempo is taken from the concept of harmonic rhythm developed by Henry Cowell.

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
~makeVisualization.(~makeConvCanon / ~makeDivCanon, autoScrollSwitch: Bool) 

Is a function that generates a dynamic timeline in which pitch and duration are represented in a visual field. The different colours represent the different voices of the temporal canon. 

Arguments:

canon. The first argument accepts the functions ~makeConvCanon and ~makeDivCanon from which ti extracts the data necessary to make the visualization.

autoScrollSwitch. Accepts a Boolean, if true the scroll maintains the present time in the view window. If false the user can navigate the score map of the time canon freely.  Default is true.


-----------------------------
~canonPreConfigs 



----------------------------
instrument module
----------------------------
filter module
----------------------------
load module
