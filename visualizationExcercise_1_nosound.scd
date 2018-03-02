//Example of a visualization
(
//--window setup
var width= 940, height= 480;
var w= Window("Nanc in a Can - Canon generator", Rect(99, 99, width, height), false, scroll: true);
var u= UserView(w, Rect(0, 0, width*20, height));

	//--variables

var getXValues = {|durations|
	durations.inject((durs: List [], val: 0), {|acc, dur|
		acc.durs.add(acc.val);
		acc.val = dur+acc.val;
		acc;
	}).durs;
};




var chooseMelody = [~melodyMaker.chido_melody, ~melodyMaker.simple4NoteMelody(2), ~melodyMaker.randomSymmetric4voices];
var madeCanon =  ~makeCanon.((
	cp: 315,
	melody: ~makeMelody.(
		(16..40).pyramid.reciprocal.postln,
		((16..40).pyramidg.collect({|arr, i| arr+i})*12).flatten.cpsmidi
	),
	voices: [
		(tempo: 120*7/12, transp: 0),
        (tempo: 120*11/12, transp: 0),
        (tempo: 120*13/12, transp: 0),
        (tempo: 120*17/12, transp: 0),
		(tempo: 120*19/12, transp: 0),
		// (tempo: 120*23/12, transp: 0)
	]
));

var canon = madeCanon.canon;
var data = madeCanon.data.postln;
var y_values_V1 = canon[0].notes;
var line = canon[0].durs;
var x_values_V1 = getXValues.(line);
var xCoord = canon.size.collect({0});
var yCoord = canon.size.collect({0});
var colors = [Color.green(0.8), Color.red(0.8), Color.blue(0.8), Color.yellow(0.9)];
var durTotal = [canon[0].durs.sum,canon[1].durs.sum,canon[2].durs.sum,canon[3].durs.sum].sort[3]; // aquí va el total de duración de la pieza;
var durSize = durTotal*40; // aqui va width pero expandido;
var maxY= [canon[0].notes.maxItem,canon[1].notes.maxItem,canon[2].notes.maxItem,canon[3].notes.maxItem].sort[3]+5;
var minY= [canon[0].notes.minItem,canon[1].notes.minItem,canon[2].notes.minItem,canon[3].notes.minItem].sort[0]-10;
var stringCP = "CP position:"+canon[0].cp;
var stringVcs = "Voices:"+canon.size;
var stringTempos = "Tempos:"+data.voices.collect(_.tempo).sort();
// var stringMelodia = ; Aqui debe ir nombre de la melodía


var drawPoints = {
	|xVals, yVals, onset|

	xVals.size.do{|i|

		Pen.color = if( yVals[0]==(canon[0].notes[0]), {colors[0]}, {if(yVals[0]==canon[1].notes[0], {colors[1]}, if( yVals[0]==canon[2].notes[0], {colors[2]},{colors[3]}))});// set the Color


		// here the coordinates are expressed as an underlying map
		Pen.addWedge((xVals[i] + onset).linlin(0,(durTotal),10,durSize)@(yVals[i].linlin(minY,maxY,480,0)), 4, 0pi, 2pi);
        Pen.perform(\fill);


	};

	(xVals.size-1).do{|i|
		Pen.width= 1;
	Pen.line(
		Point((xVals[i] + onset).linlin(0,(durTotal),10,durSize),yVals[i].linlin(minY,maxY,480,0)),
		Point((xVals[i+1] + onset).linlin(0,(durTotal),10,durSize),yVals[i+1].linlin(minY,maxY,480,0))
	);
		Pen.strokeColor= if( yVals[0]==(canon[0].notes[0]), {colors[0]}, {if(yVals[0]==canon[1].notes[0], {colors[1]}, if( yVals[0]==canon[2].notes[0], {colors[2]},{colors[3]}))});


			Pen.stroke;
	};

	1.do{
//  here a line marks the CP;
		Pen.width= 0.3;

				Pen.stringAtPoint("Point of Convergence",Point((canon[0].bcp + canon[0].onset + 0.2).linlin(0,(durTotal),10,durSize),maxY.linlin(minY,maxY,480,0)),color: Color(0.8,0.3,0.9));

		Pen.line(Point((canon[0].bcp + canon[0].onset).linlin(0,(durTotal),10,durSize),minY.linlin(minY,maxY,480,0)),Point((canon[0].bcp + canon[0].onset).linlin(0,(durTotal),10,durSize),maxY.linlin(minY,maxY,480,0)));

		Pen.strokeColor= Color(0.8,0.3,0.9);


			Pen.stroke;


	};


	Pen.stringAtPoint("Temporal Canon Generator -"++" Alejandro Franco  &&   Diego Villaseñor", Point(10,20),color: Color.grey(0.7));
	Pen.stringAtPoint(stringCP, Point(10,35),color: Color.white);
	Pen.stringAtPoint(stringVcs, Point(10,50),color: Color.white);
	Pen.stringAtPoint(stringTempos, Point(10,65),color: Color.white);
//	Pen.stringAtPoint(stringMelodia, Point(10,80),color: Color.white);



};

var patterns = canon.collect({|line, index|
	Pbind(
		\instrument, \piano,
		\pan, 0,
		\dur, Pseq([line.onset.postln] ++ line.durs,1),
		\freq, Pseq([\rest]++line.notes,inf),
		\out, 0,
		\amp, 1,
		/*this series will provide an Index for later processes*/
		\series, Pseries(0,1,inf),
		/*messages to change the point positions in the map below*/
		\coordinates, Pfunc({|event|
			NetAddr("127.0.0.1", 57120).sendBundle(0.005, [("/event"++index), event[\freq], event[\series], event[\dur]])
		})
	)
});

var canonWithXValues = canon.collect({|line| (xValues: [0]++getXValues.(line.durs), onset: line.onset)});

//
w.drawFunc = { // draw the points of the canon;
	canon.do({|line| drawPoints.(getXValues.(line.durs), line.notes, line.onset)});
	};


//in U the present moment of the events will be emphasised visually in the map
u.drawFunc= {

	var selectMoment = {|index, line, onset|

//
		Pen.fillColor= Color(0.8,0.3,0.9);				//always fill with purple color
//
// 		// receive the data from the Pbind in realtime assigning global variables
		OSCdef("test"++index, {|msg, time, addr, recvPort|
			// msg.postln;
			if(msg[1] !== \rest, {
				yCoord[index]=msg[1].linlin(minY,maxY,480,0);
				xCoord[index]= (line[msg[2]] + onset).linlin(0,(durTotal),10,durSize);
			})
		},
		("/event"++index), n);
		Pen.addWedge(Point(xCoord[index], yCoord[index]), 5, 0pi,2pi);
		Pen.fill;
//
		};
//
	u.frameRate= 28;
	canonWithXValues.do({|line, i| selectMoment.(i, line.xValues, line.onset)})
	};



//--window management
//~scroller.play(AppClock);
u.clearOnRefresh= true;
w.background= Color.gray(0.05);
w.front;
u.animate= true;

CmdPeriod.doOnce({if(w.isClosed.not, {w.close; patterns.do(_.stop)})});

patterns.do(_.play)
)

(1..3).pyramidg.collect({|arr, i| arr+i})