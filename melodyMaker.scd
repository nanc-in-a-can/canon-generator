(
~melodyMaker = (
	randomSymmetric4voices: {
        var tp, 
            tempo1,
            tempo2, 
            tempo3, 
            tempo4, 
            timeSpan, 
            rhythm, 
            line1, 
            line2, 
            line3, 
            line4, 
            cp, 
            bcp1, 
            bcp2, 
            bcp3, 
            bcp4, 
            melody,
            melody1, 
            melody2, 
            melody3, 
            melody4, 
            cP1, 
            makeTempo, 
            makeBcp;
        // number of beats (timepoints in the structure)
        tp= 300; // -1 ;


        makeTempo = {|speed| 60/(speed/4)};

        tempo1= makeTempo.(60);  /*change the tempo here, declare the value of a 1/4 figure*/
        tempo2= makeTempo.(65);  /*change the tempo here, declare the value of a 1/4 figure*/
        tempo3= makeTempo.(57);  /*change the tempo here, declare the value of a 1/4 figure*/
        tempo4= makeTempo.(63);  /*change the tempo here, declare the value of a 1/4 figure*/

        timeSpan= [(1),(1/4),(1/6),  (1/8),(1/9),(1/10),(1/11),(1/12),(1/13),(1/14),(1/15),(1/16),(1/17),(1/18),(1/19),  (1/20),(1/24),(1/32)];

        // choose a position for each rhythmic value throughout a weighted randomised process
        rhythm = tp.collect({ timeSpan.wchoose([1,5,4, 10,5,8,5,8,5,6,5,10,4,4,4, 8,8,10].normalizeSum) });


        cp= (tp/2); // aquí podrías cambiar el valor;

        makeBcp = {|line| line.copyRange(0, (line.size - cp - 2).asInteger)};


        // melodic patterns for the lines;


        line1= rhythm.collect(_*tempo1);
        line2= rhythm.collect(_*tempo2);
        line3= rhythm.collect(_*tempo3);
        line4= rhythm.collect(_*tempo4);

        cP1= [70];

        melody= makeBcp.(line1).collect({[45,46,50,52.5,53,55.2,57,58,60.3,62,63,65.5].wchoose([4,3,8,2,4,2,7,5,2,5,3,3].normalizeSum)});
        melody1 = (melody+12)++cP1++(melody.reverse)++([melody[0]]);

        (
            tp: tp,
            bcp1: makeBcp.(line1),
            bcp2: makeBcp.(line2),
            bcp3: makeBcp.(line3),
            bcp4: makeBcp.(line4),
            line1: line1,
            line2: line2,
            line3: line3,
            line4: line4,
            melody1:  melody1,
            melody2:  melody1 - 12,
            melody3:  melody1 + 12,
            melody4:  melody1 + 8
        )

	}
)
)