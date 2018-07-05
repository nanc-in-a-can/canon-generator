(//initialize
// var baseDir = "/Users/user/sc/nanquirules";
var baseDir = thisProcess.nowExecutingPath.dirname; // if you are not in an evironment where thisProcess.nowExecutingPath.dirname exists you can configure the path to the library
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
(baseDir++"/canonPreConfigs.scd").load;// exports ~melodyMaker // este debe de cambiar por Melodic presets (o algo similar)
(baseDir++"/instrument.scd").load;// exports ~instrument,
(baseDir++"/synthdef-instruments.scd").loadPaths;// add \pianola synthdef,
(baseDir++"/makeConvVoices.scd").load;
(baseDir++"/convCanon.scd").load; //exports ~convCanon
(baseDir++"/divCanon.scd").load;//exports ~divCanon
(baseDir++"/makeMelody.scd").load;//exports ~makeMelody
(baseDir++"/visualize.scd").load;//exports ~visualize
});
)


