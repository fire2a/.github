# windows debellopour headache

If you want to shoot yourself in the groin or worse, follow these instructions.  
Else if you have any common programmer sense, use linux or at least wsl.

0. Have QGIS Network version installed (repeat every QGIS upgrade)

0. clone repos
    
        # using cmd terminal (not powershell)
        # assuming all repos are here
        mkdir c:\LOCAL\fire
        cd c:\LOCAL\fire

        git clone git@github.com:fire2a/C2F-W.git
        git clone git@github.com:fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
        git clone git@github.com:fire2a/fire2a-lib.git lib
    

0. install the plugin by making a symbolic from `toolbox` repo to plugins folder
    
    ```cmd
    mklink /D %appdata%\QGIS\QGIS3\profiles\default\python\plugins\fireanalyticstoolbox C:\LOCAL\fire\toolbox\fireanalyticstoolbox
    ```

0. Build or download a `Cell2fire.exe` executable
    
    A. Build:

        Windows Build instructions : https://fire2a.github.io/docs/Cell2FireW/compile_windows.html  
        All builds instructions : https://github.com/fire2a#developer-setup  
        TODO VsCode Windows Local Runner Build

    B. Download
        
        Download the windows binary from https://github.com/fire2a/C2F-W/releases/latest  
        For example: Cell2FireW_v1.0.1-Windows-x86_64-binary.zip  
        mkdir C:\LOCAL\fire\toolbox\fireanalyticstoolbox\simulator\C2F\Cell2Fire
        Extract contents to C:\LOCAL\fire\toolbox\fireanalyticstoolbox\simulator\C2F\Cell2Fire  
        So you have C:\LOCAL\fire\toolbox\fireanalyticstoolbox\simulator\C2F\Cell2Fire\Cell2Fire.exe

0. Install fire2a-lib in editable mode into QGIS python

    https://fire2a.github.io/docs/qgis-management/plugins.html#osgeo4w-shell-windows
    
        # keep track of git, because the next command empties the PATH
        > where git
        C:\Program Files\Git\cmd\git.exe <--- in my machine

        # go to directory, launch and exit QGIS python
        > cd C:\OSGeo4W\bin
        > python-qgis.bat
        >>>exit()
        
        # make sure pip is found
        > where pip
        c:\OSGeo4W\apps\Python312\Scripts\pip.bat <--- ok!
        C:\OSGeo4W\apps\Python312\Scripts\pip.exe

        # make sure git is found
        > PATH=%PATH%;C:\Program Files\Git\cmd <--- same directory as the first where git command
        > where git

        # install editable
        cd c:\LOCAL\fire\lib
        pip install -e .

0. Optional: To use the decision optimization module you must have a solver, cplex or gurobi is best, but cbc is open source and easy to install:

        Got to this repository: "coin-or/Cbc"
        Download the latest release, it should be a fileName like `*w64-msvc17*.zip`
        Extract its content to path: `fireanalyticstoolbox/cbc`
        You should have now `fireanalyticstoolbox/cbc/bin/cbc.exe`

0. Make sure you disable the auto install fire2a-lib from pip by editing this file `    C:\LOCAL\fire\toolbox\fireanalyticstoolbox\dependencies_handler.txt`
    Set enabled to False: 
        
        [general]
        plugin_dependencies = fire2a-lib==0.3.11
        enabled = True                          <-- edit this True to False!

    Or when prompted by the plugin dialog about not having the same version of fire2a-lib installed, make sure to click the checkbox "Do not attempt to check and install dependencies again!"  
    Else you'll overwrite the installation, left wondering why your changes doesn't apply!

0. All set! Open QGIS and test it!  
Remember that even though the plugin can reload on the fly, the fire2a-lib module does not until QGIS restart.




