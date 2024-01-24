// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'src/multiview.dart';


final List<Color> colors = List.from(Colors.primaries)..shuffle();
final List<LatLng> positions = List.from(<LatLng>[
  LatLng(47.608013, -122.335167),
  LatLng(37.386051, -122.083855),
  LatLng(32.779167, -96.808891),
  LatLng(42.331429, -83.045753),
  LatLng(40.714998, -74.009400),
  LatLng(43.36029, -5.84476),
  LatLng(40.416775, -3.703790),
  LatLng(51.509865, -0.118092),
  LatLng(48.864716, 2.349014),
  LatLng(52.520008, 13.404954),
  LatLng(-33.865143, 151.209900),
])..shuffle();

void main() {
  runAppWithoutImplicitView(MultiViewApp(
    viewBuilder: (BuildContext context) => const Counter(),
  ));
}

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    return MaterialApp(
      title: 'Multi-counter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors[viewId%colors.length]),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Map View $viewId', initialCoordinates: positions[viewId%positions.length]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.initialCoordinates });

  final LatLng initialCoordinates;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng? _currentCoordinates;
  late GoogleMapController _map;

  @override
  void initState() {
    super.initState();
    _currentCoordinates = widget.initialCoordinates;
  }

  void _resetCenter() {
    _map.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: widget.initialCoordinates, zoom: 11),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _map = controller;
  }

  void _onCameraMove(CameraPosition position) async {
    setState(() {
      _currentCoordinates = position.target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onCameraMove: _onCameraMove,
                initialCameraPosition: CameraPosition(
                  target: widget.initialCoordinates,
                  zoom: 11,
                ),
              ),
            ),
            Text('Lat: ${_currentCoordinates?.latitude.toStringAsFixed(6)}, Lon: ${_currentCoordinates?.longitude.toStringAsFixed(6)}'),
          ],
        ),
      ),
      floatingActionButton: PointerInterceptor(
        child: FloatingActionButton.small(
          onPressed: _resetCenter,
          tooltip: 'Re-center',
          child: const Icon(Icons.center_focus_strong_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
