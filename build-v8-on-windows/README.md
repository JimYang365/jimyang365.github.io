# 前期准备工作

- ## 稳定的上网环境

- ## 准备好 ninja, 将 depot_tools 目录加入系统环境变量 PATH

    ```bash
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    ```
- ##  从微软下载Windows 10 SDK，安装 "Debugging Tools for Windows"  [...](https://developer.microsoft.com/en-US/windows/downloads/windows-10-sdk/)

- ## 设置 cipd_client 的 http 代理设置

    ```bash
    set HTTP_PROXY=127.0.0.1:7890
    set HTTPS_PROXY=127.0.0.1:7890
    ```

- ## set DEPOT_TOOLS_WIN_TOOLCHAIN=0


# 下载源码

```bash
mkdir V8Build
cd V8Build
fetch v8

cd v8
git pull origin 9.1
git new-branch fix-bug-1234
git checkout xxx
cd ..
```

# 同步环境

```bash
gclient sync
```

# 编译

- ## Using v8gen

    ```bash
    # Step 1: Generating build files using v8gen
    python  tools/dev/v8gen.py --help

    # Generate into out.gn/foo without goma auto-detect.
    python  tools/dev/v8gen.py gen -b ia32.release foo --no-goma

    # Step 2: compile V8
    ninja -C out.gn/foo

    # Step 3: run tests
    python tools/run-tests.py --outdir out.gn/foo
    ```

- ## Using vs

    ```bash
    # Step 1: 生成解决方案
    cd v8/src
    gn gen --ide=vs out\Default

    # Step 2: 编译
    devenv out\Default\all.sln

    # Step 3: 测试
    out\Default\v8_shell.exe
    ```

# 参考

https://v8.dev/docs/  
http://www.neohope.com/2020/03/21/%E7%BC%96%E8%AF%91v8%E5%BC%95%E6%93%8E/
