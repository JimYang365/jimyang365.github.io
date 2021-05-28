### Reduce code size of the framework, from 3.7M to 120K+.

### 1. 原始大小，通过 jtool 查看的结果
***3.7M***
```
0x0-0xc8000 __TEXT
    0x1810-0xa4760  __TEXT.__text
    0xa4760-0xa49d6 __TEXT.__stubs
    0xa49d8-0xa4dee __TEXT.__stub_helper
    0xa4dee-0xa575c __TEXT.__objc_methname
    0xa575c-0xa57b3 __TEXT.__objc_classname
    0xa57b3-0xa5a25 __TEXT.__objc_methtype
    0xa5a28-0xb6d10 __TEXT.__gcc_except_tab
    0xb6d10-0xb752a __TEXT.__cstring
    0xb7530-0xc6430 __TEXT.__const
    0xc6430-0xc7db8 __TEXT.__unwind_info
    0xc7db8-0xc8000 __TEXT.__eh_frame
0xc8000-0xee000 __DATA
    0xc8000-0xc8010 __DATA.__nl_symbol_ptr
    0xc8010-0xd42a0 __DATA.__got
    0xd42a0-0xd45e8 __DATA.__la_symbol_ptr
    0xd45e8-0xd45f0 __DATA.__mod_init_func
    0xd45f0-0xd4c28 __DATA.__const
    0xd4c28-0xd4f68 __DATA.__cfstring
    0xd4f68-0xd4f90 __DATA.__objc_classlist
    0xd4f90-0xd4f98 __DATA.__objc_imageinfo
    0xd4f98-0xd5980 __DATA.__objc_const
    0xd5980-0xd5cc0 __DATA.__objc_selrefs
    0xd5cc0-0xd5d48 __DATA.__objc_classrefs
    0xd5d48-0xd5d68 __DATA.__objc_superrefs
    0xd5d68-0xd5df0 __DATA.__objc_ivar
    0xd5df0-0xd5f80 __DATA.__objc_data
    0xd5f80-0xed618 __DATA.__data
0xee000-0x38a448    __LINKEDIT
    0xee000-0xef810 Rebase Info     (opcodes)
    0xef810-0xf04a0 Binding Info    (opcodes)
    0xf04a0-0x1413a0    Weak Bind Info  (opcodes)
    0x1413a0-0x142298   Lazy Bind Info  (opcodes)
    0x142298-0x1718c8   Exports                  
    0x1718c8-0x1739c0   Function Starts
    0x1739c0-0x173b00   Data In Code
    0x173b00-0x240a60   Symbol Table
    0x240a60-0x246ef8   Indirect Symbol Table
    0x246ef8-0x38a448   String Table
```

### 2. 调整 Deployment Postprocessing 编译选项为YES
***2.5M***
```
0x0-0xc8000 __TEXT
    0x1810-0xa4760  __TEXT.__text
    0xa4760-0xa49d6 __TEXT.__stubs
    0xa49d8-0xa4dee __TEXT.__stub_helper
    0xa4dee-0xa575c __TEXT.__objc_methname
    0xa575c-0xa57b3 __TEXT.__objc_classname
    0xa57b3-0xa5a25 __TEXT.__objc_methtype
    0xa5a28-0xb6d10 __TEXT.__gcc_except_tab
    0xb6d10-0xb752a __TEXT.__cstring
    0xb7530-0xc6430 __TEXT.__const
    0xc6430-0xc7db8 __TEXT.__unwind_info
    0xc7db8-0xc8000 __TEXT.__eh_frame
0xc8000-0xee000 __DATA
    0xc8000-0xc8010 __DATA.__nl_symbol_ptr
    0xc8010-0xd42a0 __DATA.__got
    0xd42a0-0xd45e8 __DATA.__la_symbol_ptr
    0xd45e8-0xd45f0 __DATA.__mod_init_func
    0xd45f0-0xd4c28 __DATA.__const
    0xd4c28-0xd4f68 __DATA.__cfstring
    0xd4f68-0xd4f90 __DATA.__objc_classlist
    0xd4f90-0xd4f98 __DATA.__objc_imageinfo
    0xd4f98-0xd5980 __DATA.__objc_const
    0xd5980-0xd5cc0 __DATA.__objc_selrefs
    0xd5cc0-0xd5d48 __DATA.__objc_classrefs
    0xd5d48-0xd5d68 __DATA.__objc_superrefs
    0xd5d68-0xd5df0 __DATA.__objc_ivar
    0xd5df0-0xd5f80 __DATA.__objc_data
    0xd5f80-0xed618 __DATA.__data
0xee000-0x269c88    __LINKEDIT
    0xee000-0xef810 Rebase Info     (opcodes)
    0xef810-0xf04a0 Binding Info    (opcodes)
    0xf04a0-0x1413a0    Weak Bind Info  (opcodes)
    0x1413a0-0x142298   Lazy Bind Info  (opcodes)
    0x142298-0x1718c8   Exports                  
    0x1718c8-0x1739c0   Function Starts
    0x1739c0-0x173b00   Data In Code
    0x173b00-0x1af270   Symbol Table
    0x1af270-0x1b5708   Indirect Symbol Table
    0x1b5708-0x269c88   String Table
```

