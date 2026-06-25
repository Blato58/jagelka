Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root "social"
$assetPath = Join-Path $root "assets\jagelka-profile-neutral.jpg"
$outPath = Join-Path $outDir "instagram-feed-warning.png"

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$width = 1080
$height = 1350
$margin = 72

function New-Font($family, $size, $style = [System.Drawing.FontStyle]::Regular) {
    return [System.Drawing.Font]::new($family, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
}

function Draw-WrappedText($graphics, $text, $font, $brush, $x, $y, $maxWidth, $lineHeight) {
    $words = $text -split "\s+"
    $line = ""
    foreach ($word in $words) {
        $candidate = if ($line.Length -eq 0) { $word } else { "$line $word" }
        $size = $graphics.MeasureString($candidate, $font)
        if ($size.Width -le $maxWidth -or $line.Length -eq 0) {
            $line = $candidate
        }
        else {
            $graphics.DrawString($line, $font, $brush, [single]$x, [single]$y)
            $y += $lineHeight
            $line = $word
        }
    }

    if ($line.Length -gt 0) {
        $graphics.DrawString($line, $font, $brush, [single]$x, [single]$y)
        $y += $lineHeight
    }

    return $y
}

function Fill-RoundedRectangle($graphics, $brush, $x, $y, $w, $h, $r) {
    if ($r -le 0) {
        $graphics.FillRectangle($brush, $x, $y, $w, $h)
        return
    }

    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $d = $r * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $graphics.FillPath($brush, $path)
    $path.Dispose()
}

function Draw-RoundedRectangle($graphics, $pen, $x, $y, $w, $h, $r) {
    if ($r -le 0) {
        $graphics.DrawRectangle($pen, $x, $y, $w, $h)
        return
    }

    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $d = $r * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $graphics.DrawPath($pen, $path)
    $path.Dispose()
}

$bmp = [System.Drawing.Bitmap]::new($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$paper = [System.Drawing.Color]::FromArgb(245, 247, 251)
$ink = [System.Drawing.Color]::FromArgb(21, 25, 31)
$muted = [System.Drawing.Color]::FromArgb(91, 102, 116)
$danger = [System.Drawing.Color]::FromArgb(177, 18, 27)
$dangerDark = [System.Drawing.Color]::FromArgb(125, 11, 18)
$black = [System.Drawing.Color]::FromArgb(13, 17, 23)
$line = [System.Drawing.Color]::FromArgb(215, 222, 232)
$white = [System.Drawing.Color]::White

$g.Clear($paper)

$brushBlack = [System.Drawing.SolidBrush]::new($black)
$brushDanger = [System.Drawing.SolidBrush]::new($danger)
$brushDangerDark = [System.Drawing.SolidBrush]::new($dangerDark)
$brushWhite = [System.Drawing.SolidBrush]::new($white)
$brushInk = [System.Drawing.SolidBrush]::new($ink)
$brushMuted = [System.Drawing.SolidBrush]::new($muted)
$brushSoft = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(254, 230, 232))
$brushPanel = [System.Drawing.SolidBrush]::new($white)
$penWhite = [System.Drawing.Pen]::new($white, 3)
$penLine = [System.Drawing.Pen]::new($line, 2)
$penDanger = [System.Drawing.Pen]::new($danger, 6)

$fontFamily = "Arial"
$kickerFont = New-Font $fontFamily 26 ([System.Drawing.FontStyle]::Bold)
$titleFont = New-Font $fontFamily 82 ([System.Drawing.FontStyle]::Bold)
$subtitleFont = New-Font $fontFamily 34 ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font $fontFamily 31 ([System.Drawing.FontStyle]::Regular)
$bodyBoldFont = New-Font $fontFamily 34 ([System.Drawing.FontStyle]::Bold)
$smallFont = New-Font $fontFamily 24 ([System.Drawing.FontStyle]::Regular)
$smallBoldFont = New-Font $fontFamily 25 ([System.Drawing.FontStyle]::Bold)
$urlFont = New-Font $fontFamily 42 ([System.Drawing.FontStyle]::Bold)

Fill-RoundedRectangle $g $brushBlack 0 0 $width 555 0
$g.FillRectangle($brushDanger, 0, 0, 18, $height)

Fill-RoundedRectangle $g ([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(32, 255, 255, 255))) $margin 58 395 48 24
$g.DrawString("VAROVÁNÍ PRO POŠKOZENÉ", $kickerFont, $brushWhite, [single]($margin + 22), [single]68)

$g.DrawString("FRANTIŠEK", $titleFont, $brushWhite, [single]$margin, [single]150)
$g.DrawString("JAGELKA", $titleFont, $brushWhite, [single]$margin, [single]236)

$headlineY = 350
$headlineY = Draw-WrappedText $g "Poškození a komunitní zdroje popisují falešné platby, lístky a zboží." $subtitleFont $brushWhite $margin $headlineY 620 42

if (Test-Path $assetPath) {
    $photo = [System.Drawing.Image]::FromFile($assetPath)
    $photoSize = 300
    $photoX = $width - $margin - $photoSize
    $photoY = 136
    Fill-RoundedRectangle $g $brushWhite ($photoX - 8) ($photoY - 8) ($photoSize + 16) ($photoSize + 58) 14

    $destRect = [System.Drawing.Rectangle]::new($photoX, $photoY, $photoSize, $photoSize)
    $g.DrawImage($photo, $destRect)
    $g.DrawString("neutralizovaný výřez", $smallFont, $brushMuted, [single]($photoX + 22), [single]($photoY + $photoSize + 13))
    $photo.Dispose()
}

$cardX = $margin
$cardY = 610
$cardW = $width - ($margin * 2)
$cardH = 300
Fill-RoundedRectangle $g $brushPanel $cardX $cardY $cardW $cardH 12
Draw-RoundedRectangle $g $penLine $cardX $cardY $cardW $cardH 12
$g.DrawLine($penDanger, $cardX, $cardY + 22, $cardX, $cardY + $cardH - 22)

$y = $cardY + 40
$g.DrawString("Screenshot platby není platba.", $bodyBoldFont, $brushDangerDark, [single]($cardX + 42), [single]$y)
$y += 58
$y = Draw-WrappedText $g "Bez skutečně připsané platby neposílej lístek, zboží ani osobní údaje." $bodyFont $brushInk ($cardX + 42) $y ($cardW - 84) 40
$y += 20
$y = Draw-WrappedText $g "Ulož chat, URL profilu, bankovní podklady a originální soubory. Řeš věc přes banku, platformu a policii." $bodyFont $brushMuted ($cardX + 42) $y ($cardW - 84) 39

$stepsY = 960
$stepW = 285
$stepGap = 24
$steps = @(
    @{N="1"; H="Zastav"; T="Neposílej další peníze ani doklady."},
    @{N="2"; H="Ověř"; T="Kontroluj skutečný příchozí pohyb v bance."},
    @{N="3"; H="Ulož"; T="Zachovej celé důkazy bez úprav."}
)

for ($i = 0; $i -lt $steps.Count; $i++) {
    $x = $margin + ($i * ($stepW + $stepGap))
    Fill-RoundedRectangle $g $brushPanel $x $stepsY $stepW 178 12
    Draw-RoundedRectangle $g $penLine $x $stepsY $stepW 178 12
    Fill-RoundedRectangle $g $brushDangerDark ($x + 22) ($stepsY + 24) 42 42 21
    $g.DrawString($steps[$i].N, $smallBoldFont, $brushWhite, [single]($x + 36), [single]($stepsY + 31))
    $g.DrawString($steps[$i].H, $bodyBoldFont, $brushInk, [single]($x + 76), [single]($stepsY + 22))
    Draw-WrappedText $g $steps[$i].T $smallFont $brushMuted ($x + 22) ($stepsY + 86) ($stepW - 44) 31 | Out-Null
}

Fill-RoundedRectangle $g $brushSoft $margin 1180 ($width - ($margin * 2)) 82 10
$g.DrawString("Zdroje, archiv a bezpečný postup:", $smallBoldFont, $brushDangerDark, [single]($margin + 28), [single]1199)
$g.DrawString("jagelka.cz", $urlFont, $brushDangerDark, [single]($width - $margin - 255), [single]1192)

$footerText = "Prevence, ne doxxing. Údaje ověřuj ve zdrojích. Poslední lokální aktualizace: 25.06.2026."
Draw-WrappedText $g $footerText $smallFont $brushMuted $margin 1288 ($width - ($margin * 2)) 30 | Out-Null

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
$brushBlack.Dispose()
$brushDanger.Dispose()
$brushDangerDark.Dispose()
$brushWhite.Dispose()
$brushInk.Dispose()
$brushMuted.Dispose()
$brushSoft.Dispose()
$brushPanel.Dispose()
$penWhite.Dispose()
$penLine.Dispose()
$penDanger.Dispose()

Write-Host $outPath
