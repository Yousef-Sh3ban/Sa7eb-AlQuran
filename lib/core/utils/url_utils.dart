import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches an external HTTP/HTTPS link with basic validation and error toast.
Future<void> launchExternalUrl(BuildContext context, String url) async {
  if (!isValidHttpUrl(url)) return;
  final uri = Uri.parse(url);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعذّر فتح الرابط')),
    );
  }
}

/// Returns true when the string is a valid http/https URL.
bool isValidHttpUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}
