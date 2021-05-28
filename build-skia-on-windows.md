# build skia on windows

**skia** 是啥就不多说了，首先呢要有 **稳定的上网环境** ，这是必须的，另外需要 **python2**，不能用 py3，还要有 **LLVM**。
官方文档在这里，https://skia.org/docs/，如何编译在这 https://skia.org/docs/user/build/，其实讲的还算清楚，就是关于 Windows 的讲的不是很详细，下面开始正题。

 ## 1. 准备好 ninja
`git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git`
将 `depot_tools` 目录加入系统环境变量 PATH

 ## 2. 下载 skia 代码
`git clone https://skia.googlesource.com/skia.git`
将 `skia\bin` 加入环境变量 PATH

## 3. 同步三方代码
```
cd skia
c:\Python27\python.exe tools/git-sync-deps
```
## 4. 开始编译
官方强烈推荐 clang，咱们也乖一些。我用 vs 没搞定 x86，也许有解决方案，总之我是没搞定，老老实实用 clang 吧，我用的是当前最新版 [LLVM-12.0.0](https://releases.llvm.org/download.html)
**Highly Recommended: Build with clang-cl**  https://skia.org/docs/user/build/#highly-recommended-build-with-clang-cl

#### x86
`--args` 的具体用法，请大家自行搜索吧

#####  x86 debug
```sh
bin\gn gen out/debugx86 --args=" is_debug=true  target_cpu=\"x86\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MTd\"]"
```
上面的脚本应该会遇到类似这个错误
```sh
 'C:/Program' is not recognized as an internal or external command, operable program or batch file.
```
要手动将 `out/debugx86/toolchain.ninja` 里所有类似  `cmd /c C:/Program Files (x86)/Windows Kits/10/bin/SetEnv.cmd /x86 &&` 的内容全部删掉，下面 x86 release 也会遇到这个问题，处理方法一样
接下来：
```sh
ninja -C out/debugx86
```
#####  x86 release
```sh
bin\gn gen out/releasex86 --args=" is_debug=false  target_cpu=\"x86\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MT\"]"
ninja -C out/releasex86
```
### x64
vs 和 clang 都能搞定 x64，咱们一个个来
#### x64 by clang
推荐用这个，下面 vs 的也能用
```sh
bin\gn gen out/debugx64 --args="is_debug=true target_cpu=\"x64\"  clang_win=\"C:\Program Files\LLVM\" extra_cflags=[\"/MTd\"]"
ninja -C out/debugx64

bin\gn gen out/releasex64 --args="is_debug=false target_cpu=\"x64\" clang_win=\"C:\Program Files\LLVM\"  extra_cflags=[\"/MT\"]"
ninja -C out/releasex64
```
##### x64 by vs
```sh
bin\gn gen out/debugx64vs --args="is_debug=true target_cpu=\"x64\"  win_vc=\"d:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\" extra_cflags=[\"/MTd\"]"
ninja -C out/debugx64vs

bin\gn gen out/releasex64vs --args="is_debug=false target_cpu=\"x64\" win_vc=\"d:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\"  extra_cflags=[\"/MT\"]"
ninja -C out/releasex64vs
```

至此，所有的 lib  已经生成好了，用 clang 生成的文件要比用 vs 的小很多
上面生成的都是静态库，如果需要动态库（DLL），再加个 `is_component_build=true` 编译参数就行

下面是生成 vs solution 的方法，会生成一个 `all.sln`，可以用来看看 skia 自带的例子
```sh
gn gen out/sln --ide=vs --args="is_debug=false target_cpu=\"x64\" win_vc=\"d:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\"  extra_cflags=[\"/MT\"]"
```

最后，附上一个 [buildWin32.bat](./buildWin32.bat)