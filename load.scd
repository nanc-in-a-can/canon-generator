(//initialize
// var baseDir = "/Users/user/sc/nanquirules";
var baseDir = thisProcess.nowExecutingPath !? {thisProcess.nowExecutingPath.dirname} ? "/Users/user/sc/nanquirules"; // if you are not in an evironment where thisProcess.nowExecutingPath.dirname exists you can configure the path to the library
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
(baseDir++"/filters.scd").load; // exports \reverb
(baseDir++"/sounds.scd").loadPaths;// exports \pianola,
(baseDir++"/makeTranspAndTempo.scd").load;
(baseDir++"/makeCanon.scd").load; //exports ~makeCanon
(baseDir++"/makeConvDivCanon.scd").load;//exports ~makeConvDivCanon
(baseDir++"/makeMelody.scd").load;//exports ~makeMelody
(baseDir++"/melodyMaker.scd").load;// exports ~melodyMaker // este debe de cambiar por Melodic presets (o algo similar)
(baseDir++"/makeVisualization.scd").load;//exports ~makeVisualization

//(thisProcess.nowExecutingPath.dirname++"/makeGUI.scd").load;//generates GUI to use with presets
});
)

