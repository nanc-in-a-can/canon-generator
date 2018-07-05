//~makeConvVoices ::[Float] -> [Float] -> [(tempo, transp)]
(
~makeConvVoices = { | tempo_arr, transp_arr amp_arr|
    [tempo_arr.size, transp_arr.size].minItem.collect({|i|
		(tempo: tempo_arr[i], transp: transp_arr[i], amp: amp_arr[i] ? 1)
    })
};
)