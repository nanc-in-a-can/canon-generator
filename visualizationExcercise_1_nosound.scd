//Example of a visualization
(
//--window setup
var width= 940, height= 480;
var w= Window("prueba", Rect(99, 99, width, height), false, scroll: true);
var u= UserView(w, Rect(0, 0, width*15, height));
var v= UserView(w, Rect(0, 0, width*20, height));

	//--variables

var getXValues = {|durations|
	durations.inject((durs: List [], val: 0), {|acc, dur|
		acc.durs.add(acc.val);
		acc.val = dur+acc.val;
		acc;
	}).durs;
};

//~x_values_V1= ~getXValues.(~line);
/*var canon = ~makeCanon.((
            cp: 32,
            melody: [
		(dur: 0.21, note: 60), (dur: 0.35, note: 61), (dur: 0.45, note: 62), (dur: 0.17, note: 63), (dur: 0.24, note: 59),
		(dur: 0.21, note: 60), (dur: 0.35, note: 62), (dur: 0.45 - 0.20, note: 62), (dur: 0.17 - 0.01, note: 65), (dur: 0.24 - 0.02, note: 52),
		(dur: 0.21, note: 60), (dur: 0.35, note: 63), (dur: 0.45 - 0.22, note: 62), (dur: 0.17 - 0.02, note: 66), (dur: 0.24 - 0.03, note: 53),
		(dur: 0.21, note: 60), (dur: 0.35, note: 64), (dur: 0.45 - 0.24, note: 62), (dur: 0.17 - 0.03, note: 67), (dur: 0.24 - 0.02, note: 54),
		(dur: 0.21, note: 60), (dur: 0.35, note: 65), (dur: 0.45 - 0.26, note: 62), (dur: 0.17 - 0.04, note: 68), (dur: 0.24 - 0.01, note: 55),
		(dur: 0.21, note: 60), (dur: 0.35, note: 66), (dur: 0.45 - 0.28, note: 62), (dur: 0.17 - 0.05, note: 69), (dur: 0.24 - 0.02, note: 56),
		(dur: 0.21, note: 60), (dur: 0.35, note: 67), (dur: 0.45 - 0.31, note: 62), (dur: 0.17 - 0.06, note: 71), (dur: 4, note: 57)
	],
            voices: [
                (tempo: 90, transp: 0),
                (tempo: 95, transp: -12),
                (tempo: 100, transp: 12),
                (tempo: 83, transp: 8)
            ]
        ));*/
var madeCanon =  ~makeCanon.(~melodyMaker.randomSymmetric4voices);
var canon = madeCanon.canon;
var data = madeCanon.data.postln;
var y_values_V1 = canon[0].notes;
var line = canon[0].durs;
var x_values_V1 = getXValues.(line);
var xCoord =[0,0,0,0];
var yCoord = [0,0,0,0];
var colors = [Color.green(0.8), Color.red(0.8), Color.blue(0.8), Color.yellow(0.9)];
var durTotal = (line.sum + 40)*1.5; // aquí va el total de duración de la pieza;
var durSize = width*10; // aqui va width pero expandido;
var stringCP = "CP position:"+canon[0].cp;
var stringVcs = "Voices:"+canon.size;
var stringTempos = "Tempos:"+data.voices.collect(_.tempo).sort();
var stringMelodia = "Melody:"+data.melody.collect(_.note).midinote.collect(_.replace(" ", ""));


var drawPoints = {
	|xVals, yVals, onset|

	xVals.size.do{|i|

		Pen.color = if( yVals[0]==(canon[0].notes[0]), {colors[0]}, {if(yVals[0]==canon[1].notes[0], {colors[1]}, if( yVals[0]==canon[2].notes[0], {colors[2]},{colors[3]}))});// set the Color


		// here the coordinates are expressed as an underlying map
		Pen.addWedge((xVals[i] + onset).linlin(0,(durTotal),10,durSize)@(yVals[i].linlin(20,120,480,0)), 4, 0pi, 2pi);
        Pen.perform(\fill);


	};

	(xVals.size-1).do{|i|
	Pen.line(
		Point((xVals[i] + onset).linlin(0,(durTotal),10,durSize),yVals[i].linlin(20,120,480,0)),
		Point((xVals[i+1] + onset).linlin(0,(durTotal),10,durSize),yVals[i+1].linlin(20,120,480,0))
	);
		Pen.strokeColor= if( yVals[0]==(canon[0].notes[0]), {colors[0]}, {if(yVals[0]==canon[1].notes[0], {colors[1]}, if( yVals[0]==canon[2].notes[0], {colors[2]},{colors[3]}))});


			Pen.stroke;
	};

	Pen.stringAtPoint("Temporal Canon Generator -"++" Alejandro Franco  &&   Diego Villaseñor", Point(10,20),color: Color.white);
	Pen.stringAtPoint(stringCP, Point(10,35),color: Color.white);
	Pen.stringAtPoint(stringVcs, Point(10,50),color: Color.white);
	Pen.stringAtPoint(stringTempos, Point(10,65),color: Color.white);
	Pen.stringAtPoint(stringMelodia, Point(10,80),color: Color.white);



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
				yCoord[index]=msg[1].linlin(20,120,480,0);
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



(// aquí se tiene que actualizar continuamente el scroller, en teoría pero la neta no tengo puta idea de como hacer eso;
v.action = {

			~scroller = Pbind(*[
				play: { v.view.visibleOrigin = Point( ~t - 0.2 max: 0 * 50, 0) },
				t:	Pseg([0, durSize], durSize),
				dur:	0.05
	]);


};
);




//--window management
//~scroller.play(AppClock);
u.clearOnRefresh= true;
w.background= Color.gray(0.05);
w.front;
u.animate= true;
CmdPeriod.doOnce({if(w.isClosed.not, {w.close; patterns.do(_.stop)})});

patterns.do(_.play)
)
