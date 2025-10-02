> This does not work very well, its useless and was made by AI.
# Random Signout Interceptor

This repository contains a PowerShell script, `remote-signout-intercepter.ps1`, designed to intercept and prompt for confirmation on sign-outs, shutdowns, and restarts (including remote actions) on a Windows 11 system without requiring administrative privileges.

## Overview

The script creates a hidden Windows Form that listens for the `WM_QUERYENDSESSION` system message, which is triggered by sign-out, shutdown, or restart events. When detected, it displays a confirmation dialog asking the user to confirm or cancel the action. This works for both local and remote events (e.g., initiated via `shutdown` or `logoff` commands), provided they are not forced (e.g., using the `/f` flag).

## Features
- Intercepts sign-outs, shutdowns, and restarts.
- Supports remote sign-outs and shutdowns initiated from another machine.
- Runs in the user context, requiring no admin rights.
- Provides a confirmation dialog with "Yes" and "No" options.
- Cancels the action if "No" is selected.

## Prerequisites
- Windows 11 operating system.
- PowerShell installed (included with Windows by default).
- Execution policy set to allow running scripts (configurable if needed).

## Installation

1. **Save the Script**:
   - Copy the contents of `remote-signout-intercepter.ps1` into a file named `remote-signout-intercepter.ps1`.
   - Save it in a directory, e.g., `C:\Users\<YourUsername>\Scripts\remote-signout-intercepter.ps1`.

2. **Set Execution Policy (if required)**:
   - Open PowerShell and run:
     ```
     Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
     ```
   - This allows local scripts to run without admin privileges.

3. **Run the Script**:
   - Open PowerShell and execute:
     ```
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YourUsername>\Scripts\remote-signout-intercepter.ps1"
     ```
   - The PowerShell window will stay open, and the script will run in the background.

4. **Add to Startup (Optional)**:
   - Press `Win + R`, type `shell:startup`, and press Enter to open the Startup folder.
   - Create a shortcut with the target:
     ```
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<YourUsername>\Scripts\remote-signout-intercepter.ps1"
     ```
   - This ensures the script runs automatically on login.

## Usage

- **Local Testing**:
  - Trigger a sign-out (Start > User > Sign out), shutdown (Start > Power > Shut down), or restart.
  - A dialog will appear: "Are you sure you want to sign out?" or "Are you sure you want to shut down or restart?"
  - Select "No" to cancel, "Yes" to proceed.

- **Remote Testing**:
  - From another machine with network access and permissions:
    - Remote shutdown: `shutdown /m \\<yourcomputername> /s /t 0`
    - Remote sign-out: Use `quser /server:<yourcomputername>` to find the session ID, then `logoff <sessionid> /server:<yourcomputername>`
  - The confirmation dialog should appear on the target machine.

## Debug Output
The script includes detailed debug logging to confirm operation:
- "Successfully loaded System.Windows.Forms assembly at [time]"
- "Successfully compiled SignoutInterceptorForm at [time]"
- "Successfully created SignoutInterceptorForm instance at [time]"
- "Configuring form properties at [time]"
- "Set Opacity to 0 at [time]"
- "Set ShowInTaskbar to false at [time]"
- "Set WindowState to Minimized at [time]"
- "Set Location to off-screen at [time]"
- "Set Size to 1x1 at [time]"
- "Starting application message loop at [time]"
- Check the PowerShell console for these messages after running the script.

## Limitations
- Does not intercept forced actions (e.g., `shutdown /m \\<computername> /s /f` or hardware power-offs).
- Requires the PowerShell window to remain open for the script to function.
- May not catch all remote actions if initiated with tools bypassing `WM_QUERYENDSESSION`.

## Troubleshooting
- **No Dialog Appears**: Ensure the script is running and the PowerShell window is open. Test with a local action first.
- **Errors on Run**: Check the execution policy with `Get-ExecutionPolicy -Scope CurrentUser`. Adjust if necessary.
- **Debug Output Missing**: Verify the script path and contents match the provided code.

## Contributing
Feel free to fork this repository and submit pull requests for improvements (e.g., adding a tray icon to manage the script).

## License
This script is provided as-is without warranty. Use at your own risk.
Under MIT License.
