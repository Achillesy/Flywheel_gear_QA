% This RUN script runs all the functions to test ACR phantom
%
%1.pre-define dir&file name

clc;
clear;

% zip test del start
str = computer;
win64 = strcmp(str, 'PCWIN64');
win32 = strcmp(str, 'PCWIN32');
lin64 = strcmp(str, 'GLNXA64');
lin32 = strcmp(str, 'GLNXA32');
mac64 = strcmp(str, 'MACI64');
if mac64
    % for MacBook Pro local Debug
    config_json = './flywheel/v0/config.json';
elseif win64 || win32
    % for Windows local Debug
    config_json ='C:\flywheel\v0\config.json';
else
    config_json = '/flywheel/v0/config.json';
end
[config, input_dir] = fun_GetContext(config_json);
vendor = config.vendor;

dir_name_loc = strcat(input_dir, 'loc/');
dir_name_T1 = strcat(input_dir, 'T1/');

[file_name_loc]=fun_ACR_FindSlice('loc',dir_name_loc); %find SAG LOC file name

[file_name_S1_T1,file_name_S5_T1,file_name_S7_T1,file_name_S8_T1,...
    file_name_S9_T1,file_name_S10_T1,file_name_S11_T1]=...
    fun_ACR_FindSlice('T1',dir_name_T1); % find the file name for axial slice 1, 5, 7, 9, 10, 11


header = dicominfo([dir_name_loc,file_name_loc]); % dicom header for SAG LOC
if vendor ==1
    if all(header.DeviceSerialNumber == '0000000312563CMR')==1
        save_file_name=['Circle_Imaging_MR1.json'];
        B0 = 1.5;
    elseif all(header.DeviceSerialNumber == '000000312942CMR2')==1
        save_file_name=['Circle_Imaging_MR2.json'];
        B0 = 1.5;
    elseif all(header.DeviceSerialNumber == '00000000312947MR')==1
        save_file_name=['SouthLoop_MR.json'];
        B0 = 1.5;
    elseif all(header.DeviceSerialNumber == '000000630724ROMR')==1
        save_file_name=['OakBrook_MR.json'];
        B0 = 1.5;
    else
        save_file_name=['ROPH_MR.json'];
        B0 = 1.5;
    end
else
    if all(header.DeviceSerialNumber == '40715')==1
        save_file_name=['Tower_MR1.json'];
        B0 = 3.0;
    elseif all(header.DeviceSerialNumber == '40714')==1
        save_file_name=['Tower_MR2.json'];
        B0 = 3.0;
    elseif all(header.DeviceSerialNumber == '31172')==1
        save_file_name=['Tower_MR3.json'];
        B0 = 1.5;
    end
end

studydate = str2num(header.StudyDate);
center_freq = header.ImagingFrequency*1000000;

visual=1;
%3.initial image check or not
imag_check=0;
%4.user's personal contrast
% if ~exist('contrast_choice','var')||isempty(contrast_choice)||...
%         ~exist('myContrast','var')||isempty(myContrast)
%     contrast_choice=questdlg('Do you know your visual contrast?', ...
%         'Choose Red or Blue Pill', ...
%         'Yes','No','Yes');
%     switch contrast_choice
%         case 'Yes'
%             prompt={'Your visual contrast (%):'};
%             dlg_title='Input';
%             num_lines=1;
%             def={'0.6'};
%             answer=inputdlg(prompt,dlg_title,num_lines,def);
%             myContrast=str2double(answer{1,1})/100;%convert percentage to demical
%         case 'No'
%             myContrast=fun_TestContrast(300,0.001,0.05,0.001);
%     end
% end

myContrast = 0.012; %For Jie's monitor

%5.other pre-required variables for functions to run properly
choice_S1='S1';
choice_S11='S11';
slice_num_S8=8;
slice_num_S9=9;
slice_num_S10=10;
slice_num_S11=11;

