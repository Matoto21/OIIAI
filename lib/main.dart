import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imagen con Audio y Fondo',
      debugShowCheckedModeBanner: false,
      home: const ImagenAudioFondoDemo(),
    );
  }
}

class ImagenAudioFondoDemo extends StatefulWidget {
  const ImagenAudioFondoDemo({super.key});

  @override
  State<ImagenAudioFondoDemo> createState() => _ImagenAudioFondoDemoState();
}

class _ImagenAudioFondoDemoState extends State<ImagenAudioFondoDemo> {
  bool mostrarImagenA = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Fondo animado
  Color _backgroundColor = Colors.white;
  Timer? _backgroundTimer;
  int _colorIndex = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];

  // Delay controlado
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setSource(AssetSource("OIIAOIIA.mp3"));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _backgroundTimer?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.resume();
    setState(() => _isPlaying = true);
  }

  Future<void> _stopAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    }
  }

  void _startBackgroundAnimation() {
    _backgroundTimer?.cancel();
    _backgroundTimer = Timer.periodic(const Duration(milliseconds: 150), (
      timer,
    ) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colors.length;
        _backgroundColor = _colors[_colorIndex];
      });
    });
  }

  void _stopBackgroundAnimation() {
    _backgroundTimer?.cancel();
    setState(() => _backgroundColor = Colors.white);
  }

  void _resetAll() {
    setState(() => mostrarImagenA = true);
    _stopAudio();
    _stopBackgroundAnimation();
    _delayTimer?.cancel(); // cancelar delay pendiente
    _delayTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TRABAJO DE TÍTULO")),
      backgroundColor: _backgroundColor,
      body: Center(
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => mostrarImagenA = false);
            _playAudio();

            // Reiniciar delay siempre que se presiona
            _delayTimer?.cancel();
            _delayTimer = Timer(const Duration(milliseconds: 3139), () {
              if (!mostrarImagenA) _startBackgroundAnimation();
            });
          },
          onTapUp: (_) => _resetAll(),
          onLongPressEnd: (_) => _resetAll(),
          child:
              mostrarImagenA
                  ? Image.asset(
                    'assets/cat.png',
                    fit: BoxFit.cover,
                    width: 226,
                    height: 296,
                  )
                  : Image.asset(
                    'assets/oia-uia-ezgif.com-cut.gif',
                    fit: BoxFit.cover,
                    width: 300, // 👈 tamaño distinto
                    height: 300, // 👈 tamaño distinto
                  ),
        ),
      ),
    );
  }
}
