%% This MATLAB code file inputs the raw interferogram acquired by the time-frequency multiplexed 3D imagign system, and outputs the 3D depth map 
% For the mannequin head and cup datasets, the first dimension of input data is each individual sweep, and the second dimenion is number of sweep or number of measurements along the galvo axis
% For the hand data, the third dimension is the frame number 

%% remove invalid pts (index generated from the insight laser SW) in each interferogram 
for i=1:size(data,2);
test=data(:,i);
range = 57; % the optimized range for this dataset
data_valid(:,i) = remove_invalid_pt(data(:,i)); 
end

%% DC subtraction
data_dc=data_valid-mean(data_valid,2); 

%% STFT processing
w_num= 475;  %the total number of STFT windows/lateral pts across the entire sweep
stft_length=5000; %zeropadding length of each STFT signal
w_size=200;
sweep_num=size(data,2); %number of sweeps/measurements along the galvo axis

stft_signal=zeros(stft_length,w_num);  %%zeropadded signal of each STFT window
stft_out=zeros(stft_length,w_num,sweep_num);

for j=1:sweep_num
for i=1:w_num
    stft_signal(1:w_size,i)=data_dc(((i-1)*w_size/2+1):((i-1)*w_size/2+w_size),j); % STFT signal for each window before zeropadding
end
stft_signal(w_size:stft_length,:)=0; %zeropadding

for i=1:w_num
    stft_out(:,i,j)=abs(fftshift(fft(stft_signal(:,i)))); %% output of the zero-padded STFT
end

end

%% depth localization

int_t=7600;  %% intensity thresholding value

for j=1:sweep_num
    j
for i=1:w_num
    if max(stft_out(stft_length/2+50:stft_length,i,j))>int_t  %% +50 to avoid some peak artifacts close to the DC due to imperfect DC subtraction 
         [max_int(i,j),max_loc(i,j)]=max(stft_out(stft_length/2+50:stft_length,i,j)); %% find the peak location and position
    else
         max_loc(i,j)=5000; %% assign a random depth if no peak above thersholding value was detected
    end
end
end


%% peak localization filtering

max_loc_gradient=imgradient(medfilt2(max_loc));
max_loc(max_loc_gradient>2500)=5000; 
max_loc_final=medfilt2(max_loc);
max_loc_final(max_loc_final==5000)=NaN; %% assign the depth to NaN for those lateral positions that don't have reflectors
%% final 3D depth map 
s_factor=0.127; %%each pixel here corresponds to 127um in depth
depth_map=(max_loc_final+50)*s_factor; % converting the localized peak position to depth results
imagesc(depth_map);colormap jet;b=imagesc(depth_map); set(b,'AlphaData',~isnan(depth_map))


