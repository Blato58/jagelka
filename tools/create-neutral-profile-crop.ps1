param(
    [string]$SourcePath
)

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($SourcePath)) {
    $SourcePath = Join-Path $root "assets\jagelka-profile-redacted.jpg"
}
$outPath = Join-Path $root "assets\jagelka-profile-neutral.jpg"

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Source image not found: $SourcePath. Keep the source ID image local and untracked, then pass it with -SourcePath if needed."
}

$source = [System.Drawing.Image]::FromFile($SourcePath)
$size = 800
$bitmap = [System.Drawing.Bitmap]::new($size, $size)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Crop only the portrait area, avoiding document text and country header.
$sourceRect = [System.Drawing.Rectangle]::new(185, 320, 390, 390)
$destRect = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
$graphics.DrawImage($source, $destRect, $sourceRect, [System.Drawing.GraphicsUnit]::Pixel)

$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" } |
    Select-Object -First 1
$params = [System.Drawing.Imaging.EncoderParameters]::new(1)
$params.Param[0] = [System.Drawing.Imaging.EncoderParameter]::new([System.Drawing.Imaging.Encoder]::Quality, 88L)

$bitmap.Save($outPath, $encoder, $params)

$params.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
$source.Dispose()

Write-Host $outPath