### 3. 调整 Strip Style 编译选项为 non global
***2M***
```
0x0-0xc8000 __TEXT
    0x1810-0xa4760  __TEXT.__text
    0xa4760-0xa49d6 __TEXT.__stubs
    0xa49d8-0xa4dee __TEXT.__stub_helper
    0xa4dee-0xa575c __TEXT.__objc_methname
    0xa575c-0xa57b3 __TEXT.__objc_classname
    0xa57b3-0xa5a25 __TEXT.__objc_methtype
    0xa5a28-0xb6d10 __TEXT.__gcc_except_tab
    0xb6d10-0xb752a __TEXT.__cstring
    0xb7530-0xc6430 __TEXT.__const
    0xc6430-0xc7db8 __TEXT.__unwind_info
    0xc7db8-0xc8000 __TEXT.__eh_frame
0xc8000-0xee000 __DATA
    0xc8000-0xc8010 __DATA.__nl_symbol_ptr
    0xc8010-0xd42a0 __DATA.__got
    0xd42a0-0xd45e8 __DATA.__la_symbol_ptr
    0xd45e8-0xd45f0 __DATA.__mod_init_func
    0xd45f0-0xd4c28 __DATA.__const
    0xd4c28-0xd4f68 __DATA.__cfstring
    0xd4f68-0xd4f90 __DATA.__objc_classlist
    0xd4f90-0xd4f98 __DATA.__objc_imageinfo
    0xd4f98-0xd5980 __DATA.__objc_const
    0xd5980-0xd5cc0 __DATA.__objc_selrefs
    0xd5cc0-0xd5d48 __DATA.__objc_classrefs
    0xd5d48-0xd5d68 __DATA.__objc_superrefs
    0xd5d68-0xd5df0 __DATA.__objc_ivar
    0xd5df0-0xd5f80 __DATA.__objc_data
    0xd5f80-0xed618 __DATA.__data
0xee000-0x1e5860    __LINKEDIT
    0xee000-0xef810 Rebase Info     (opcodes)
    0xef810-0xf04a0 Binding Info    (opcodes)
    0xf04a0-0x1413a0    Weak Bind Info  (opcodes)
    0x1413a0-0x142298   Lazy Bind Info  (opcodes)
    0x142298-0x1718c8   Exports                  
    0x1718c8-0x1739c0   Function Starts
    0x1739c0-0x173b00   Data In Code
    0x173b00-0x196de0   Symbol Table
    0x196de0-0x19d278   Indirect Symbol Table
    0x19d278-0x1e5860   String Table
```

