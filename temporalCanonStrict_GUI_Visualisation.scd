(// GUI and visualization for 4 voice temporal Canon;

( // Assigning the melodic values to the Y axis of the
~y_values_V1= ~melody_data[0];

~y_values_V2= ~melody_data[1];

~y_values_V3= ~melody_data[2];

~y_values_V4= ~melody_data[3];

);


( // assigning the duration values to the X axis (voice 1)
	~x_values_V1= Array.newClear(~voice_data[0].size);

    ~oldNumber= ~distances1;

		~voice_data[0].size.do{|j|

	~x_values_V1.put(j,~oldNumber);

	~number= ~oldNumber + ~voice_data[0][j];

	~oldNumber = ~number;
};
);

( // assigning the duration values to the X axis (voice 2)
	~x_values_V2= Array.newClear(~voice_data[1].size);

    ~oldNumber= ~distances2;

		~voice_data[1].size.do{|j|

	~x_values_V2.put(j,~oldNumber);

	~number= ~oldNumber + ~voice_data[1][j];

	~oldNumber = ~number;
};
);

( // assigning the duration values to the X axis (voice 3)
	~x_values_V3= Array.newClear(~voice_data[2].size);

    ~oldNumber= ~distances3;

		~voice_data[2].size.do{|j|

	~x_values_V3.put(j,~oldNumber);

	~number= ~oldNumber + ~voice_data[2][j];

	~oldNumber = ~number;
};
);

( // assigning the duration values to the X axis (voice 4)
	~x_values_V4= Array.newClear(~voice_data[3].size);

    ~oldNumber= ~distances4;

		~voice_data[3].size.do{|j|

	~x_values_V4.put(j,~oldNumber);

	~number= ~oldNumber + ~voice_data[3][j];

	~oldNumber = ~number;
};
);
);

//probando