%6.define pass/fail handle
if ~exist('pf_hdl','var')||isempty(pf_hdl)
    pf_hdl=zeros(1,14);
end

%7.define result saving path
dummy=0;
for i=size(dir_name_loc,2)-1:-1:1
    if strcmp(dir_name_loc(1,i),'/')==1
        dummy=i;
        break;
    end
end
save_path=dir_name_loc(1,1:dummy);

%8.TEST 1-GEOMETRIC DISTORTION
%8.1.SAG LOC
tic;
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_1_loc');
end
if sum(imhere)>0
    disp('You have done the Test 1 on localiser.');
else
    disp('It''s the 1st time you run Test 1 on localiser.');
    [TEST_1_loc,pf_hdl(1)]=fun_ACR_1_loc...
        (dir_name_loc,file_name_loc,visual,imag_check,save_path);
    disp(['TEST_1_loc=',num2str(TEST_1_loc)])
end
if pf_hdl(1)==0
    disp('Sag Loc Geometric Distortion Failed');
    %     h=errordlg('Sag Loc Geometric Distortion Failed');
    %     set(h, 'Position', [800 50 200 80]);
    %     clear h
else
    disp('SAG LOC GEOMETRIC DISTORTION PASS');
end
t_loc=toc;


%82.S1ice #1 on Axial
tic;
dummy=0;
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_1_S1_hori');
end
if sum(imhere)>0
    disp('You have done the Test 1 on S1 T1 image.');
else
    disp('It''s the 1st time you run Test 1 on S1 T1 image.');
    [TEST_1_S1_hori,TEST_1_S1_vert,mu_S1,dummy(1,1:2)]=fun_ACR_1_S1...
        (dir_name_T1,file_name_S1_T1,visual,imag_check,'T1',save_path);
end
% close all;

%83.Slice5 grid on Axial
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_1_S5_hori');
end
if sum(imhere)>0
    disp('You have done the Test 1 on S5 T1 image.');
else
    disp('It''s the 1st time you run Test 1 on S5 T1 image.');
    [TEST_1_S5_hori,TEST_1_S5_vert,TEST_1_S5_ng,TEST_1_S5_pg,dummy(1,3:6)]...
        =fun_ACR_1_S5(dir_name_T1,file_name_S5_T1,visual,imag_check,'T1',save_path);
    
    disp(['TEST_1_S5_hori=',num2str(TEST_1_S5_hori)])
    disp(['TEST_1_S5_vert=',num2str(TEST_1_S5_vert)])
    disp(['TEST_1_S5_ng=',num2str(TEST_1_S5_ng)])
    disp(['TEST_1_S5_pg=',num2str(TEST_1_S5_pg)])
    
    if sum(dummy(1,3:6))==4
        pf_hdl(2)=1;
    else
        pf_hdl(2)=0;
    end
end
if pf_hdl(2)==0
    disp('S5 Geometric Distortion Failed');
    %     h=errordlg('S5 Geometric Distortion Failed');
    %     set(h, 'Position', [850 50 200 80]);
    %     clear h
else
    disp('AXIAL T1 SLICE 5 GEOMETRIC DISTORTION PASS');
end

%9.TEST 2-HIGH CONTRAST SPATIAL RESOLUTION - both Manual and Automatic
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_2_S1');
end
if sum(imhere)>0
    disp('You have done the Test 2 on S1 T1 image.');
