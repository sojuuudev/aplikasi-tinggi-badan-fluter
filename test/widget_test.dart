import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeightMeasureScreen(),
    );
  }
}

class HeightMeasureScreen extends StatefulWidget {
  const HeightMeasureScreen({Key? key}) : super(key: key);

  @override
  _HeightMeasureScreenState createState() => _HeightMeasureScreenState();
}

class _HeightMeasureScreenState extends State<HeightMeasureScreen> {
  double _height = 0.0;
  bool _isMeasuring = false;
  double? _initialZ;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() async {
    if (await Permission.sensors.request().isGranted) {
      // Permission granted, nothing to do
    } else {
      // Handle permission denied
    }
  }

  void _startMeasuring() {
    setState(() {
      _isMeasuring = true;
      _initialZ = null;
      _height = 0.0;
    });

    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (_initialZ == null) {
          _initialZ = event.z;
        } else {
          _height = ((_initialZ! - event.z) * 100).abs();
        }
      });
    });
  }

  void _stopMeasuring() {
    setState(() {
      _isMeasuring = false;
    });
    _streamSubscription?.cancel();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Height Measure App'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tinggi Badan',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  '${_height.toStringAsFixed(2)} Cm',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _isMeasuring
                    ? ElevatedButton(
                        onPressed: _stopMeasuring,
                        child: const Text('Stop'),
                      )
                    : ElevatedButton(
                        onPressed: _startMeasuring,
                        child: const Text('Start'),
                      ),
              ],
            ),
          ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              'by Sojuuu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
