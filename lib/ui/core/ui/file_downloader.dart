import 'dart:io';
import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/utils/result.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Web only import
import 'package:universal_html/html.dart' as html;

class CrossPlatformDownloader extends StatefulWidget {
  const CrossPlatformDownloader({
    super.key,
    required this.endpoint,
    required this.apiService,
    required this.fileName,
  });

  final String endpoint;
  final String fileName;
  final ApiService apiService;

  @override
  State<CrossPlatformDownloader> createState() =>
      _CrossPlatformDownloaderState();
}

class _CrossPlatformDownloaderState extends State<CrossPlatformDownloader> {
  String status = "";

  Future<void> _downloadFile() async {
    if (kIsWeb) {
      try {
        final response = await widget.apiService.get(widget.endpoint);

        final blob = html.Blob([response.bodyBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..download = widget.fileName
          ..click();
        html.Url.revokeObjectUrl(url);

        setState(() => status = "Download started in browser!");
      } catch (e) {
        setState(() => _showSnackBar(context, "Error (Web): $e"));
      }
      return;
    }

    try {
      String dirPath;

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop: save to ~/Downloads
        final home =
            Platform.environment['HOME'] ??
            Platform.environment['UserProfile']!;
        dirPath = "$home/Downloads";
      } else if (Platform.isAndroid) {
        final downloadsDir = Directory("/storage/emulated/0/Download");
        dirPath = downloadsDir.path;
      } else if (Platform.isIOS) {
        final docsDir = await getApplicationDocumentsDirectory();
        dirPath = docsDir.path;
      } else {
        final docsDir = await getApplicationDocumentsDirectory();
        dirPath = docsDir.path;
      }

      final savePath = "$dirPath/${widget.fileName}";

      var res = await widget.apiService.downloadEndpoint(
        widget.endpoint,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(
              () => status =
                  "Downloading: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );
      switch (res) {
        case Ok<void>():
          setState(() => _showSnackBar(context, "File saved at: $savePath"));
        case Error<void>():
          setState(() => _showSnackBar(context, "Error: ${res.error}"));
      }
    } catch (e) {
      setState(() => _showSnackBar(context, "Error: $e"));
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    if (context.mounted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: _downloadFile,
    );
  }
}
