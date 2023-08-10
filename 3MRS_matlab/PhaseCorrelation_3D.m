function [ m, n] = PhaseCorrelation_3D(CMPC_ref, CMPC_sen, matchrad)

fftRef = fftn(CMPC_ref);
fftSen = fftn(CMPC_sen);
fftRef_conj = conj(fftRef);
corr_func = fftSen.*fftRef_conj;    
corr_func = real(fftshift(ifftn( corr_func )));

max_corr = max( corr_func( : ) );
max_index = find( corr_func == max_corr );
[ m, n, ~ ] = ind2sub( size( corr_func ), max_index );

m = m - 1 - matchrad;
n = n - 1 - matchrad;