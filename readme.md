# Nanc-in-a-can Canon Generator

Nanc-in-a-can Canon Generator is a series of sc patches that can be used to produce temporal canons as the ones created by Conlon Nancarrow. The patches are 6 that contain a function each, 2 that contain synthdefs and 1 that loads the modules, boots server and other processes that enables the program. 




Functions.


~makeMelody.(durs_arr: [float], notes_arr: [float / [float]])

Is a function that generates an Event object with dur and notes necessary to create a musical object that might be a simple monody (one pitch value per event) or a melodic structure with various degrees of density (two or more pitch values per event) including rests. 

Arguments:

durs_arr. An array of floats that represents in durations in which 1 is equivalent to a bpm of tempo provided in Voices argument of ~makeConvCanon or ~makeDivCanon. 

notes_arr. An array of floats or arrays of floats that represents the pitch value(s) in midi notes.  (que pedo con transp entonces deben de girar en torno a 0 y agregar el centro tonal más tarde o los valores que aquí se generen entren en la funcion ~makeVoices para producir los valores en relacion al centro tonal sugerido en melody con sus respectivas transposiciones)

----------------
~makeVoices.(tempo: float / [float], proportions: String, transp: [float])

Is a function that generates number of voices by declaring the tempo of each and its transposition value.

Arguments:

tempo. It accepts an array of floats that arbitrarily determines the tempo of each voice. In case a single tempo (float) is decided it generates a value from which a relationship of proportional tempi is determined in the second argument.

proportions. In case tempo is a float proportions is a string that describes a set of temporal relationships with the structure “t1:t2:t3:t4” in which each t is multiplied by the float in tempo answering an array of floats that represent a series of tempi that hold a proportional relationship among themselves.

transp. An array of floats that represent a series of transposition values in midi notes. If transp is nil the transp values is taken from the temporal proportions determined in the last two arguments. The relationship between pitch and tempo is taken from the concept of harmonic rhythm developed by Henry Cowell.

----------
~makeConvCanon.(cp: int, melody: [(dur: Float, note: midiNote / [midiNote] / \rest)], voices: [(tempo: Float, transp: Int)]

Is a function that generates a convergence-divergence temporal canon based on a musical object that might be a monody or a melodic structure with various degrees of density per attack including rests. 

Arguments: 
cp. [Int] Convergence point, an integer that represents the index of a note, chord or silence of the melodic structure in which all the different voices have the same structural and chronological position simultaneously.  The convergence point might be at any given onset value of the melody.

melody. [(dur: Float, note: midiNote)] A melodic identity composed by durations and pitches passed as an array of Event objects with a duration and a note value. Durations is passed as a float that represents seconds. Note is a midinote value, an array of midinote values or a \rest symbol. The function ~makeMelody generates an Event object as the one required from an array of durs in seconds and an array of pitch values in midi notes. 

voices: [(tempo: Float, transp: Int)] An array of Event objects with tempo and transposition for each voice that will be generated. The size of the array determines the number of voices of the temporal canon. Tempo is a float that represents a BPM value.  Transp represent a midi note value that will be added to the midi notes established in the melody. Negative numbers are descending intervals, positive numbers are ascending ones. This argument may hold another function called ~makeVoices that have the option of generating proportional tempi as well as an equivalence between tempo and pitch as proposed by Henry Cowell.

Inconsistencia entre la ~makeVoices y el modo en el que se construyen las melodías. Resolver aquello urgentemente. 


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
