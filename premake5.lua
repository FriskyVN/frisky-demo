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
      "SDL2main"
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
        "external/sdl2-vc/include"
      }

    filter {}

    local cwd = os.getcwd()
    local sdl2 = cwd .. "\\external\\sdl2-vc\\lib\\"
    local dest = cwd .. "\\bin\\%{cfg.buildcfg}\\%{cfg.platform}"

    filter { "system:windows", "action:vs*", "platforms:*32" }
      libdirs {
        "external/sdl2-vc/lib/x86/"
      }

      postbuildcommands {
        "copy \"" .. sdl2 .. "x86\\SDL2.dll\" \"" .. dest .. "\""
      }

    filter { "system:windows", "action:vs*", "platforms:*64" }
      libdirs {
        "external/sdl2-vc/lib/x64/"
      }

      postbuildcommands {
        "copy \"" .. sdl2 .. "x64\\SDL2.dll\" \"" .. dest .. "\""
      }

    filter {}
