function signal = forceMono(signal)
    if size(signal,2)>1
        warning('Forced mono-downmix');
    end
    signal = mean(signal,2);
end
