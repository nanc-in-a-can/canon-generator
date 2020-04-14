CanPlayer {
	var <>currentCanon, <>globalNextSoundAt, <>elapsed, <>numVoices, <>voicesState, <>newCanon, <>player, <>prEventPlayer;

	*prMakeNextStateForNewCanon {|newCanon, nextAt|
		^newCanon.inject(
			List [],
			{|acc, voice, voiceIndex|
				var res = voice.durs.inject(
					(nextSoundAt: 0, nextIndex: 0),
				{|result, dur, i|
					if(result.nextSoundAt >= nextAt,
						{result},
						{(
							nextSoundAt: result.nextSoundAt+dur,
							nextIndex: i + 1,
							data: voice,
							voiceIndex: voiceIndex
						)}
					)
				});
				acc.add(res);
			}
		)
	}

	*prCalculateNewState {|oldCanon, newCanon, nextAt/*in ms*/, elapsed /*in ms*/|
		var oldCanDur = oldCanon[0].durs.sum.postln;
		var newCanDur = newCanon[0].durs.sum.postln;
		var nextAtPercentage = (nextAt/1000)/oldCanDur;
		var elapsedPercentage = (elapsed/1000)/oldCanDur;
		var nextEventForNewCanon = newCanDur*nextAtPercentage;
		var elapsedForNewCanon = newCanDur*elapsedPercentage*1000;
		var newState = CanPlayer.prMakeNextStateForNewCanon(newCanon, nextEventForNewCanon);
		^(
			elapsed: elapsedForNewCanon,
			numVoices: newCanon.size,
			voicesState: newState
		);

	}

	*prInitVoicesState {|canon|
		^(0..canon.size - 1).inject(List [], {|acc, i|
			acc.add((
				voiceIndex: (i - (canon.size -1)).abs,
				data: canon[i],
				nextIndex: 0,
				nextSoundAt: canon[i].onset*1000, // in ms
				))
		});
	}

	*prDefaultEventPlayer {|event|
		(
		  instrument: \sin,
		  freq: event.note.midicps,
		  dur: event.dur,
		  amp: event.amp
		).play
	}

	*new {|def, canon, eventPlayer = ({|event| CanPlayer.prDefaultEventPlayer(event)})|
		^super.new.init(def, canon, eventPlayer);
	}

	*prChangeCanon {|canon|
		this.newCanon = canon;
		this.currentCanon = canon;
	}

	*prUpdateState {|newState|
		"uuuuuuuuuuuuuuuuuuuuupp".postln;
		this.numVoices.postln;
		this.newState.numVoices.postln;
		this.newCanon = nil;
		this.elapsed = newState.elapsed;
		this.numVoices = newState.numVoices;
		this.voicesState = newState.voicesState;
		"done".postln;
	}

	init {|def, canon, eventPlayer|
		this.currentCanon = canon;
		this.globalNextSoundAt = 0;
		this.elapsed = 0;
		this.numVoices = canon.size;
		this.voicesState = CanPlayer.prInitVoicesState(canon);
		this.newCanon = nil;
		this.prEventPlayer = eventPlayer;
		this.player = Tdef(def, {
			var finishedCanons = 0; //TODO make this more robust
			inf.do({|i|
				var iterateVoices = globalNextSoundAt <= elapsed;

				if(iterateVoices, { // basic optimization to avoid iteration of voicesState every 1ms
					var nextSoundsAt = List [];
					// elapsed.postln;
					voicesState.do({|voice, voiceIndex|
						nextSoundsAt.add(voice.nextSoundAt); // build a list of the nextSoundAt to get the next value for globalNextSoundAt

						if(voice.nextSoundAt <= elapsed, { // check if `voice` shouldPlay it's next sound
							var currentIndex = voice.nextIndex;
							var dur = voice.data.durs[currentIndex] ? inf;
							var note = voice.data.notes[currentIndex];
							var amp = voice.data.amps[currentIndex].postm("AMP");
							var event = (
								dur: if(dur === inf, {0}, {dur}),
								note: note,
								amp: amp,
								voiceIndex: voiceIndex,
								eventIndex: currentIndex
							);
							event.postln;
							// update voice state
							voice.nextIndex = voice.nextIndex + 1;
							voice.nextSoundAt = elapsed + (dur * 1000);

							if(dur == inf,
								{finishedCanons = finishedCanons + 1},
								{this.prEventPlayer.(event)}
							);
						});
					});

					//update globalNextSoundAt
					this.globalNextSoundAt = nextSoundsAt.minItem
					//.postm("nextAt")
					;
				});

				this.elapsed = elapsed+1; // update elapsed time, ~tempoScale changes the value by which `elapsed` is updated, by this, the "interal time of the canon" go faster or slower.  If ~tempoScale is > 1 it goes faster than it's original tempo, if < 1 it goes slower.
				if(this.newCanon.isNil.not,
					{
						"updating".postln;
						this.prUpdateState(CanPlayer.calculateNewState(this.canon, this.newCanon, this.globalNextSoundAt, this.elapsed));
						"updated".postln;});
				if(finishedCanons >= this.numVoices, {
					this.elapsed = 0;
					this.voicesState = CanPlayer.prInitVoicesState(this.currentCanon);
					this.numVoices = this.currentCanon.size;
					finishedCanons = 0;
					this.globalNextSoundAt = 0;
				});
				0.001.wait; // iterate every 1ms
			})
		});
	}

	onEvent {|eventPlayer|
		this.prEventPlayer = eventPlayer;
	}

	// player (Task) methods
	play {
		this.player.play;
	}

	stop {
		this.player.stop;
	}

	reset {
		this.player.reset;
	}

	start {
		this.player.start;
	}

	resume {
		this.player.resume;
	}

	pause {
		this.player.pause;
	}
}
