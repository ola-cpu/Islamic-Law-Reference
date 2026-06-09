import 'package:flutter/material.dart';
import '../models/media_item.dart';
import 'builtin_illustration.dart';

class MediaContent extends StatelessWidget {
  final MediaItem media;
  final BoxFit fit;
  final double? height;

  const MediaContent({
    super.key,
    required this.media,
    this.fit = BoxFit.cover,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (BuiltinIllustration.isBuiltin(media.url)) {
      return BuiltinIllustration(
        widgetId: BuiltinIllustration.idFromUrl(media.url),
        height: height ?? 160,
      );
    }
    if (media.url.startsWith('assets/')) {
      return Image.asset(
        media.url,
        fit: fit,
        height: height,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(context),
      );
    }
    return Image.network(
      media.url,
      fit: fit,
      height: height,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => _errorPlaceholder(context),
    );
  }

  Widget _errorPlaceholder(BuildContext context) {
    return Container(
      height: height ?? 160,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.broken_image, size: 48)),
    );
  }
}
