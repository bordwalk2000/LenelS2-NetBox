# LenelS2-NetBox PowerShell Module

This module allows an easy interface to quickly work with the LenelS2 NetBox API.


## Installation

Currently the module needs to be built from source.  Files required are going to be located in Output directory.

<!-- The LenelS2-NetBox PowerShell Module is published to [PowerShell Gallery]().

```powershell
Install-Module -Name LenelS2-NetBox
``` -->


## Developer Instructions

If you want to run this module from source it can found at [GitHub](https://github.com/bordwalk2000/LenelS2-NetBox).


To build the module, make sure you have the following pre-req modules:

- ModuleBuilder (Required Version 2.0.0)

Start the build by running the following powershell ps1 file:

```powershell
Start-ModuleBuild.ps1
```

This will package all code into files located in .\Output\LenelS2-NetBox.  That folder is now ready to be installed, copy to any path listed in you PSModulePath environment variable and you are good to go!


### Source Files Folder structure

- All building files must in Source folders:
  - In the root, place the module manifest
    - In Public, place functions accessible by users
    - In Private, place functions that inaccessible by users, e.g. helper functions
    - Place one function per file, and file name must match the name of the function
- In the root of the repository we have:
  - Install-Requirements.ps1, this script installs all required modules for this module to be built
  - Start-ModuleBuild.ps1, builds the module with files from Source folder and puts thm into Output folder


### About ModuleBuilder

You can find source of ModuleBuilder located on [GitHub](https://github.com/PoshCode/ModuleBuilder)


---

Originally forked from [bciu22/PowerShell-S2-API](https://github.com/bciu22/PowerShell-S2-API)

Maintained by Bradley Herbst