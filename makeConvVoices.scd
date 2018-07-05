//~makeConvVoices :: ([Float], [Float], [Float]) -> [(tempo, transp, amp)]
(
~makeConvVoices = { | tempo_arr, transp_arr, amp_arr = ([])|
	amp_arr.postln;
    [tempo_arr.size, transp_arr.size].minItem.collect({|i|
		(tempo: tempo_arr[i], transp: transp_arr[i], amp: amp_arr[i] ? 1)
    })
};
)