### 4. 内部类、模版函数加入 __attribute__((visibility("hidden")))
***1.5M***
```
0x0-0xcf000 __TEXT
    0x1210-0xaad40  __TEXT.__text
    0xaad40-0xaafb6 __TEXT.__stubs
    0xaafb8-0xab3ce __TEXT.__stub_helper
    0xab3ce-0xabd3c __TEXT.__objc_methname
    0xabd3c-0xabd93 __TEXT.__objc_classname
    0xabd93-0xac005 __TEXT.__objc_methtype
    0xac008-0xbd2f0 __TEXT.__gcc_except_tab
    0xbd2f0-0xbdb0a __TEXT.__cstring
    0xbdb10-0xcca10 __TEXT.__const
    0xcca10-0xcedb4 __TEXT.__unwind_info
    0xcedb8-0xcf000 __TEXT.__eh_frame
0xcf000-0xec000 __DATA
    0xcf000-0xcf010 __DATA.__nl_symbol_ptr
    0xcf010-0xd1f18 __DATA.__got
    0xd1f18-0xd2260 __DATA.__la_symbol_ptr
    0xd2260-0xd2268 __DATA.__mod_init_func
    0xd2270-0xd28a8 __DATA.__const
    0xd28a8-0xd2be8 __DATA.__cfstring
    0xd2be8-0xd2c10 __DATA.__objc_classlist
    0xd2c10-0xd2c18 __DATA.__objc_imageinfo
    0xd2c18-0xd3600 __DATA.__objc_const
    0xd3600-0xd3940 __DATA.__objc_selrefs
    0xd3940-0xd39c8 __DATA.__objc_classrefs
    0xd39c8-0xd39e8 __DATA.__objc_superrefs
    0xd39e8-0xd3a70 __DATA.__objc_ivar
    0xd3a70-0xd3c00 __DATA.__objc_data
    0xd3c00-0xeb298 __DATA.__data
0xec000-0x162e64    __LINKEDIT
    0xec000-0xed808 Rebase Info     (opcodes)
    0xed808-0xee498 Binding Info    (opcodes)
    0xee498-0x1174f0    Weak Bind Info  (opcodes)
    0x1174f0-0x118380   Lazy Bind Info  (opcodes)
    0x118380-0x12d2a8   Exports                  
    0x12d2a8-0x12f4e0   Function Starts
    0x12f4e0-0x12f620   Data In Code
    0x12f620-0x13fa60   Symbol Table
    0x13fa60-0x141534   Indirect Symbol Table
    0x141534-0x162e64   String Table
```

### 5. 模版改为宏 ```此方案最优```
***123K***
```
0x0-0x17000 __TEXT
    0x1b50-0x12b70  __TEXT.__text
    0x12b70-0x12de0 __TEXT.__stubs
    0x12de0-0x131ec __TEXT.__stub_helper
    0x131ec-0x13b5a __TEXT.__objc_methname
    0x13b5a-0x13bb1 __TEXT.__objc_classname
    0x13bb1-0x13e23 __TEXT.__objc_methtype
    0x13e24-0x15c78 __TEXT.__gcc_except_tab
    0x15c80-0x1670d __TEXT.__cstring
    0x16710-0x16930 __TEXT.__const
    0x16930-0x16dd4 __TEXT.__unwind_info
    0x16dd8-0x17000 __TEXT.__eh_frame
0x17000-0x19000 __DATA
    0x17000-0x17010 __DATA.__nl_symbol_ptr
    0x17010-0x170b8 __DATA.__got
    0x170b8-0x173f8 __DATA.__la_symbol_ptr
    0x173f8-0x17400 __DATA.__mod_init_func
    0x17400-0x17768 __DATA.__const
    0x17768-0x17aa8 __DATA.__cfstring
    0x17aa8-0x17ad0 __DATA.__objc_classlist
    0x17ad0-0x17ad8 __DATA.__objc_imageinfo
    0x17ad8-0x184c0 __DATA.__objc_const
    0x184c0-0x18800 __DATA.__objc_selrefs
    0x18800-0x18888 __DATA.__objc_classrefs
    0x18888-0x188a8 __DATA.__objc_superrefs
    0x188a8-0x18930 __DATA.__objc_ivar
    0x18930-0x18ac0 __DATA.__objc_data
    0x18ac0-0x18e90 __DATA.__data
0x19000-0x1e0c4 __LINKEDIT
    0x19000-0x190d0 Rebase Info     (opcodes)
    0x190d0-0x19c60 Binding Info    (opcodes)
    0x19c60-0x19f38 Weak Bind Info  (opcodes)
    0x19f38-0x1ada8 Lazy Bind Info  (opcodes)
    0x1ada8-0x1b3b8 Exports                  
    0x1b3b8-0x1b4f0 Function Starts
    0x1b4f0-0x1b538 Data In Code
    0x1b538-0x1c208 Symbol Table
    0x1c208-0x1c5a4 Indirect Symbol Table
    0x1c5a4-0x1e0c4 String Table
```

