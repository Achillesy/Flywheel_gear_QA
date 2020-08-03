function [config, input_file, output_dir] = fun_GetContext(config_json)
% disp(config_json);
config.vendor = 1;
input_file = '';
output_dir = '/flywheel/v0/output/';
if exist(config_json, 'file') == 2
    fid = fopen(config_json, 'r');
    while ~feof(fid)
        curLine = fgetl(fid);
        % disp(curLine);
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
        % get input.input_file.location.path
        if contains(curLine, '"input_file":', 'IgnoreCase', true)
            b_input = true;
        end
        if contains(curLine, '"location":', 'IgnoreCase', true) && b_input
            b_input = false;
            b_input_location = true;
        end
        if contains(curLine, '"path":', 'IgnoreCase', true) && b_input_location
            b_input_location = false;
            splitLines = split(curLine,'"');
            for i = 1:length(splitLines)
                if contains(splitLines(i), "input_file", 'IgnoreCase', true)
                    input_file = string(splitLines(i));
                end
            end
        end
    end % end While
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
    input_file = './flywheel/v0/input/input_file/ser002img00001.dcm';
    output_dir = './flywheel/v0/output/';
elseif win64 || win32
    % for Windows local Debug
    input_file = 'C:\flywheel\v0\input\input_file\ser002img00001.dcm';
    output_dir = 'C:\flywheel\v0\output\';
end

disp(input_file);
if exist(input_file, 'file') ~= 2
    error("Can't find input file!");
end

disp(output_dir);
if exist(output_dir, 'dir') ~= 7
    error("Can't find output dir!")
end

end