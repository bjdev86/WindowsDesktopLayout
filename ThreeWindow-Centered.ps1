# Module to build a three window centered workspace. Where the middle window is largest.

# Add necessary types for window manipulation (Import user32.dll)
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WindowManipulation
{
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
"@

# Import required binaries 
Add-Type -AssemblyName System.Windows.Forms; 

# Constants
New-Variable -Name SCRNWIDTH -Value ([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width) -Option Constant
New-Variable -Name SCRNHEIGHT -Value ([System.Windows.Forms.SystemInformation]::WorkingArea.Height) -Option Constant

# Function to start a process and move its window
function Start-And-Position 
{
    param (
        [string]$processPath,
        [int]$x,
        [int]$y,
        [int]$width,
        [int]$height
    )

    # Start the application process
    Start-Process -FilePath $processPath -ErrorAction SilentlyContinue;
    
    # Wait for the process to start and the window to appear
    Start-Sleep -Seconds 1; 

    # Parse the process name (The pure name of the process sans path and extension)
    $proName = @($processPath -split "[\\\.]")[-2];   

    # Find the window handle
    $hWnd = Get-Process -Name $proName | Select-Object -ExpandProperty MainWindowHandle;
    #TODO: Inspect and try to see if this pipeline can work better: $AppProcess = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne [System.IntPtr]::Zero } | Select-Object -First 1
    
    # For windows/processes with the same name filter off the first hanldle. It's the one tied to the process.
    $hWnd = $hWnd -is [System.Array] ? $hWnd[0] : $hWnd;  
    
    if ($hWnd -ne [IntPtr]::Zero) 
    {
        # Move the window
        [WindowManipulation]::MoveWindow($hWnd, $x, $y, $width, $height, $true)
    } 
    else 
    {
        <#TODO: Wrap in try/catch and attempt to retry. To do this consider breaking the "Start" and "Position" functions up, so 
        that they can be called separately. This way a recursive loop can be used to rety the process of starting the 
        applicaiotn. Don't forget a counter :). #>
        Write-Host "Window not found: $procName"
    }
}

function Start-Center ([string]$processPath) 
{ 
    # Calculate the window size
    [int]$windowWidth = $SCRNWIDTH / 2; 
    [int]$windowHeight = $SCRNHEIGHT;

    # Calculate the window position
    $x = ($SCRNWIDTH / 4);
    $y = 0;

    Start-And-Position $processPath $x $y $windowWidth $windowHeight 
}

function Start-Left ([string]$processPath)
{  
    # Calculate the window size
    [int]$windowWidth = $SCRNWIDTH / 4; 
    [int]$windowHeight = $SCRNHEIGHT;

    # Calculate the window position
    $x = 0;
    $y = 0;

    Start-And-Position $processPath $x $y $windowWidth $windowHeight 
}

function Start-Right ([string]$processPath)
{  
    # Calculate the window size
    [int]$windowWidth = $SCRNWIDTH / 4; 
    [int]$windowHeight = $SCRNHEIGHT;

    # Calculate the window position
    $x = ($SCRNWIDTH - $windowWidth);
    $y = 0;

    Start-And-Position $processPath $x $y $windowWidth $windowHeight 
}