### 6. 去掉 __attribute__((visibility("hidden")))
***131K***
```
0x0-0x17000 __TEXT
    0x1b60-0x12b70  __TEXT.__text
    0x12b70-0x12de0 __TEXT.__stubs
    0x12de0-0x131ec __TEXT.__stub_helper
    0x131ec-0x13b5a __TEXT.__objc_methname
    0x13b5a-0x13bb1 __TEXT.__objc_classname
    0x13bb1-0x13e23 __TEXT.__objc_methtype
    0x13e24-0x15c78 __TEXT.__gcc_except_tab
    0x15c80-0x1670d __TEXT.__cstring
    0x16710-0x16930 __TEXT.__const
    0x16930-0x16dd0 __TEXT.__unwind_info
    0x16dd0-0x16ff8 __TEXT.__eh_frame
0x17000-0x19000 __DATA
    0x17000-0x17010 __DATA.__nl_symbol_ptr
    0x17010-0x170e8 __DATA.__got
    0x170e8-0x17428 __DATA.__la_symbol_ptr
    0x17428-0x17430 __DATA.__mod_init_func
    0x17430-0x17798 __DATA.__const
    0x17798-0x17ad8 __DATA.__cfstring
    0x17ad8-0x17b00 __DATA.__objc_classlist
    0x17b00-0x17b08 __DATA.__objc_imageinfo
    0x17b08-0x184f0 __DATA.__objc_const
    0x184f0-0x18830 __DATA.__objc_selrefs
    0x18830-0x188b8 __DATA.__objc_classrefs
    0x188b8-0x188d8 __DATA.__objc_superrefs
    0x188d8-0x18960 __DATA.__objc_ivar
    0x18960-0x18af0 __DATA.__objc_data
    0x18af0-0x18ec0 __DATA.__data
0x19000-0x1ff5c __LINKEDIT
    0x19000-0x190d0 Rebase Info     (opcodes)
    0x190d0-0x19c60 Binding Info    (opcodes)
    0x19c60-0x1a170 Weak Bind Info  (opcodes)
    0x1a170-0x1afe0 Lazy Bind Info  (opcodes)
    0x1afe0-0x1c060 Exports                  
    0x1c060-0x1c198 Function Starts
    0x1c198-0x1c1e0 Data In Code
    0x1c1e0-0x1d3e0 Symbol Table
    0x1d3e0-0x1d794 Indirect Symbol Table
    0x1d794-0x1ff5c String Table
```

