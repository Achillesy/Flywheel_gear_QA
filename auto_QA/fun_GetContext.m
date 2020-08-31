function [config, input_dir] = fun_GetContext(config_json)
% disp(config_json);
config.vendor = 1;
input_dir = '/tmp/';
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
            if contains(curLine, 'GE', 'IgnoreCase', true)
                config.vendor = 1;
            elseif contains(curLine, 'Siemens', 'IgnoreCase', true)
                config.vendor = 0;
            end
        end
        % get input.input_file.location.path
        %         if contains(curLine, '"input_file":', 'IgnoreCase', true)
        %             b_input = true;
        %         end
        %         if contains(curLine, '"location":', 'IgnoreCase', true) && b_input
        %             b_input = false;
        %             b_input_location = true;
        %         end
        %         if contains(curLine, '"path":', 'IgnoreCase', true) && b_input_location
        %             b_input_location = false;
        %             splitLines = split(curLine,'"');
        %             for i = 1:length(splitLines)
        %                 if contains(splitLines(i), "input_file", 'IgnoreCase', true)
        %                     input_file = string(splitLines(i));
        %                 end
        %             end
        %         end
    end % end While
    fclose(fid);
else
    error("Can't find config.json!");
end

str = computer;
win64 = strcmp(str, 'PCWIN64');
win32 = strcmp(str, 'PCWIN32');
lin64 = strcmp(str, 'GLNXA64');
lin32 = strcmp(str, 'GLNXA32');
mac64 = strcmp(str, 'MACI64');
if mac64
    % for MacBook Pro local Debug
    input_dir =  './flywheel/tmp/';
elseif win64 || win32
    % for Windows local Debug
    input_dir = 'C:\tmp\';
end

% disp(['fun_GetContext input_dir = ', input_dir]);
if exist(strcat(input_dir, 'loc'), 'dir') ~= 7
    error("Can't find loc input dir!");
end
if exist(strcat(input_dir, 'T1'), 'dir') ~= 7
    error("Can't find T1 input dir!");
end

end