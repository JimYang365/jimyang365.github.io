#!python3 
# python 菜鸟, 非喜勿喷
import os
import re
import sys

externInc = ''
externContent = ''
externDefines = '\n'

def do_replace(matched):
    retType = matched.group(1)
    funName = matched.group(2)
    funParam = matched.group(3)
    funType = funName + '_t'

    # 
    global externContent
    global externDefines
    externLine = '    ' + funName + ' = gcef(' + funType + ', "' + funName + '");\n'
    externContent = externContent + externLine
    externDefines = externDefines + funType + ' ' + funName + ' = NULL;\n'
    # fExtern.write(externLine)

    # 
    content_new = '#ifndef DYNAMIC_CEF\nCEF_EXPORT ' + retType + ' ' + funName + funParam
    content_new = content_new + '\n#else\ntypedef ' + retType + ' (*' + funType + ')' + funParam
    content_new = content_new + '\nextern ' + funType + ' ' + funName + ';\n#endif\n'
    return content_new

def replace(fileName):
    global externInc
    f=open(fileName,"r+")
    content=f.read()
    # content_new = re.sub('^CEF_EXPORT (.+) (\S+)(\([\s\S][^\);]*\);)', r'#ifndef DYNAMIC_CEF\nCEF_EXPORT \1 \2 \3\n#else\ntypedef \1 (*\2_t)\3\nextern \2_t \2;\n#endif\n', content, 100000, flags = re.M)
    content_new = re.sub('^CEF_EXPORT (.+)[\s](\S+)(\([\s\S][^;]*;)', do_replace, content, 100000, flags = re.M)
    if len(content_new) != len(content):
        f.seek(0, 0)
        f.truncate()
        f.write(content_new)
        n = fileName.replace('.\\', '')
        n = n.replace('\\', '/')
        externInc = externInc + '#include "' + n + '"\n'
    f.close()

g = os.walk(r".\include")
for path,dir_list,file_list in g:  
    for file_name in file_list:  
        if os.path.splitext(file_name)[1]==".h":
            print(os.path.join(path, file_name))
            replace(os.path.join(path, file_name))

fExtern=open(r".\libcef_dll\cef_externs.cc","r+")
fExtern.seek(0, 0)
fExtern.truncate()
fExtern.write('//\n// This file was generated by tool, do NOT make change by hand.\n//\n\n#include "cef_externs.h"\n\n#ifdef DYNAMIC_CEF\n')
fExtern.write(externInc)
fExtern.write(externDefines)
fExtern.write('\nvoid initializeCEFFunctions(HMODULE cefModule) {\n    #define gcef(X, Y) (X)GetProcAddress(cefModule, Y);\n')
fExtern.write(externContent)
fExtern.write('}\n#endif // #ifdef DYNAMIC_CEF\n')
fExtern.close()