### 7. 只把模版改为宏，其它修改还原
***187K***
```
0x0-0x17000 __TEXT
    0x1b60-0x12b70  __TEXT.__text
    0x12b70-0x12de0 __TEXT.__stubs
    0x12de0-0x131ec __TEXT.__stub_helper
    0x131ec-0x13b5a __TEXT.__objc_methname
    0x13b5a-0x13bb1 __TEXT.__objc_classname
    0x13bb1-0x13e23 __TEXT.__objc_methtype
    0x13e24-0x15c78 __TEXT.__gcc_except_tab
    0x15c80-0x1670d __TEXT.__cstring
    0x16710-0x16930 __TEXT.__const
    0x16930-0x16dd0 __TEXT.__unwind_info
    0x16dd0-0x16ff8 __TEXT.__eh_frame
0x17000-0x19000 __DATA
    0x17000-0x17010 __DATA.__nl_symbol_ptr
    0x17010-0x170e8 __DATA.__got
    0x170e8-0x17428 __DATA.__la_symbol_ptr
    0x17428-0x17430 __DATA.__mod_init_func
    0x17430-0x17798 __DATA.__const
    0x17798-0x17ad8 __DATA.__cfstring
    0x17ad8-0x17b00 __DATA.__objc_classlist
    0x17b00-0x17b08 __DATA.__objc_imageinfo
    0x17b08-0x184f0 __DATA.__objc_const
    0x184f0-0x18830 __DATA.__objc_selrefs
    0x18830-0x188b8 __DATA.__objc_classrefs
    0x188b8-0x188d8 __DATA.__objc_superrefs
    0x188d8-0x18960 __DATA.__objc_ivar
    0x18960-0x18af0 __DATA.__objc_data
    0x18af0-0x18ec0 __DATA.__data
0x19000-0x2dc64 __LINKEDIT
    0x19000-0x190d0 Rebase Info     (opcodes)
    0x190d0-0x19c60 Binding Info    (opcodes)
    0x19c60-0x1a170 Weak Bind Info  (opcodes)
    0x1a170-0x1afe0 Lazy Bind Info  (opcodes)
    0x1afe0-0x1c060 Exports                  
    0x1c060-0x1c198 Function Starts
    0x1c198-0x1c1e0 Data In Code
    0x1c1e0-0x22640 Symbol Table
    0x22640-0x229f4 Indirect Symbol Table
    0x229f4-0x2dc64 String Table
```

### 总结

* 初始 Framework 文件大小 3.7M
```
__TEXT __DATA __LINKEDIT 三个段中，__TEXT __DATA 大小为 952K，__LINKEDIT 为 2.6M
```

* 修改 ```Deployment Postprocessing、Strip Style``` 编译选项
```
可以大大减小 __LINKEDIT，但是不会影响 __TEXT __DATA 的大小
Framework 文件降为 2M，__TEXT __DATA 大小不变，仍然是 952K，__LINKEDIT 为 990K
```

* 继续添加 ```__attribute__((visibility("hidden")))``` 属性
```
可以进一步减小 __LINKEDIT，对于 __TEXT __DATA 有非常微小的影响，可以忽略不计
Framework 文件降为 1.5M，__TEXT __DATA 大小为 944K，__LINKEDIT 为 470K
```

* 在上述基础上，通过将模版改为宏，```此方案最优```
```
会大幅减小 __TEXT __DATA，相应的也会减小 __LINKEDIT
Framework 文件降为 123K，__TEXT __DATA 大小为 100K，__LINKEDIT 为 20K+
```

* 仅将模版改为宏，而不修改编译选项
```
Framework 文件为 187K，__TEXT __DATA 大小为 100K，__LINKEDIT 为 80K+
```

|方案 | Deployment Postprocessing: YES | Strip Style :non-global | attribute visibility hidden | 模版改为宏 | __TEXT __DATA 大小 | __LINKEDIT 大小 | 总大小|
|---|---|---|---|---|---|---|---|
|1   |✗    |✗    |✗    |✗    |952K    |2.6M    |3.7M|
|2   |✅   |✗    |✗    |✗    |952K    |1.5M    |2.5M|
|3   |✅   |✅   |✗    |✗    |952K    |990K    |2M|
|4   |✅   |✅   |✅   |✗    |944K    |470K    |1.5M|
|5   |✅   |✅   |✅   |✅   |100K    |20K+    |***123K***|
|6   |✅   |✅   |✗    |✅   |100K    |28K     |131K|
|7   |✗    |✗    |✗    |✅   |100K    |80K+    |187K|


### References
- [jtool](http://www.newosxbook.com/tools/jtool.html)
- [Xcode中和symbols有关的几个设置](https://www.jianshu.com/p/11710e7ab661)
- [Playing with ```__attributes__ visibility```](https://segmentfault.com/a/1190000004106456)
- [MachOExplorer](https://github.com/everettjf/MachOExplorer/)
- [View Link Map File](https://github.com/huanxsd/LinkMap)
