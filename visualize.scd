//Example of a visualization
(
~visualize = { |madeCanon, autoScroll=true|

	//--window setup
	var width= 940, height= 580;
	var w= Window("Nanc in a Can - Canon generator", Rect(99, 99, width, height), true, scroll: true);
	var u= UserView(w, Rect(0, 0, width*220, height));

	//--variables
	var getXValues = {|durations|
		durations.inject((durs: List [], val: 0), {|acc, dur|
			acc.durs.add(acc.val);
			acc.val = dur+acc.val;
			acc;
		}).durs;
	};
	var canon = madeCanon.canon;
	var data = madeCanon.data.postln;
	var y_values_V1 = canon[0].notes;
	var line = canon[0].durs;
	var x_values_V1 = getXValues.(line);
	var xCoord = canon.size.collect({0});
	var yCoord = canon.size.collect({0});
	var durTotal = Array.fill(canon.size, {|i|  canon[i].durs.sum  }).sort[canon.size-1];
	// aquí va el total de duración de la pieza;
	var durSize = durTotal*40; // aqui va width pero expandido;
	var numberOfScreens = durSize/width;
	var scroller = Pbind(*[
		play: { w.view.visibleOrigin = Point( if((~t*width) > (width/2), {~t*width - (width/2)}, {0}), 0) },
		t:	Pseg([0,1*numberOfScreens], durTotal),
		dur: 1/60
	]);
	var maxY= Array.fill(canon.size, {|i|  canon[i].notes.flatten.maxItem }).sort[canon.size-1]+5;
	var minY= Array.fill(canon.size, {|i|  canon[i].notes.flatten.minItem}).sort[0]-10;
	var stringCP = "CP position:"+canon[0].cp;
	var stringVcs = "Voices:"+canon.size;
	var stringTempos = "Tempos:"+data.voices.collect(_.tempo).sort();
	var fromChord = {
		|note_or_chord|
		if(note_or_chord.size > 0, {note_or_chord[0]}, {note_or_chord})
	};
	var colores= [Color.green(0.8), Color.red(0.8), Color.blue(0.8), Color.yellow(0.8), Color.new255(160, 32, 240),Color.new255(205, 70, 20),Color.new255(255, 192, 203),Color.new255(150, 150, 150),Color.new255(209, 166, 102),Color.new255(173, 216, 230)]; // hardcoded colours: green, red, blue, yellow, purple, orange, pink, grey, brown, light blue;
	var colorExtra= (0..(canon.size)).collect({|n, i| [colores[i%10].vary].wrapAt(i)});
	var colors= colores++colorExtra;

	var drawPoints = {
		|xVals, yVals, onset, canonIndex|
		var yPoints = yVals.flatten;
		var xPoints = xVals.collect({|xVal, i|
			if( yVals[i].isArray,
				{[xVal].stutter(yVals[i].size)},
				{[xVal]}
			)
		})
		.flatten;

		Pen.stringAtPoint(
			"Temporal Canon Generator -"++" Alejandro Franco  &&   Diego Villaseñor",
			Point(10,20),color: Color.grey(0.7)
		);
		Pen.stringAtPoint(stringCP, Point(10,35),color: Color.white);
		Pen.stringAtPoint(stringVcs, Point(10,50),color: Color.white);
		Pen.stringAtPoint(stringTempos, Point(10,65),color: Color.white);

		xPoints.size.do{|i|
			Pen.color= colors[canonIndex];
			Pen.strokeColor= colors[canonIndex];
			Pen.perform(\fill);

			// here the coordinates are expressed as an underlying map
			if(yPoints[i] != \rest, {
				Pen.addWedge((xPoints[i] + onset).linlin(0,(durTotal),10,durSize)@(yPoints[i].linlin(minY,maxY,480,0)), 4, 0pi, 2pi);
			});
		};

		(xPoints.size-1).do{|i|
			Pen.color= colors[canonIndex];
			Pen.strokeColor= colors[canonIndex];
			Pen.width= 0.3;
			Pen.stroke;

			if( xPoints[i] == xPoints[i+1],
				{
					Pen.line(
						Point((xPoints[i]+ onset).linlin(0,(durTotal),10,durSize), yPoints[i].linlin(minY,maxY,480,0)),
						Point((xPoints[i+1] + onset).linlin(0,(durTotal),10,durSize), yPoints[i+1].linlin(minY,maxY,480,0))
					);
				}
			);
		};

		(xVals.size-1).do{|i|
			var hasNoRests = (yVals[i] != \rest) && (yVals[i+1] != \rest);
			if(hasNoRests,
				{
					Pen.width= 1;
					Pen.stroke;
					Pen.line(
						Point((xVals[i] + onset).linlin(0,(durTotal),10,durSize), fromChord.(yVals[i]).linlin(minY,maxY,480,0)),
						Point((xVals[i+1] + onset).linlin(0,(durTotal),10,durSize), fromChord.(yVals[i+1]).linlin(minY,maxY,480,0))
					);
				}
			)
		};

		1.do{
			//  here a line marks the CP;
			Pen.width= 0.3;
			Pen.strokeColor= Color.gray;

			Pen.stringAtPoint("Point of Convergence",
				Point((canon[0].bcp + canon[0].onset + 0.2).linlin(0,(durTotal),10,durSize),maxY.linlin(minY,maxY,480,0)),
				color: Color.gray
			);

			Pen.line(
				Point((canon[0].bcp + canon[0].onset).linlin(0,(durTotal),10,durSize),minY.linlin(minY,maxY,480,0)),
				Point((canon[0].bcp + canon[0].onset).linlin(0,(durTotal),10,durSize),maxY.linlin(minY,maxY,480,0))
			);

			Pen.stroke;
		};
	};

	var patterns = canon.collect({|line, index|
		Pbind(
			\instrument, \pianola,
			\dur, Pseq([line.onset.postln] ++ line.durs, 1),
			\midinote, Pseq([\rest]++line.notes,inf),
			\out, [0, /*~reverbBus.index*/],
			\amp, 1,
			\pan, 0,
			/*this series will provide an Index for later processes*/
			\series, Pseries(0,1,inf),
			/*messages to change the point positions in the map below*/
			\coordinates, Pfunc({|event|
				NetAddr("127.0.0.1", 57120).sendBundle(s.latency, [("/event"++index), if(event[\midinote].isArray, {event[\midinote][0]}, {event[\midinote]}), event[\series], event[\dur]])
			})
		)
	});

	var canonWithXValues = canon.collect({|line| (xValues: [0]++getXValues.(line.durs), onset: line.onset)});

	var playOnce = {|fn|
		var hasPlayed = false;
		{
			if(hasPlayed.not,
				{
					hasPlayed = true;
					fn.();
				}
			);
		}
	};

	var playPatterns = playOnce.({ patterns.do(_.play); });

	w.drawFunc = { // draw the points of the canon;
		canon.do({|line, canonIndex|
			drawPoints.(getXValues.(line.durs), line.notes, line.onset, canonIndex)
		});
	};

	u.drawFunc= {//in U the present moment of the events will be emphasised visually in the map
		var selectMoment = {|index, line, onset|
			Pen.fillColor= colors[index].blend(Color.white, 0.4); //always fill with grey

			// receive the data from the Pbind in realtime assigning global variables
			OSCdef("test"++index,
				{|msg, time, addr, recvPort|
					// msg.postln;
					if(msg[1] !== \rest, {
						yCoord[index]=msg[1].linlin(minY,maxY,480,0);
						xCoord[index]= (line[msg[2]] + onset).linlin(0,(durTotal),10,durSize);
					})
				},
				("/event"++index)
			);
			Pen.addWedge(Point(xCoord[index], yCoord[index]), 7, 0pi, 2pi);
			Pen.fill;
		};

		u.frameRate= 28;
		canonWithXValues.do({|line, i| selectMoment.(i, line.xValues, line.onset)});
		playPatterns.()
	};

	//--window management
	u.clearOnRefresh= true;
	w.background= Color.gray(0.05);
	w.front;
	u.animate= true;

	CmdPeriod.doOnce({if(w.isClosed.not, {w.close; patterns.do(_.stop)})});

	if( autoScroll == true, {scroller.play(AppClock)});
	nil;
};
);
