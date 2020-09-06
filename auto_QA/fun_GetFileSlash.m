function fileSlash = fun_GetFileSlash()
if ispc
    fileSlash = '\';
else
    fileSlash = '/';
end
