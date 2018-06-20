(//initialize
Server.default.options.memSize= 512000*20;
Server.default.options.numWireBufs= 512;
s = Server.local;
s.latency = 0.05;
s.waitForBoot({
(thisProcess.nowExecutingPath.dirname++"/filters.scd").load; // exports \reverb
(thisProcess.nowExecutingPath.dirname++"/sounds.scd").loadPaths;// exports \pianola,
(thisProcess.nowExecutingPath.dirname++"/makeTranspAndTempo.scd").load;
(thisProcess.nowExecutingPath.dirname++"/makeCanon.scd").load; //exports ~makeCanon
(thisProcess.nowExecutingPath.dirname++"/makeConvDivCanon.scd").load;//exports ~makeConvDivCanon
(thisProcess.nowExecutingPath.dirname++"/makeMelody.scd").load;//exports ~makeMelody
(thisProcess.nowExecutingPath.dirname++"/melodyMaker.scd").load;// exports ~melodyMaker // este debe de cambiar por Melodic presets (o algo similar)
(thisProcess.nowExecutingPath.dirname++"/makeVisualization.scd").load;//exports ~makeVisualization

//(thisProcess.nowExecutingPath.dirname++"/makeGUI.scd").load;//generates GUI to use with presets
});
)

