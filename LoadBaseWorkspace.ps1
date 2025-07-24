# Script to load a 'defualt workspace' for the desktop for a given user profile when they log into Widnwos.

# Add necessary types for window manipulation
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
}
"@

# Import required libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -Namespace WinAPI -Name User32Functions

# Function to start a process and move its window
function Start-And-Position {
    param (
        [string]$processPath,
        [string]$windowTitle,
        [int]$x,
        [int]$y,
        [int]$width,
        [int]$height
    )

    # Start the process
    $process = Start-Process -FilePath $processPath -PassThru
    Write-Host "Process started: $($process.Id)";
    Write-Host "Process just started: $($process | Format-List *)";   
    # Wait for the process to start and the window to appear
    Write-Host "Before sleep";
   
        Start-Sleep -Seconds 5; 
        Write-Host "After sleep";

    
        # Find the window handle
        $hWnd = [User32]::FindWindow($null, $windowTitle)
        Write-Host "Window handle: $(if($hWnd -eq $null) {'Null'} else {'Not Null'})";       
        Write-Host "Window handle evaluated: $($hWnd | Select-Object * | Format-List)"; 

    #if ($hWnd -ne [IntPtr]::Zero) {
    if ($hWnd -ne $null) {
        # Move the window
        [User32]::MoveWindow($hWnd, $x, $y, $width, $height, $true)
    } else {
        Write-Host "Window not found: $windowTitle"
    }
}

function Start-And-Center ([string]$processPath, [string]$windowTitle) {
    # Get the screen size
    $screenWidth = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
    $screenHeight = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
    Write-Host "Screen size: $screenWidth x $screenHeight"
    # Get the window size
    #$windowSize = Get-WmiObject -Class Win32_Window -Filter "Caption = '$windowTitle'" | Select-Object -ExpandProperty Size
    [int]$windowWidth = $screenWidth/2; 
    [int]$windowHeight = $screenHeight;
    Write-Host "Window size: $windowWidth x $windowHeight";

    # Calculate the window position
    $x = ($screenWidth - $windowSize.Width) / 2
    #$y = ($screenHeight - $windowSize.Height) / 2
    $y = $screenHeight;

    Start-And-Position $processPath $windowTitle $x $y $windowWidth $windowHeight 
}


# Example usage
#Start-And-Position "notepad.exe" "Untitled - Notepad" 100 100 800 600
#Start-And-Position "C:\Path\To\YourApp.exe" "Your App Window Title" 200 200 1024 768
# Open Outlook in the center half and Edge on the left quarter. 
#Start-And-Center "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" "Outlook"; 
Start-And-Center "notepad.exe" "Unititled - Notepad";