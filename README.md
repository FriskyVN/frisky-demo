# frisky-demo
> A sample repository for the Frisky visual novel engine.

## Requirements
* [git](https://git-scm.com/)
* [Visual Studio Community 2019](https://visualstudio.microsoft.com/vs/)
* [Premake 5](https://premake.github.io/)

## Download
1. Clone this repository.
    ```shell
    git clone https://github.com/FriskyVN/frisky-demo.git
    ```
2. Download external dependencies as submodules.
    ```shell
    cd frisky-demo
    git submodule update --init --recursive
    ```

### Update Submodules
Submodules, once downloaded, may be updated to the most recent versions hosted on GitHub with the following command:
```shell
git submodule update --remote
```

## Build
1. Use Premake to create a Visual Studio 2019 solution.
    ```shell
    premake5 vs2019
    ```
2. Open the Visual Studio 2019 solution in `build/vs2019`.
3. Use Visual Studio 2019 to compile and execute.
