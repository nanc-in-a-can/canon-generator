CanPlayer {
	classvar <>players;
	var <>def, <>currentCanon, <>globalNextSoundAt, <>elapsed, <>numVoices, <>finishedVoices, <>isFinished, <>voicesState, <>newCanon, <>player, <>prOnEvent, <>prSpeed = 1, <>repeat, <>instruments, <>osc, <>meta;

	*initClass {
		players = Dictionary.new;
	}

	*new {|
		def,
		canon,
		repeat = 1,
		onEvent =({|event| 	CanPlayer.prDefaultEventPlayer(event)}),
		instruments = ([\sin]),
		osc = nil,
		meta = (Event.new)|
		^super.new.init(def, canon, repeat, onEvent, instruments, osc, meta);
	}

	init {|def, canon, repeat, onEvent, instruments, osc, meta|
		var player = CanPlayer.get(def);
		^if(player.isNil,
			{this.prInit(def, canon, repeat, onEvent, instruments, osc, meta)},
			{
				player.changeCanon(canon);
				if(player.isFinished == true, {
					player.repeat = repeat;
					player.reset;
				});
				player;
			}
		);
	}

	prInit {|def, canon, repeat, onEvent, instruments, osc, meta|
		this.def = def;
		this.currentCanon = canon;
		this.newCanon = nil;
		this.repeat = repeat;
		this.prOnEvent = onEvent;
		this.instruments = instruments;
		this.osc = osc;
		this.meta = meta;
		this.globalNextSoundAt = 0;
		this.elapsed = 0;
		this.numVoices = canon.size;
		this.voicesState = CanPlayer.prInitVoicesState(canon);
		this.finishedVoices = 0;
		this.player = Tdef(def, {
			inf.do({|i|
				var iterateVoices = globalNextSoundAt <= elapsed;
				var finishedVoices = 0;

				if(iterateVoices, { // basic optimization to avoid iteration of voicesState every 1ms
					var nextSoundsAt = List [];
					voicesState.do({|voice, voiceIndex|
						// build a list of the nextSoundAt to get the next value for globalNextSoundAt
						if(voice.isFinished.not,
							{nextSoundsAt.add(voice.nextSoundAt)},
							{finishedVoices = finishedVoices + 1}
						);
						if(voice.isFinished.not && (voice.nextSoundAt <= elapsed), { // check if `voice` shouldPlay it's next sound
							var currentIndex = voice.nextIndex;
							var dur = voice.data.durs[currentIndex] ? inf;
							var note = voice.data.notes[currentIndex];
							var amp = voice.data.amps[currentIndex];
							var event = (
								dur: if(dur === inf, {0}, {dur}),
								note: note,
								amp: amp,
								voiceIndex: voiceIndex,
								eventIndex: currentIndex,
								canon: this.currentCanon,
								instruments: this.instruments,
								osc: this.osc,
								meta: this.meta
							);
							// update voice state
							voice.nextIndex = voice.nextIndex + 1;
							voice.nextSoundAt = elapsed + (dur * 1000);

							if(dur != inf,
								{this.prOnEvent.(event)},
								{voice.isFinished = true});
						});
					});

					//update globalNextSoundAt and finishedVoices
					this.globalNextSoundAt = nextSoundsAt.minItem;
					this.finishedVoices = finishedVoices;
				});

				this.elapsed = (elapsed+(1*this.prSpeed));
				if(this.newCanon.isNil.not, {this.prUpdateState});
				if(this.finishedVoices >= this.numVoices, {
					this.repeat = this.repeat - 1;
					if(this.repeat > 0,
						{
							this.elapsed = 0;
							this.voicesState = CanPlayer.prInitVoicesState(this.currentCanon);
							this.numVoices = this.currentCanon.size;
							this.finishedVoices = 0;
							this.globalNextSoundAt = 0;
						},
						{this.stop; this.isFinished = true;})

				});
				0.001.wait; // iterate every 1ms
			})
		});
		CanPlayer.players.put(def, this)
	}

	// getters and setters
	*get{|def|
		^CanPlayer.players.at(def);
	}

	onEvent {|eventPlayer|
		this.prOnEvent = eventPlayer;
	}

	speed {|speed|
		^if(speed.isNil,
			 {this.prSpeed},
			 {
				 this.prSpeed = speed;
				 this
			 }
		)
	}

	// player (Task) methods
	play {
		if(this.isFinished == true, {this.reset});
		if(this.player.isPlaying.not, {this.prUpdateState});
		this.player.play;
	}

	stop {
		this.player.stop;
	}

	reset {
		this.elapsed = 0;
		this.voicesState = CanPlayer.prInitVoicesState(this.currentCanon);
		this.numVoices = this.currentCanon.size;
		this.finishedVoices = 0;
		this.globalNextSoundAt = 0;
		this.newCanon = nil;
		this.isFinished = false;
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

	//private and pure methods
	*prMakeNextStateForNewCanon {|newCanon, nextAt|
		^newCanon.inject(
			List [],
			{|acc, voice, voiceIndex|
				var res = voice.durs.inject(
					(isFinished: false, nextSoundAt: 0, nextIndex: 0, data: voice, voiceIndex: voiceIndex),
				{|result, dur, i|
					if(result.nextSoundAt >= nextAt,
						{result},
						{
							var nextIndex = i + 1;
							(
								isFinished: nextIndex >= voice.size,
								nextSoundAt: result.nextSoundAt+dur,
								nextIndex: nextIndex,
								data: voice,
								voiceIndex: voiceIndex
							);
						}
					)
				});
				acc.add(res);
			}
		)
	}

	*prCalculateNewState {|oldCanon, newCanon, nextAt/*in ms*/, elapsed /*in ms*/|
		var oldCanDur = oldCanon[0].durs.sum;
		var newCanDur = newCanon[0].durs.sum;
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
		^canon.inject(List [], {|acc, voice, i|
			acc.add((
				isFinished: false,
				voiceIndex: i,
				data: voice,
				nextIndex: 0,
				nextSoundAt: voice.onset*1000, // in ms
			))
		});
	}

	*setupInCan {|def, canon, instruments, repeat, osc, meta|
		var onEvent = if(meta.onEvent.isFunction,
			{meta.onEvent},
			{{|event| CanPlayer.prDefaultEventPlayer(event)}}
		);
		var def_ = def ? UniqueID.next.asSymbol;

		^CanPlayer(def_, canon, repeat, onEvent, instruments, osc, meta)
	}

	// impure
	*prDefaultEventPlayer {|event|
		(
			instrument: event.instruments.wrapAt(event.voiceIndex),
			freq: event.note.midicps,
			dur: event.dur,
			amp: event.amp
		).play
	}

	changeCanon {|canon|
		this.newCanon = canon;
		this.currentCanon = canon;
	}

	prUpdateState {
		var newState = CanPlayer.prCalculateNewState(this.currentCanon, this.newCanon, this.globalNextSoundAt, this.elapsed);
		this.newCanon = nil;
		this.elapsed = newState.elapsed;
		this.numVoices = newState.numVoices;
		this.voicesState = newState.voicesState;
	}

}
