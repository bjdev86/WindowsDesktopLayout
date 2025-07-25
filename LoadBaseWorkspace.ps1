# Import modules
. "$PSScriptRoot\ThreeWindow-Centered.ps1"

# Load Workspace.
# Open Outlook in the center half and Edge on the left quarter. 
Start-Center "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" "Outlook"; 
Start-Left  "msedge.exe";
Start-Right "notepad.exe"; 
