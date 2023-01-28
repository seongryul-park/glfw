workspace "BlackBerry"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

    outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

    IncludeDir = {}
    IncludeDir["GLFW"] = "BlackBerry/vendor/GLFW/include"
    
    include "BlackBerry/vendor/GLFW"

project "BlackBerry"
    location "BlackBerry"
    kind "SharedLib"
    language "C++"
    systemversion "latest"

    targetdir ("bin/"..outputdir.."/%{prj.name}")
    objdir ("bin-int/"..outputdir.."/%{prj.name}")

	pchheader "BBpch.h"
	pchsource "BlackBerry/src/BBpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include",
        "%{prj.name}/vendor/spdlog/include",
		"%{IncludeDir.GLFW}"
	}

	links 
	{ 
		"GLFW",
		"opengl32.lib"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"

        defines
        {
            "BB_PLATFORM_WINDOWS",
            "BB_BUILD_DLL"
        }

        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
        }

    filter "configurations:Debug"
        defines "BB_DEBUG"
        symbols "On"
        
    filter "configurations:Release"
        defines "BB_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "BB_DIST"
        optimize "On"

project "Sandbox"
location "Sandbox"
kind "ConsoleApp"
language "C++"
systemversion "latest"

targetdir ("bin/"..outputdir.."/%{prj.name}")
objdir ("bin-int/"..outputdir.."/%{prj.name}")

files
{
    "%{prj.name}/src/**.h",
    "%{prj.name}/src/**.cpp"
}

includedirs 
{
    "BlackBerry/vendor/spdlog/include",
    "BlackBerry/src"
}

links
{
    "BlackBerry"
}

filter "system:windows"
    cppdialect "C++17"
    staticruntime "On"

    defines
    {
        "BB_PLATFORM_WINDOWS"
    }

filter "configurations:Debug"
    defines "BB_DEBUG"
    symbols "On"
    
filter "configurations:Release"
    defines "BB_RELEASE"
    optimize "On"

filter "configurations:Dist"
    defines "BB_DIST"
    optimize "On"