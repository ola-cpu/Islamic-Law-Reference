import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../services/database_helper.dart';

class MediaGalleryScreen extends StatefulWidget {
  const MediaGalleryScreen({super.key});

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen> {
  late Future<List<MediaItem>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = DatabaseHelper().getAllMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliothèque Média"),
      ),
      body: FutureBuilder<List<MediaItem>>(
        future: _mediaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun média trouvé."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final media = snapshot.data![index];
              return _buildMediaCard(context, media);
            },
          );
        },
      ),
    );
  }

  Widget _buildMediaCard(BuildContext context, MediaItem media) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showMediaDetails(context, media),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (media.type == MediaType.image || media.type == MediaType.infographic)
                    Image.network(media.url, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 50))
                  else
                    Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(_getMediaIcon(media.type), size: 48, color: Theme.of(context).colorScheme.primary),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(_getMediaIcon(media.type), size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title ?? "Sans titre",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (media.description != null)
                    Text(
                      media.description!,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMediaIcon(MediaType type) {
    switch (type) {
      case MediaType.image: return Icons.image;
      case MediaType.audio: return Icons.audiotrack;
      case MediaType.video: return Icons.videocam;
      case MediaType.infographic: return Icons.assessment;
    }
  }

  void _showMediaDetails(BuildContext context, MediaItem media) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (media.type == MediaType.image || media.type == MediaType.infographic)
              Image.network(media.url, fit: BoxFit.contain)
            else
              Container(
                height: 200,
                color: Colors.black,
                child: const Center(child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(media.title ?? "Sans titre", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  if (media.description != null) Text(media.description!),
                ],
              ),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer")),
          ],
        ),
      ),
    );
  }
}
