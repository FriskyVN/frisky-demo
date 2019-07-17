workspace "FriskyDemo"
  configurations { "Debug", "Release" }
  platforms      {   "x64", "x32"     }

  local project_action = "UNDEFINED"

  if _ACTION ~= nill then
    project_action = _ACTION
  end

  location ( "build/" .. project_action )

  cppdialect "C++17"
  warnings   "Extra"

  exceptionhandling "Off"
  rtti "Off"

  filter { "configurations:Debug" }
    defines { "DEBUG" }
    symbols "On"

  filter { "configurations:Release" }
    defines { "NDEBUG" }
    optimize "On"

  filter { "platforms:*32" }
    architecture "x86"

  filter { "platforms:*64" }
    architecture "x64"

  filter { "system:windows", "action:vs*" }
    flags {
      "MultiProcessorCompile",
      "NoMinimalRebuild",
      "ShadowedVariables"
    }
    buildoptions {
      "/permissive-",
      "/Za",
      "/Zc:rvalueCast"
    }
    linkoptions {
      "/ignore:4099"
    }

  filter { "system:windows", "action:vs*", "configurations:release" }
    buildoptions {
      "/Ot"
    }

  filter { "action:gmake" }

  filter { "system:macosx", "action:gmake"}
    toolset "clang"

  filter {}

  project "FriskyDemo"
    language   "C++"
    targetdir  "bin/%{cfg.buildcfg}/%{cfg.platform}"
    debugdir   "bin/%{cfg.buildcfg}/%{cfg.platform}"
    targetname "friskydemo"

    files {
      "src/**.h",
      "src/**.hpp",
      "src/**.c",
      "src/**.cpp"
    }

    includedirs {
      "src/"
    }

    links {
      "SDL2",
      "SDL2main",
      "SDL2_image",
      "SDL2_ttf",
      "lua53"
    }

    filter { "configurations:Debug" }
      kind "ConsoleApp"

    filter { "configurations:Release" }
      kind "WindowedApp"

    filter { "system:windows", "action:vs*" }
      vpaths {
        ["Header Files/*"] = {
          "src/**.h",
          "src/**.hxx",
          "src/**.hpp",
        },
        ["Source Files/*"] = {
          "src/**.c",
          "src/**.cxx",
          "src/**.cpp",
        },
      }

      includedirs {
        "external/frisky-core/include",
        "external/lua-vc/include",
        "external/sdl2-vc/include",
        "external/sdl2image-vc/include",
        "external/sdl2ttf-vc/include"
      }

    filter {}

    local cwd = os.getcwd()
    local resources = cwd .. "\\resources"
    local lua       = cwd .. "\\external\\lua-vc\\lib\\"
    local sdl2      = cwd .. "\\external\\sdl2-vc\\lib\\"
    local sdl2image = cwd .. "\\external\\sdl2image-vc\\lib\\"
    local sdl2ttf   = cwd .. "\\external\\sdl2ttf-vc\\lib\\"
    local dest      = cwd .. "\\bin\\%{cfg.buildcfg}\\%{cfg.platform}"

    filter { "system:windows", "action:vs*", "platforms:*32" }
      libdirs {
        "external/lua-vc/lib/x86",
        "external/sdl2-vc/lib/x86/",
        "external/sdl2image-vc/lib/x86",
        "external/sdl2ttf-vc/lib/x86"
      }

      postbuildcommands {
        "xcopy /E /I /Y \"" .. resources .. "\" \"" .. dest .. "\\resources\"",
        "copy \"" .. lua       .. "x86\\lua53.dll\" \""      .. dest .. "\"",
        "copy \"" .. sdl2      .. "x86\\SDL2.dll\" \""       .. dest .. "\"",
        "copy \"" .. sdl2image .. "x86\\SDL2_image.dll\" \"" .. dest .. "\"",
        "copy \"" .. sdl2ttf   .. "x86\\SDL2_ttf.dll\" \""   .. dest .. "\""
      }

    filter { "system:windows", "action:vs*", "platforms:*64" }
      libdirs {
        "external/lua-vc/lib/x64",
        "external/sdl2-vc/lib/x64/",
        "external/sdl2image-vc/lib/x64",
        "external/sdl2ttf-vc/lib/x64"
      }

      postbuildcommands {
        "xcopy /E /I /Y \"" .. resources .. "\" \"" .. dest .. "\\resources\"",
        "copy \"" .. lua       .. "x64\\lua53.dll\" \""      .. dest .. "\"",
        "copy \"" .. sdl2      .. "x64\\SDL2.dll\" \""       .. dest .. "\"",
        "copy \"" .. sdl2image .. "x64\\SDL2_image.dll\" \"" .. dest .. "\"",
        "copy \"" .. sdl2ttf   .. "x64\\SDL2_ttf.dll\" \""   .. dest .. "\""
      }

    filter {}
