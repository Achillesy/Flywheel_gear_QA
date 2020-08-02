function [config, input_file, output_file] = fun_GetContext(config_json)
% disp(config_json);
config.vendor = 1;
input_file = '';
output_file = '';
if exist(config_json, 'file') == 2
    fid = fopen(config_json, 'r');
    while ~feof(fid)
        curLine = fgetl(fid);
        % get config.vendor
        if contains(curLine, '"vendor":', 'IgnoreCase', true)
            S = strfind(curLine, "vendor");
            L = length(curLine);
            curLine = curLine(S+8:L);
            E = strfind(curLine, ",");
            if ~isempty(E)
                curLine = curLine(1:E-1);
            end
            config.vendor = str2double(curLine);
        end
        % get input.input_file.location.path &
        % input.output_file.location.path
        if contains(curLine, '"input_file":', 'IgnoreCase', true)
            b_input = true;
            b_output = false;
        end
        if contains(curLine, '"output_file":', 'IgnoreCase', true)
            b_input = false;
            b_output = true;
        end
        if contains(curLine, '"location":', 'IgnoreCase', true)
            if b_input
                b_input = false;
                b_input_location = true;
                b_output_location = false;
            elseif b_output
                b_output = false;
                b_input_location = false;
                b_output_location = true;
            end
        end
        if contains(curLine, '"path":', 'IgnoreCase', true)
            if b_input_location
                b_input_location = false;
                splitLines = split(curLine,'"');
                for i = 1:length(splitLines)
                    if contains(splitLines(i), "input_file", 'IgnoreCase', true)
                        input_file = string(splitLines(i));
                    end
                end
            elseif b_output_location
                b_output_location = false;
                splitLines = split(curLine,'"');
                for i = 1:length(splitLines)
                    if contains(splitLines(i), "output_file", 'IgnoreCase', true)
                        output_file = string(splitLines(i));
                    end
                end
            end
        end
%         disp(curLine);
    end
    fclose(fid);
else
    error("Can't find config.json!");
end

if config.vendor ~= 1
    config.vendor = 0;
end

str = computer;
win64 = strcmp(str, 'PCWIN64');
win32 = strcmp(str, 'PCWIN32');
lin64 = strcmp(str, 'GLNXA64');
lin32 = strcmp(str, 'GLNXA32');
mac64 = strcmp(str, 'MACI64');
if mac64
    % for MacBook Pro local Debug
    input_file =  './flywheel/v0/input/input_file/ser002img00001.dcm';
    output_file = './flywheel/v0/output/Circle_Imaging_MR2.txt';
elseif win64 || win32
    % for Windows local Debug
    input_file =  'C:\flywheel\v0\input\input_file\ser002img00001.dcm';
    output_file = 'C:\flywheel\v0\output\Circle_Imaging_MR2.txt';
end

disp(input_file);
if exist(input_file, 'file') ~= 2
    error("Can't find input file!");
end

output_file = strrep(output_file, 'input/output_file', 'output');
disp(output_file);
if exist(output_file, 'file') ~= 2
    error("Can't find output file!")
end

end