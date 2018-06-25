(//initialize
// var baseDir = "/Users/user/sc/nanquirules";
var baseDir = thisProcess.nowExecutingPath !? {thisProcess.nowExecutingPath.dirname} ? "/Users/user/sc/nanquirules"; // if you are not in an evironment where thisProcess.nowExecutingPath.dirname exists you can configure the path to the library
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
(baseDir++"/filters.scd").load; // exports \reverb
(baseDir++"/instruments.scd").loadPaths;// exports \pianola,
(baseDir++"/makeVoices.scd").load;
(baseDir++"/makeConvCanon.scd").load; //exports ~makeConvCanon
(baseDir++"/makeDivCanon.scd").load;//exports ~makeDivCanon
(baseDir++"/makeMelody.scd").load;//exports ~makeMelody
(baseDir++"/canonPreConfigs.scd").load;// exports ~melodyMaker // este debe de cambiar por Melodic presets (o algo similar)
(baseDir++"/makeVisualization.scd").load;//exports ~makeVisualization
});
)