(
var boton_Start_stop, boton_RecStart_stop, timePointsText, timePointsField, convergencePointText, convergencePointField, tempoText, voice_1, voice1_tempo, voice_2, voice2_tempo, voice_3, voice3_tempo, voice_4, voice4_tempo, pieceDuration;

w = Window("Canon temporal a 4 voces", Rect(5,150,1400,650), true, true, s, true).front;

//translating time values to space values;
pieceDuration= ~x_values_V1[~x_values_V1.size -1].linlin(0,120,0,4500);


// this pbind "scrolls" the screen in order to be always showing the present events of the canon
~scroller = Pbind(*[
				play: { w.view.visibleOrigin = Point( ~t - 0.2 max: 0 * 30, 0) },
				t:	Pseg([0, pieceDuration], pieceDuration),
				dur:	0.05
			]);

// start button actions
boton_Start_stop = Button.new(w, Rect(0, 600, 4300, 20));
        boton_Start_stop.states = ([["Start",Color.black, Color.green],["Stop",Color.black, Color.red]]);

boton_Start_stop.action =  { case {boton_Start_stop.value == 1}
	{~reverb= Synth(\reverb); Pdef(\four_v_temporalCanon_v2).play; ~scroll=~scroller.play(AppClock); /*AppClock.play(~showMe)*/

	// the line that indicates the present moments is a routine embedded in ~showMe
		fork { while { ~showMe.isClosed.not }
			{ defer {  ~showMe.refresh};
				(~x_values_V4[299]/~x_values_V4[299].linlin(0,120,0,4500)).wait; } }};

	case {boton_Start_stop.value == 0}
	{  Pdef(\four_v_temporalCanon_v2).stop; ~reverb.set(\gate, 0); ~scroll.stop; /*~shMe.stop, idear un modo de detener esta rutina*/} };

boton_RecStart_stop = Button.new(w, Rect(0, 575, 4300, 20));
        boton_RecStart_stop.states = ([["Start & Record",Color.black, Color.yellow],["Stop",Color.black, Color.red]]);

boton_RecStart_stop.action =  { case {boton_RecStart_stop.value == 1}
	{ s.record; ~reverb= Synth(\reverb); Pdef(\four_v_temporalCanon_v2).play };

	case {boton_RecStart_stop.value == 0}
	{ Pdef(\four_v_temporalCanon_v2).stop; ~reverb.set(\gate, 0); s.stopRecording };
	~showMe.clear
};


(
timePointsText = StaticText(w, Rect(850, 5, 190, 30));
timePointsText.string = "Number of TimePoints";
);

(
timePointsField =     TextField(w, Rect(890, 30, 50, 20));
timePointsField.value = ~tp;
timePointsField.action = {arg numb; numb.value.postln; ~tp = numb.value };
);

(
convergencePointText = StaticText(w, Rect(600, 5, 190, 30));
convergencePointText.string = "Position of Convergence Point";
);

(
convergencePointField =     TextField(w, Rect(640, 30, 50, 20));
convergencePointField.value = ~cp;
convergencePointField.action = {arg numb; numb.value.postln; ~cp = numb.value };
);


(
tempoText = StaticText(w, Rect(18, 25, 190, 30));
tempoText.string = "Tempo";
);

(
voice_1 = StaticText(w, Rect(60, 5, 130, 30));
voice_1.string = "1st Voice Data";
);

(
voice1_tempo =     TextField(w, Rect(80, 30, 50, 20));
voice1_tempo.value = ~tempo1;
voice1_tempo.action = {arg numb; numb.value.postln; ~tempo1 = numb.value };
);

(
voice_2 = StaticText(w, Rect(170, 5, 130, 30));
voice_2.string = "2nd Voice Data";
);

(
voice2_tempo =     TextField(w, Rect(190, 30, 50, 20));
voice2_tempo.value = ~tempo2;
voice2_tempo.action = {arg numb; numb.value.postln; ~tempo2 = numb.value };
);

(
voice_3 = StaticText(w, Rect(290, 5, 130, 30));
voice_3.string = "3rd Voice Data";
);

(
voice3_tempo =     TextField(w, Rect(310, 30, 50, 20));
voice3_tempo.value = ~tempo3;
voice3_tempo.action = {arg numb; numb.value.postln; ~tempo3 = numb.value };
);

(
voice_4 = StaticText(w, Rect(400, 5, 130, 30));
voice_4.string = "4th Voice Data";
);

(
voice4_tempo =     TextField(w, Rect(420, 30, 50, 20));
voice4_tempo.value = ~tempo4;
voice4_tempo.action = {arg numb; numb.value.postln; ~tempo4 = numb.value };
);
w.front;

u= UserView(w, Rect(29,70,4500,450));


(
//t = Slider(w, Rect(0, 650, 4500, 400));
//t.orientation = \horizontal;
w.drawFunc = {
    Pen.translate(50, -250);

// aquí se declara la rutina de la línea
	~showMe= u.drawFunc = Routine {

	4600.do{|i|
		Pen.line(
		Point(i, 0),
		Point(i,1280)
		);
		Pen.fillStroke;
	1000.wait;

	};

};

	// aqui te quedaste!!!
/*~showMe = Pbind(*[
				play: { u.drawFunc = Routine {
			4000.do{
.
		Pen.line(
		Point( ~t, 0),
		Point( ~t,1280)
		);

		Pen.fillStroke;
			};
		};},
				t:	Pseg([0, pieceDuration], pieceDuration),
				dur:	0.05
			]);*/

	Pen.rotate(0.0pi);
	// here you assign a wedge to each of the coodinates that form the events (x and y axis)
	~tp.do{|i|
        // set the Color
		Pen.color = Color.green(0.5);
		Pen.addWedge(~x_values_V1[i].linlin(0,120,0,4500)@(~y_values_V1[i].linlin(20,120,850,1)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);


	};

	~tp.do{|i|
        // set the Color
		Pen.color = Color.red(0.5);
		Pen.addWedge(~x_values_V2[i].linlin(0,120,0,4500)@(~y_values_V2[i].linlin(20,120,850,1)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);


	};

	~tp.do{|i|
        // set the Color
		Pen.color = Color.blue(0.5);
		Pen.addWedge(~x_values_V3[i].linlin(0,120,0,4500)@(~y_values_V3[i].linlin(20,120,850,1)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);


	};

	~tp.do{|i|
        // set the Color
		Pen.color = Color.magenta(0.5);
		Pen.addWedge(~x_values_V4[i].linlin(0,120,0,4500)@(~y_values_V4[i].linlin(20,120,850,1)), 4, 0pi, 2pi);
        Pen.perform([ \fill].choose);


	};
// here you assign values to the lines between wedges
	(~tp-1).do{|i|
		Pen.strokeColor = Color.green(0.8);
		if(i==0, {
			Pen.moveTo(~x_values_V1[i].linlin(0,120,0,4500)@(~y_values_V1[i].linlin(20,120,850,1)))
		});

		Pen.lineTo(~x_values_V1[i+1].linlin(0,120,0,4500)@(~y_values_V1[i+1].linlin(20,120,850,1)));
        Pen.perform([\stroke].choose);
	Pen.moveTo(~x_values_V1[i+1].linlin(0,120,0,4500)@(~y_values_V1[i+1].linlin(20,120,850,1)));
	};
	(~tp-1).do{|i|
		Pen.strokeColor = Color.red(0.8);
		if(i==0, {
			Pen.moveTo(~x_values_V2[i].linlin(0,120,0,4500)@(~y_values_V2[i].linlin(20,120,850,1)))
		});

		Pen.lineTo(~x_values_V2[i+1].linlin(0,120,0,4500)@(~y_values_V2[i+1].linlin(20,120,850,1)));
        Pen.perform([\stroke].choose);
	Pen.moveTo(~x_values_V2[i+1].linlin(0,120,0,4500)@(~y_values_V2[i+1].linlin(20,120,850,1)));
	};
	(~tp-1).do{|i|
		Pen.strokeColor = Color.blue(0.8);
		if(i==0, {
			Pen.moveTo(~x_values_V3[i].linlin(0,120,0,4500)@(~y_values_V3[i].linlin(20,120,850,1)))
		});

		Pen.lineTo(~x_values_V3[i+1].linlin(0,120,0,4500)@(~y_values_V3[i+1].linlin(20,120,850,1)));
        Pen.perform([\stroke].choose);
	Pen.moveTo(~x_values_V3[i+1].linlin(0,120,0,4500)@(~y_values_V3[i+1].linlin(20,120,850,1)));
	};
	(~tp-1).do{|i|
		Pen.strokeColor = Color.magenta(0.8);
		if(i==0, {
			Pen.moveTo(~x_values_V4[i].linlin(0,120,0,4500)@(~y_values_V4[i].linlin(20,120,850,1)))
		});

		Pen.lineTo(~x_values_V4[i+1].linlin(0,120,0,4500)@(~y_values_V4[i+1].linlin(20,120,850,1)));
        Pen.perform([\stroke].choose);
	Pen.moveTo(~x_values_V4[i+1].linlin(0,120,0,4500)@(~y_values_V4[i+1].linlin(20,120,850,1)));
	};

};
w.refresh;
)

);

