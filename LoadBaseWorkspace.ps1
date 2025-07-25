<#
.AUTHOR
    Ben Miller
.DATE
    7/24/2025

.SYNOPSIS
    Load the base workspace.
.DESCRIPTION
    Load the base workspace. Open Outlook in the center half and Edge on the left quarter. 
.EXAMPLE
    LoadBaseWorkspace.ps1

TODO: 
    - Add a parameter to specify the workspace to load. 
    - Provide for the passing of arguments to applicaitons loaded when the workspace is loaded.
#>

# Import modules
. "$PSScriptRoot\ThreeWindow-Centered.ps1"

# Load Workspace.
# Open Outlook in the center half and Edge on the left quarter. 
Start-Center "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" "Outlook"; 
Start-Left  "msedge.exe";