else
    %     disp('It''s the 1st time you run Test 2 on S1 T1 image.');
    %     test2_choice=questdlg('How do you want to do the HCSR test?', ...
    %         'Choose Red or Blue Pill', ...
    %         'Automatic','Manual','Automatic');
    %     switch test2_choice
    %         case 'Automatic'
    %             manual_test2=0;
    %         case 'Manual'
    %             manual_test2=1;
    %             h=msgbox(['You are doing high contrast spatial resolution test. ' ...
    %                 '(Zoom in the High Contrast test region, adjust image window, ' ...
    %                 'see if you can identify 4 point-objects, close image and enter ' ...
    %                 'contrast index 1.1=left/1.0=middle/0.9=right)']);%v2
    %             uiwait(h);
    %     end
    visual=0;
    manual_test2=1; %manaul
    [TEST_2_S1_manual,pf_hdl(3:4)]=fun_ACR_2_S1...
        (dir_name_T1,file_name_S1_T1,visual,manual_test2,imag_check,myContrast);% 1st row for UL pair and 2nd row for LR pair
    disp(['TEST_2_S1_manual=',num2str(TEST_2_S1_manual(1)),'  and  ',num2str(TEST_2_S1_manual(2))])
    
    
    if pf_hdl(3)==0 || pf_hdl(4)==0
        disp('Manual High Contrast Spatial Resolution Failed');
        %         h=errordlg('Manual High Contrast Spatial Resolution Failed');
        %         set(h, 'Position', [1000 50 250 80]);
        %         clear h
    else
        disp('HIGH CONTRAST SPATIAL RESOLUTION MANUAL PASS');
    end
    manual_test2=0; %automatic detecting peak
    [TEST_2_S1_auto,pf_hdl(5:6)]=fun_ACR_2_S1...
        (dir_name_T1,file_name_S1_T1,visual,manual_test2,imag_check,myContrast);% 1st row for UL pair and 2nd row for LR pair
    
    disp(['TEST_2_S1_auto=',num2str(TEST_2_S1_auto(1)),'  and  ',num2str(TEST_2_S1_auto(2))])
    if pf_hdl(5)==0 || pf_hdl(6)==0
        disp('Automatic High Contrast Spatial Resolution Failed');
        %         h=errordlg('Automatic High Contrast Spatial Resolution Failed');
        %         set(h, 'Position', [900 50 250 80]);
        %         clear h
    else
        disp('HIGH CONTRAST SPATIAL RESOLUTION AUTOMATIC PASS');
    end
    
end

%10.TEST 3 - SLICE THICKNESS ACCURACY
visual=1;
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_3_S1');
end
if sum(imhere)>0
    disp('You have done the Test 3 on S1 T1 image.');
else
    disp('It''s the 1st time you run Test 3 on S1 T1 image.');
    
    manual_test3=1;% mannually draw lines
    [TEST_3_S1_manual,pf_hdl(7)]=fun_ACR_3_S1...
        (dir_name_T1,file_name_S1_T1,mu_S1,imag_check,manual_test3);
    if pf_hdl(7)==0
        disp('Manual Slice Thickness Failed');
        % h= errordlg('Manual Slice Thickness Failed');
        % set(h, 'Position', [920 50 200 80]);
        % clear h
    else
        disp('SLICE THICKNESS ACCURACY MANUAL PASS');
    end
    
    manual_test3=0;% automatic
    [TEST_3_S1_auto,pf_hdl(8)]=fun_ACR_3_S1...
        (dir_name_T1,file_name_S1_T1,mu_S1,imag_check,manual_test3);
    if pf_hdl(8)==0
        disp('Automatic Slice Thickness Failed');
        %         h= errordlg('Automatic Slice Thickness Failed');
        %         set(h, 'Position', [920 50 200 80]);
        %         clear h
    else
        disp('SLICE THICKNESS ACCURACY AUTOMATIC PASS');
    end
end

%11.TEST 4-SLICE POSITION ACCURACY
%111.S1
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_4_S1');
end
if sum(imhere)>0
    disp('You have done the Test 4 on S1 T1 image.');
else
    disp('It''s the 1st time you run Test 4 on S1 T1 image.');
    [TEST_4_S1,pf_hdl(9)]=fun_ACR_4_S1S11...
        (choice_S1,dir_name_T1,file_name_S1_T1,visual,mu_S1,imag_check);
