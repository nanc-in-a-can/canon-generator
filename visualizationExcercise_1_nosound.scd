s.boot;

// melodic values turned into x values
~y_values_V1= Array.fill(30, { [48, 55, 56, 60, 62, 63, 65, 67, 69, 71, 72, 74, 75].choose });

// durs
~line= Array.fill(30, { [1/4, 1/8, 1/16, 1/32, 1/5,1/3,1/6,1/7,1/9].choose })*2;

(
// default netadress for the pbind to send messages;
~netAddr_0 = NetAddr("127.0.0.1", 57120);
~pattern= Pbind(
                \instrument, \piano,
                \pan, 0,
                \dur, Pseq(~line,1),
                \freq, Pseq(~y_values_V1,inf),
                \out, 0,
                \amp, 1,
	/*this series will provide an Index for later processes*/
	\series, Pseries(0,1,inf),
	/*messages to change the point positions in the map below*/
	\coordinates, Pfunc({|event| ~netAddr_0.sendMsg('/event', event[\freq], event[\series], event[\freq])})

            );
);



// dur values turned into x values
( // assigning the duration values to the X axis (voice 1)
	~x_values_V1= Array.newClear(~line.size);

    ~oldNumber= 0;

		~line.size.do{|j|

	~x_values_V1.put(j,~oldNumber);

	~number= ~oldNumber + ~line[j];

	~oldNumber = ~number;
};
);


(//another definition of ~x_values_V1

~getXValues = {|durations|
	durations.inject((durs: List [], val: 0), {|acc, dur|
		acc.durs.add(acc.val);
		acc.val = dur+acc.val;
		acc;
	}).durs;
};

~x_values_V1= ~getXValues.(~line);

);

//Example of a visualization
(
	//--window setup
	var width= 840, height= 480;
	var w= Window("prueba", Rect(99, 99, width, height), false, scroll: true);
	var u= UserView(w, Rect(0, 0, width, height));

	//--variables
var line;
var xCoord = Array.fill(4, {~x_values_V1[0].linlin(0,12,10,840)}), yCoord =Array.fill(4, {~y_values_V1[0].linlin(20,120,0,480)});
var drawPoints = {
	|xVals, yVals|

	xVals.size.do{|i|

		Pen.color = Color.green(0.5);// set the Color
		// here the coordinates are expressed as an underlying map
		Pen.addWedge(xVals[i].linlin(0,12,10,840)@(yVals[i].linlin(20,120,0,480)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);

	};

};
// ~x_values_V1[0].linlin(0,12,10,840)

w.drawFunc = { // draw the points of the canon;
	drawPoints.(~x_values_V1, ~y_values_V1);
};


	//in U the present moment of the events will be emphasised visually in the map
	u.drawFunc= {


	var selectMoment = {|index, line|

		Pen.fillColor= Color(0.3,0.1,0.7);				//always fill with purple color

		// receive the data from the Pbind in realtime assigning global variables
		OSCdef(\test, {|msg, time, addr, recvPort| msg.postln;
			yCoord[index]=msg[1].linlin(20,120,0,480);
			xCoord[index]= line[msg[2]].linlin(0,12,10,840);
		},
		'/event', n);
		Pen.addWedge(Point(xCoord[index].postln, yCoord[index].postln), 6, 0pi,2pi);
		Pen.fill;
	};

	u.frameRate= 60;
	selectMoment.(0, ~x_values_V1);

	};

	//--window management
	u.clearOnRefresh= true;
//	u.background= Color.black;
	w.front;
	u.animate= true;
	CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});
~pattern.play;
)

Array.fill(4, {0})
