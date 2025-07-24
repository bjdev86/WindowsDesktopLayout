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
    # Wait for the process to start and the window to appear
    Start-Sleep -Seconds 5

    # Find the window handle
    $hWnd = [User32]::FindWindow($null, $windowTitle)

    if ($hWnd -ne [IntPtr]::Zero) {
        # Move the window
        [User32]::MoveWindow($hWnd, $x, $y, $width, $height, $true)
    } else {
        Write-Host "Window not found: $windowTitle"
    }
}

# Example usage
Start-And-Position "notepad.exe" "Untitled - Notepad" 100 100 800 600
Start-And-Position "C:\Path\To\YourApp.exe" "Your App Window Title" 200 200 1024 768