end
if pf_hdl(9)==0
    disp('Slice Position Accuracy S1 Failed');
    %     h= errordlg('Slice Position Accuracy S1 Failed');
    %     set(h, 'Position', [950 50 200 80]);
    %     clear h
else
    disp('SLICE POSITION ACCURACY S1 PASS');
end

%112.S11
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_4_S11');
end
if sum(imhere)>0
    disp('You have done the Test 4 on S11 T1 image.');
else
    disp('It''s the 1st time you run Test 4 on S11 T1 image.');
    mu_S11=fun_ACR_FindWaterIntPeak(dicomread([dir_name_T1 file_name_S11_T1]),...
        0.1,visual);
    [TEST_4_S11,pf_hdl(10)]=fun_ACR_4_S1S11...
        (choice_S11,dir_name_T1,file_name_S11_T1,visual,mu_S11,imag_check);
end
if pf_hdl(10)==0
    disp('Slice Position Accuracy S11 Failed');
    %     h=errordlg('Slice Position Accuracy S11 Failed');
    %     set(h, 'Position', [1000 50 200 80]);
    %     clear h
else
    disp('SLICE POSITION ACCURACY S11 PASS');
end

%12.TEST 5-IMAGE INTENSITY UNIFORMITY
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_5_S7');
end
if sum(imhere)>0
    disp('You have done the Test 5 on S7 T1 image.');
else
    %     disp('It''s the 1st time you run Test 5 on S7 T1 image.');
    %     test5_choice=questdlg('How do you want to do the PIU test?', ...
    %         'Choose Red or Blue Pill', ...
    %         'Automatic','Manual','Automatic');
    %     switch test5_choice
    %         case 'Automatic'
    %             manual_test5=0;
    %         case 'Manual'
    %             manual_test5=1;
    %     end
    manual_test5=0;
    
    [TEST_5_S7,mu_S7,pf_hdl(11)]=fun_ACR_5_S7...
        (dir_name_T1,file_name_S7_T1,visual,imag_check,manual_test5);
end
if pf_hdl(11)==0
    disp('PIU Failed');
    %     h=errordlg('PIU Failed');
    %     set(h, 'Position', [1050 50 200 80]);
    %     clear h
else
    disp('IMAGE INTENSITY UNIFORMITY PASS');
end

%13.TEST 6-PERCENTAGE SIGNAL GHOSTING
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_6_S7');
end
if sum(imhere)>0
    disp('You have done the Test 6 on S7 T1 image.');
else
    disp('It''s the 1st time you run Test 6 on S7 T1 image.');
    [TEST_6_S7,pf_hdl(12)]=fun_ACR_6_S7...
        (dir_name_T1,file_name_S7_T1,visual,mu_S7,imag_check,'T1',save_path);
end
if pf_hdl(12)==0
    disp('PSG Failed');
    %     h=errordlg('PSG Failed');
    %     set(h, 'Position', [1100 50 200 80]);
    %     clear h
else
    disp('PERCENTAGE SIGNAL GHOSTING PASS');
end
%close all;

%14.TEST 7-LOW CONTRAST OBJECT DETECTABILITY
manual_test7=1;
%141.S11
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_7_S11');
end
if sum(imhere)>0
    disp('You have done the Test 7 on S11 T1 image.');
else
    disp('It''s the 1st time you run Test 7 on S11 T1 image.');
    [TEST_7_S11,I_spk_S11]=fun_ACR_7_S8S9S10S11...
        (dir_name_T1,file_name_S11_T1,slice_num_S11,visual,manual_test7,imag_check);
end
%142.S10
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_7_S10');
end
if sum(imhere)>0
    disp('You have done the Test 7 on S10 T1 image.');
else
    disp('It''s the 1st time you run Test 7 on S10 T1 image.');
    [TEST_7_S10,I_spk_S10]=fun_ACR_7_S8S9S10S11...
        (dir_name_T1,file_name_S10_T1,slice_num_S10,visual,manual_test7,imag_check);
