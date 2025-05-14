// Download font files for Spotly app
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Future<void> main() async {
  // Create fonts directory
  final fontDir = Directory('assets/fonts');
  if (!await fontDir.exists()) {
    await fontDir.create(recursive: true);
  }

  // Download Sora font
  await downloadFont(
    'Sora',
    [
      {'weight': 400, 'file': 'Sora-Regular.ttf'},
      {'weight': 500, 'file': 'Sora-Medium.ttf'},
      {'weight': 600, 'file': 'Sora-SemiBold.ttf'},
      {'weight': 700, 'file': 'Sora-Bold.ttf'},
    ],
  );

  // Download Inter font
  await downloadFont(
    'Inter',
    [
      {'weight': 400, 'file': 'Inter-Regular.ttf'},
      {'weight': 500, 'file': 'Inter-Medium.ttf'},
      {'weight': 600, 'file': 'Inter-SemiBold.ttf'},
      {'weight': 700, 'file': 'Inter-Bold.ttf'},
    ],
  );

  print('Fonts downloaded successfully!');
}

Future<void> downloadFont(
    String fontFamily, List<Map<String, dynamic>> variants) async {
  print('Downloading $fontFamily font...');

  // Get Google Fonts API data
  final apiKey =
      'AIzaSyBfabYA2IsFVi19P-HzY-dZVO8ZlRi6aMM'; // Public Google Fonts API key
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/webfonts/v1/webfonts?key=$apiKey'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final fonts = data['items'] as List;

    // Find the font family
    final font = fonts.firstWhere(
      (font) => font['family'] == fontFamily,
      orElse: () => null,
    );

    if (font == null) {
      print('Font $fontFamily not found in Google Fonts!');
      return;
    }

    // Download each variant
    for (final variant in variants) {
      final weight = variant['weight'];
      final fileName = variant['file'];
      final outputPath = path.join('assets/fonts', fileName);

      // Get the download URL
      String? downloadUrl;
      if (font['files'] != null) {
        // Try to find the exact weight
        final weightStr = weight == 400 ? 'regular' : weight.toString();
        if (font['files'][weightStr] != null) {
          downloadUrl = font['files'][weightStr];
        }
      }

      if (downloadUrl == null) {
        print('Weight $weight not found for $fontFamily, skipping...');
        continue;
      }

      // Download the font file
      print('Downloading $fileName...');
      final fontResponse = await http.get(Uri.parse(downloadUrl));
      if (fontResponse.statusCode == 200) {
        final file = File(outputPath);
        await file.writeAsBytes(fontResponse.bodyBytes);
        print('Downloaded $fileName successfully!');
      } else {
        print('Failed to download $fileName: ${fontResponse.statusCode}');
      }
    }
  } else {
    print('Failed to get Google Fonts data: ${response.statusCode}');
  }
}
