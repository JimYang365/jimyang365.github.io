# 动态加载 CEF, dynamic load cef

最近打算用 CEF 给我们自己的应用做一套插件系统，功能很简单，简单说来就两个：支持自定义 js 接口，支持 html 页面展现。

做的时候遇到了一个问题，就是 CEF 官方示例都是基于 CEF 进程架构，只要主程序一启动，相关进程都要起来。我们的需求是，当前应用程序只有在需要 CEF 的时候再启动。所以，要搞定的是动态加载 CEF，启动相关进程。

总体的实现思路如下：


- ### 将函数声明修改为函数指针

    拿 `cef_initialize` 来举例，CEF 官方声明是这样

    ```cpp
    CEF_EXPORT int cef_initialize(const struct _cef_main_args_t* args,
                                const struct _cef_settings_t* settings,
                                cef_app_t* application,
                                void* windows_sandbox_info);
    ```

    我们通过简单的 python 脚本，将其改为下面这个样子，需要改的函数将近 400 个。

    ```cpp
    #ifndef SW_DYNAMIC_CEF
    CEF_EXPORT int cef_initialize(const struct _cef_main_args_t* args,
                                const struct _cef_settings_t* settings,
                                cef_app_t* application,
                                void* windows_sandbox_info);
    #else
    typedef int (*cef_initialize_t)(const struct _cef_main_args_t* args,
                                const struct _cef_settings_t* settings,
                                cef_app_t* application,
                                void* windows_sandbox_info);
    extern cef_initialize_t cef_initialize;
    #endif
    ```

- ### 动态加载

    脚本在修改 CEF 函数声明的同时，生成下面这样的函数定义，我们通过主动调用 `initializeCEFFunctions` 来加载 CEF

    ```cpp
    cef_initialize_t cef_initialize = NULL;
    void initializeCEFFunctions(HMODULE cefModule) {
        #define gcef(X, Y) (X)GetProcAddress(cefModule, Y);
        cef_initialize = gcef(cef_initialize_t, "cef_initialize");
    }
    ```

- ### 独立的消息循环

    为了将我们自己的主线程和 CEF 主线程分离，需要将 `CefSettings` 的 `multi_threaded_message_loop` 设置为 `true` ，两个线程通过 CEF 的 `PostTask` 机制进行通信。

