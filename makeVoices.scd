//~makeVoices ::[Float] -> [Float] -> [(tempo, transp)]

~makeVoices= { | tempo_arr, transp_arr|
    [tempo_arr.size, transp_arr.size].minItem.collect({|i|
        (tempo: tempo_arr[i], transp: transp_arr[i])
    })
}