end
%143.S9
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_7_S9');
end
if sum(imhere)>0
    disp('You have done the Test 7 on S9 T1 image.');
else
    disp('It''s the 1st time you run Test 7 on S9 T1 image.');
    [TEST_7_S9,I_spk_S9]=fun_ACR_7_S8S9S10S11...
        (dir_name_T1,file_name_S9_T1,slice_num_S9,visual,manual_test7,imag_check);
end
%144.S8
s=whos;
imhere=zeros(size(s,1),1);
for i=1:size(s,1)
    imhere(i,1)=strcmp(s(i,1).name,'TEST_7_S8');
end
if sum(imhere)>0
    disp('You have done the Test 7 on S8 T1 image.');
else
    disp('It''s the 1st time you run Test 7 on S8 T1 image.');
    [TEST_7_S8,I_spk_S8]=fun_ACR_7_S8S9S10S11...
        (dir_name_T1,file_name_S8_T1,slice_num_S8,visual,manual_test7,imag_check);
end
if B0==3
    if sum([TEST_7_S11,TEST_7_S10,TEST_7_S9,TEST_7_S8])==40
        pf_hdl(13)=1;
    else
        pf_hdl(13)=0;
    end
elseif B0==1.5
    if sum([TEST_7_S11,TEST_7_S10,TEST_7_S9,TEST_7_S8])>=36
        pf_hdl(13)=1;
    else
        pf_hdl(13)=0;
    end
end

if pf_hdl(13)==0
    disp('LCOD Failed');
    %     h=errordlg('LCOD Failed');
    %     set(h, 'Position', [1150 50 200 80]);
    %     clear h
else
    disp('LOW CONTRAST OBJECT DETECTABILITY PASS');
end

t_T1=toc;

