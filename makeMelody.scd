//~makeMelody ::[Float] -> [Float] -> [(dur, note)]
~makeMelody = {|durs_arr, notes_arr|
    [durs_arr.size, notes_arr.size].minItem.collect({|i|
        (dur: durs_arr[i], note: notes_arr[i])
    })
}