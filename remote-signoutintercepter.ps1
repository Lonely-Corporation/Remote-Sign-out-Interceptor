# Load required assembly and log success
Add-Type -AssemblyName System.Windows.Forms
Write-Host "Successfully loaded System.Windows.Forms assembly at $(Get-Date -Format 'HH:mm:ss')"

# Define the custom form class using inline C#
$source = @"
using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;

public class SignoutInterceptorForm : Form
{
    private const int WM_QUERYENDSESSION = 0x0011;
    private const uint ENDSESSION_LOGOFF = 0x80000000;

    protected override void WndProc(ref Message m)
    {
        if (m.Msg == WM_QUERYENDSESSION)
        {
            string title = "Confirmation";
            string message;
            if (((uint)m.LParam & ENDSESSION_LOGOFF) != 0)
            {
                message = "Are you sure you want to sign out?";
            }
            else
            {
                message = "Are you sure you want to shut down or restart?";
            }

            DialogResult result = MessageBox.Show(message, title, MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.No)
            {
                m.Result = IntPtr.Zero; // Prevent the action
            }
            else
            {
                m.Result = new IntPtr(1); // Allow the action
            }
            return;
        }
        base.WndProc(ref m);
    }
}
"@

# Compile the custom form and log success or failure
try {
    Add-Type -TypeDefinition $source -ReferencedAssemblies System.Windows.Forms
    Write-Host "Successfully compiled SignoutInterceptorForm at $(Get-Date -Format 'HH:mm:ss')"
} catch {
    Write-Host "Error compiling SignoutInterceptorForm: $_ at $(Get-Date -Format 'HH:mm:ss')"
    exit
}

# Create the form instance and log success or failure
try {
    $form = New-Object SignoutInterceptorForm
    Write-Host "Successfully created SignoutInterceptorForm instance at $(Get-Date -Format 'HH:mm:ss')"
} catch {
    Write-Host "Error creating SignoutInterceptorForm instance: $_ at $(Get-Date -Format 'HH:mm:ss')"
    exit
}

# Configure the form and log each step
Write-Host "Configuring form properties at $(Get-Date -Format 'HH:mm:ss')"
$form.Opacity = 0
Write-Host "Set Opacity to 0 at $(Get-Date -Format 'HH:mm:ss')"
$form.ShowInTaskbar = $false
Write-Host "Set ShowInTaskbar to false at $(Get-Date -Format 'HH:mm:ss')"
$form.WindowState = [System.Windows.Forms.FormWindowState]::Minimized
Write-Host "Set WindowState to Minimized at $(Get-Date -Format 'HH:mm:ss')"
$form.Location = New-Object System.Drawing.Point(-10000, -10000)
Write-Host "Set Location to off-screen at $(Get-Date -Format 'HH:mm:ss')"
$form.Size = New-Object System.Drawing.Size(1, 1)
Write-Host "Set Size to 1x1 at $(Get-Date -Format 'HH:mm:ss')"

# Start the application message loop and log start
Write-Host "Starting application message loop at $(Get-Date -Format 'HH:mm:ss')"
[System.Windows.Forms.Application]::Run($form)