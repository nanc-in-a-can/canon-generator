

+ThePresetCan {
	// pyramidal melody

	*pyramidCanon {

		^Can.converge(
        	cp: 600,
        	melody: Can.melody(
        		(16..40).pyramid.reciprocal.reverse.mirror,
				((16..40).pyramidg.collect({|arr, i| arr+i})*12).flatten.reverse.mirror.cpsmidi
        	),
        	voices: [
        		(tempo: 120*7/12, transp: 0),
                (tempo: 120*11/12, transp: 1),
                (tempo: 120*13/12, transp: 2),
                (tempo: 120*17/12, transp: 3),
        		(tempo: 120*19/12, transp: 4),
        	    (tempo: 120*23/12, transp: 5)
        	]
        )


	}

}