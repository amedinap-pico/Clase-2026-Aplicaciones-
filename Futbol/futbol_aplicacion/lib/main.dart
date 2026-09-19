import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Videos de fútbol',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const VideosPage(),
    );
  }
}

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late Future<List<Map<String, dynamic>>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = obtenerVideos();
  }

  // Consulta la API y devuelve los videos recibidos.
  Future<List<Map<String, dynamic>>> obtenerVideos() async {
    final respuesta = await http.get(
      Uri.parse('https://www.scorebat.com/video-api/v3/'),
    );

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los videos');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(datos['response'] as List);
  }

  Future<void> reproducirVideo(String id) async {
    final url = Uri.parse('https://www.scorebat.com/embed/v/$id/');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir el video');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos de fútbol')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final videos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video['title'] as String? ?? 'Sin título'),
                subtitle: Text(video['date'] as String? ?? 'Sin fecha'),
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    final videosDelPartido = video['videos'] as List? ?? [];
                    if (videosDelPartido.isNotEmpty) {
                      final primerVideo = videosDelPartido.first;
                      reproducirVideo(primerVideo['id'] as String);
                    }
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Reproducir'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
