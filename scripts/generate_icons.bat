@echo off

REM Create directories if they don't exist
mkdir android\app\src\main\res\mipmap-hdpi 2>nul
mkdir android\app\src\main\res\mipmap-mdpi 2>nul
mkdir android\app\src\main\res\mipmap-xhdpi 2>nul
mkdir android\app\src\main\res\mipmap-xxhdpi 2>nul
mkdir android\app\src\main\res\mipmap-xxxhdpi 2>nul

REM Generate icons for different densities using ImageMagick
magick convert assets\images\Spotly-logo.jpg -resize 72x72 android\app\src\main\res\mipmap-hdpi\ic_launcher.png
magick convert assets\images\Spotly-logo.jpg -resize 48x48 android\app\src\main\res\mipmap-mdpi\ic_launcher.png
magick convert assets\images\Spotly-logo.jpg -resize 96x96 android\app\src\main\res\mipmap-xhdpi\ic_launcher.png
magick convert assets\images\Spotly-logo.jpg -resize 144x144 android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png
magick convert assets\images\Spotly-logo.jpg -resize 192x192 android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png

REM Generate adaptive icons
for %%d in (hdpi mdpi xhdpi xxhdpi xxxhdpi) do (
    magick convert android\app\src\main\res\mipmap-%%d\ic_launcher.png ^
        -background "#6200EE" ^
        -gravity center ^
        -extent 108x108 ^
        android\app\src\main\res\mipmap-%%d\ic_launcher_foreground.png
)

echo App icons generated successfully! 