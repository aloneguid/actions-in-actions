function Take-Screenshot {
    param (
        [string]$FileName
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $bounds = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = New-Object Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)
    $bitmap.Save($FileName, [Drawing.Imaging.ImageFormat]::Png)
}

# Example usage:
# Take-Screenshot -FileName "screenshot.png"

function Set-ScreenResolution {
    param (
        [int]$Width = 3840,
        [int]$Height = 2160
    )

    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class User32 {
        [DllImport("user32.dll")]
        public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);
        [StructLayout(LayoutKind.Sequential)]
        public struct DEVMODE {
            public const int CCHDEVICENAME = 32;
            public const int CCHFORMNAME = 32;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
            public string dmDeviceName;
            public short dmSpecVersion;
            public short dmDriverVersion;
            public short dmSize;
            public short dmDriverExtra;
            public int dmFields;
            public int dmPositionX;
            public int dmPositionY;
            public int dmDisplayOrientation;
            public int dmDisplayFixedOutput;
            public short dmColor;
            public short dmDuplex;
            public short dmYResolution;
            public short dmTTOption;
            public short dmCollate;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHFORMNAME)]
            public string dmFormName;
            public short dmLogPixels;
            public short dmBitsPerPel;
            public int dmPelsWidth;
            public int dmPelsHeight;
            public int dmDisplayFlags;
            public int dmDisplayFrequency;
            public int dmICMMethod;
            public int dmICMIntent;
            public int dmMediaType;
            public int dmDitherType;
            public int dmReserved1;
            public int dmReserved2;
            public int dmPanningWidth;
            public int dmPanningHeight;
        }
    }
"@

    $devMode = New-Object User32+DEVMODE
    $devMode.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($devMode)
    $devMode.dmPelsWidth = $Width
    $devMode.dmPelsHeight = $Height
    $devMode.dmFields = (0x80000 -bor 0x100000)
    [User32]::ChangeDisplaySettings([ref]$devMode, 0)
}

# Example usage:
# Set-ScreenResolution -Width 3840 -Height 2160

function Open-NotepadAndType {
    param (
        [string]$Text
    )

    Start-Process notepad
    Start-Sleep -Seconds 2 # Give Notepad some time to open

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait($Text)
}

function Open-BrowserAndNavigate {
    param (
        [string]$Url
    )

    Start-Process "msedge.exe" $Url
    Start-Sleep -Seconds 5 # Give the browser some time to open and navigate
}

# Open-BrowserAndNavigate -Url "https://www.example.com"

## ---- the stuff ------ ##

Take-Screenshot -FileName "init.png"

Set-ScreenResolution
Start-Sleep -Seconds 5
Take-Screenshot -FileName "4k.png"

Open-NotepadAndType -Text "Follow the white rabbit"
Take-Screenshot -FileName "notepad.png"

Open-BrowserAndNavigate -Url "https://www.microsoft.com/en-gb/"
start-Sleep -Seconds 5
Take-Screenshot -FileName "browser.png"

