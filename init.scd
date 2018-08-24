(//initialize
// var baseDir = "/Users/user/sc/nanquirules";
var baseDir = thisProcess.nowExecutingPath.dirname; // if you are not in an evironment where thisProcess.nowExecutingPath.dirname exists you can configure the path to the library
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
(baseDir++"/presets/index.scd").load;// exports ~presets
(baseDir++"/synthdef-instruments.scd").loadPaths;// add \pianola synthdef,
(baseDir++"/convCanon.scd").load; //exports ~convCanon
(baseDir++"/divCanon.scd").load;//exports ~divCanon
(baseDir++"/visualize.scd").load;//exports ~visualize
(baseDir++"/helpers.scd").load;// exports ~instrument, ~makeMelody, ~makeConvVoices, ~makeDivVoices, ~makeDivTempos, ~mergeCanons
});
)
