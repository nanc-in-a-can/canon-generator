// melodic values turned into x values
~y_values_V1= Array.fill(30, { [48, 55, 56, 60, 62, 63, 65, 67, 69, 71, 72, 74, 75].choose });

// durs
~line= Array.fill(30, { [1/4, 1/8, 1/16, 1/32, 1/5,1/3,1/6,1/7,1/9].choose });

// dur values turned into x values
( // assigning the duration values to the X axis (voice 1)
	~x_values_V1= Array.newClear(~line.size);

    ~oldNumber= ~distances1;

		~line.size.do{|j|

	~x_values_V1.put(j,~oldNumber);

	~number= ~oldNumber + ~line[j];

	~oldNumber = ~number;
};
);

//Example of a visualization
(

	//--window setup
	var width= 640, height= 480;
	var w= Window("prueba", Rect(99, 99, width, height), false, scroll: true);
	var u= UserView(w, Rect(0, 0, width, height));

	//--variables
var theta= 0; // counter

w.drawFunc = { // draw the points of the canon;

		20.do{|i|
        // set the Color
		Pen.color = Color.green(0.5);
		Pen.addWedge(~x_values_V1[i].linlin(0,2.5,5,640)@(~y_values_V1[i].linlin(20,120,0,480)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);


	};
};

	//--line that represents present time
	u.drawFunc= {
	//	Pen.translate(width*0.5, height*0.5);		//offset drawing to the centre
		Pen.strokeColor= Color.red;				//always fill with white color
	Pen.line(Point(0+theta,0), Point(0+theta,480));
	theta= theta + 1;
	theta.postln;
	Pen.stroke

	};

	//--window management
	u.clearOnRefresh= true;
//	u.background= Color.black;
	w.front;
	u.animate= true;
	CmdPeriod.doOnce({if(w.isClosed.not, {w.close})});

)

