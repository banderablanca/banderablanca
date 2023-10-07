import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({
    Key? key,
    required this.filePath,
  }) : super(key: key);

  final String filePath;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double _progress = 0;

  bool get isVideoUrl => widget.filePath.startsWith('http');

  @override
  void initState() {
    // Crear y almacenar el VideoPlayerController. El VideoPlayerController
    // ofrece distintos constructores diferentes para reproducir videos desde assets, archivos,
    // o internet.
    if (isVideoUrl) {
      _controller = VideoPlayerController.network(widget.filePath);
    } else {
      _controller = VideoPlayerController.file(File(widget.filePath));
    }
    // Inicializa el controlador y almacena el Future para utilizarlo luego
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      int dur = _controller.value.duration.inMilliseconds;
      int pos = _controller.value.position.inMilliseconds;
      setState(() {
        if (dur <= pos) {
          _progress = 0;
        } else {
          _progress = (dur - (dur - pos)) / dur;
        }
      });
    });

    // Usa el controlador para hacer un bucle en el vídeo
    _controller.setLooping(true);
    // _controller.play();

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de despachar el VideoPlayerController para liberar los recursos
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usa un FutureBuilder para visualizar un spinner de carga mientras espera a que
      // la inicialización de VideoPlayerController finalice.
      body: Container(
        color: Colors.black,
        child: Stack(children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Si el VideoPlayerController ha finalizado la inicialización, usa
                // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
                final double width = _controller.value.size.width;
                final double height = _controller.value.size.height;

                return SizedBox.expand(
                  child: FittedBox(
                    fit: width > height ? BoxFit.fitWidth : BoxFit.fitHeight,
                    // fit: BoxFit.fitHeight,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                );
              } else {
                // Si el VideoPlayerController todavía se está inicializando, muestra un
                // spinner de carga
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 2,
                ));
              }
            },
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegura
                // que se muestra el icono correcto
                setState(() {
                  // Si el vídeo se está reproduciendo, pausalo.
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // Si el vídeo está pausado, reprodúcelo
                    _controller.play();
                  }
                });
              },
              // Muestra el icono correcto dependiendo del estado del vídeo.
              child: Container(
                color: Colors.white.withOpacity(0),
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(
                        milliseconds: _controller.value.isPlaying ? 200 : 500),
                    opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                    child: Icon(
                      FontAwesomeIcons.play,
                      // _controller.value.isPlaying
                      //     ? Icons.pause
                      //     : Icons.play_arrow,
                      size: 46,
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // No muestra regresar desde la opcion

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                value: _progress,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
