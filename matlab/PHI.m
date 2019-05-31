function out = PHI(z, threshold, alpha)
 %
 % threshold-linear neuronal response function
 % in the mean-firing rate approximation
 %
out = alpha * (z > threshold) .* ( z - threshold);

end