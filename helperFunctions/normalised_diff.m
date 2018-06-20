function norm_value = normalised_diff( data )
    % Normalise values of an array to be between 0 and 1
    minVal = min(data);
    maxVal = max(data);
    norm_value = (data - minVal) / ( maxVal - minVal );
end