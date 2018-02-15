
s.boot;



(
// default netadress for the pbind to send messages;
~netAddr_0 = NetAddr("127.0.0.1", 57120);

);


(//another definition of ~x_values_V1


);

//~makeCanon.(~melodyMaker.simple4NoteMelody(2))[0]





//Example of a visualization
(
//--window setup
var width= 840, height= 480;
var w= Window("prueba", Rect(99, 99, width, height), false, scroll: true);
var u= UserView(w, Rect(0, 0, width, height));

	//--variables

var getXValues = {|durations|
	durations.inject((durs: List [], val: 0), {|acc, dur|
		acc.durs.add(acc.val);
		acc.val = dur+acc.val;
		acc;
	}).durs;
};

//~x_values_V1= ~getXValues.(~line);
var canon = ~makeCanon.(~melodyMaker.simple4NoteMelody(3));
var y_values_V1 = canon[0].notes;
var line = canon[0].durs;
var x_values_V1 = getXValues.(line);
var xCoord =[0,0,0,0];
var yCoord = [0,0,0,0];

var drawPoints = {
	|xVals, yVals, onset|

	xVals.size.do{|i|

		Pen.color = Color.green(0.5);// set the Color
		// here the coordinates are expressed as an underlying map
		Pen.addWedge((xVals[i] + onset).linlin(0,12,10,840)@(yVals[i].linlin(20,120,0,480)), 4, 0pi, 2pi);
        Pen.perform([\fill].choose);

	};

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
				~netAddr_0.sendMsg(("/event"++index), event[\freq], event[\series], event[\freq])
		})
	)
});


w.drawFunc = { // draw the points of the canon;
canon.do({|line| drawPoints.(getXValues.(line.durs), line.notes, line.onset)});
};


//in U the present moment of the events will be emphasised visually in the map
u.drawFunc= {

	var selectMoment = {|index, line, onset|

		Pen.fillColor= Color(0.3,0.1,0.7);				//always fill with purple color

		// receive the data from the Pbind in realtime assigning global variables
		OSCdef("test"++index, {|msg, time, addr, recvPort| msg.postln;
			// if(msg[2] !== 1, {
				yCoord[index]=msg[1].linlin(20,120,0,480);
				xCoord[index]= (line[msg[2]] + onset).linlin(0,12,10,840);

		// })
		},
		("/event"++index), n);
		Pen.addWedge(Point(xCoord[index], yCoord[index]), 6, 0pi,2pi);
		Pen.fill;
	};

	u.frameRate= 60;
	canon.do({|line, i| selectMoment.(i, [0]++getXValues.(line.durs), line.onset)})
};

//--window management
u.clearOnRefresh= true;
//	u.background= Color.black;
w.front;
u.animate= true;
CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});

patterns.do(_.play)
)