%22.write results into Excel file
%% del by Achilles start
% tic;
% save_path_excel='./WeeklyQA/';
% [ndata, text, alldata] = xlsread([save_path_excel save_file_name]);
% if size(alldata,1) ==1
%     pf_hdl(14)=1;
% else
%     if B0 == 1.5
%         if abs(center_freq - ndata(end,2))<128
%             pf_hdl(14)=1;
%         else
%             pf_hdl(14)=0;
%             disp('Center Frequency Failed');
% %             h=errordlg('Center Frequency Failed');
% %             set(h, 'Position', [1200 50 200 80]);
% %             clear h
%         end
%     elseif B0 == 3.0
%         if abs(center_freq- ndata(end,2))<256
%             pf_hdl(14)=1;
%         else
%             pf_hdl(14)=0;
%             disp('Center Frequency Failed');
% %             h=errordlg('Center Frequency Failed');
% %             set(h, 'Position', [1200 50 200 80]);
% %             clear h
%         end
%     end
% end
%
%
% A= [
%     studydate, center_freq, TEST_1_loc,TEST_1_S5_hori,TEST_1_S5_vert,TEST_1_S5_ng,TEST_1_S5_pg,...
%     TEST_2_S1_manual(1,1),TEST_2_S1_manual(2,1),TEST_2_S1_auto(1,1),TEST_2_S1_auto(2,1),...
%     TEST_3_S1_manual,TEST_3_S1_auto,TEST_4_S1,TEST_4_S11,...
%     TEST_5_S7*100,TEST_6_S7*100,...
%     TEST_7_S11+TEST_7_S10+TEST_7_S9+TEST_7_S8,now];
%
% xlswrite([save_path_excel save_file_name],A,['A',num2str(size(alldata,1)+1),':','R',num2str(size(alldata,1)+1)]);%v2
%
% % Get Workbook object
% Excel = actxserver('excel.application');
% WB = Excel.Workbooks.Open(fullfile([save_path_excel save_file_name]),0,false);
%
% % Set the color of cell "A1" of Sheet 1 to RED
% if pf_hdl(14) == 0
%     WB.Worksheets.Item(1).Range(['B',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(1) == 0
%     WB.Worksheets.Item(1).Range(['C',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(2) == 0
%     WB.Worksheets.Item(1).Range(['D',num2str(size(alldata,1)+1),':','G',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(3)==0
%     WB.Worksheets.Item(1).Range(['H',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(4)==0
%     WB.Worksheets.Item(1).Range(['I',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(5)==0
%     WB.Worksheets.Item(1).Range(['J',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(6)==0
%     WB.Worksheets.Item(1).Range(['K',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(7)==0
%     WB.Worksheets.Item(1).Range(['L',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(8)==0
%     WB.Worksheets.Item(1).Range(['M',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(9)==0
%     WB.Worksheets.Item(1).Range(['N',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(10)==0
%     WB.Worksheets.Item(1).Range(['O',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(11)==0
%     WB.Worksheets.Item(1).Range(['P',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(12)==0
%     WB.Worksheets.Item(1).Range(['Q',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% if pf_hdl(13)==0
%     WB.Worksheets.Item(1).Range(['R',num2str(size(alldata,1)+1)]).Interior.ColorIndex = 3;
% end
% % Save Workbook
% WB.Save();
% % Close Workbook
% WB.Close();
% % Quit Excel
% Excel.Quit();
%% del by Achilles end

try
    output_file = strcat(input_dir, 'qa_result.json');
    fid = fopen(output_file, 'wt');
    %     newLine = join(string(A), ',');
    %     disp(newLine);
    %     fprintf(fid, strcat(newLine, "\n"));
    fprintf(fid, '{\n');
    fprintf(fid, '    "save_file_name":"%s",\n', save_file_name);
    fprintf(fid, '    "auto_qa_date":"%s",\n', datetime(now, 'ConvertFrom','datenum'));
    fprintf(fid, '    "Study Date":%d,\n', studydate);
    fprintf(fid, '    "Center Freq":%d,\n', center_freq);
    fprintf(fid, '    "SAG LOG Geometic":%f,\n', TEST_1_loc);
    fprintf(fid, '    "AX T1 SL5 hori":%f,\n', TEST_1_S5_hori);
    fprintf(fid, '    "AX T1 SL5 vert":%f,\n', TEST_1_S5_vert);
    fprintf(fid, '    "AX T1 SL5 ng":%f,\n', TEST_1_S5_ng);
    fprintf(fid, '    "AX T1 SL5 pg":%f,\n', TEST_1_S5_pg);
    fprintf(fid, '    "HCSR manual(1)":%f,\n', TEST_2_S1_manual(1,1));
    fprintf(fid, '    "HCSR manual(2)":%f,\n', TEST_2_S1_manual(2,1));
    fprintf(fid, '    "HCSR auto(1)":%f,\n', TEST_2_S1_auto(1,1));
    fprintf(fid, '    "HCSR auto(2)":%f,\n', TEST_2_S1_auto(2,1));
    fprintf(fid, '    "Slice thickness manual":%f,\n', TEST_3_S1_manual);
    fprintf(fid, '    "Slice thinkness auto":%f,\n', TEST_3_S1_auto);
    fprintf(fid, '    "Slice position accuracy S1":%f,\n', TEST_4_S1);
    fprintf(fid, '    "Slice position accuracy S11":%f,\n', TEST_4_S11);
    fprintf(fid, '    "PIU":%f,\n', TEST_5_S7*100);
    fprintf(fid, '    "PSG":%f,\n', TEST_6_S7*100);
    fprintf(fid, '    "LCOD":%d\n', TEST_7_S11+TEST_7_S10+TEST_7_S9+TEST_7_S8);
    fprintf(fid, '}\n');
    fclose(fid);
catch ME1
    disp(ME1.message);
end
