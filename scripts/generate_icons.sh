#!/bin/bash

# Create directories if they don't exist
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

# Generate icons for different densities
convert assets/images/Spotly-logo.jpg -resize 72x72 android/app/src/main/res/mipmap-hdpi/ic_launcher.png
convert assets/images/Spotly-logo.jpg -resize 48x48 android/app/src/main/res/mipmap-mdpi/ic_launcher.png
convert assets/images/Spotly-logo.jpg -resize 96x96 android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
convert assets/images/Spotly-logo.jpg -resize 144x144 android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
convert assets/images/Spotly-logo.jpg -resize 192x192 android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

# Generate adaptive icons
for density in hdpi mdpi xhdpi xxhdpi xxxhdpi; do
  convert android/app/src/main/res/mipmap-$density/ic_launcher.png \
    -background "#6200EE" \
    -gravity center \
    -extent 108x108 \
    android/app/src/main/res/mipmap-$density/ic_launcher_foreground.png
done

echo "App icons generated successfully!" 