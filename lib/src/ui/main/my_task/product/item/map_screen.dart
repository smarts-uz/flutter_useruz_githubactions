// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenWidget extends StatefulWidget {
  final List<double> list1;
  final List<double> list2;
  final List<String> name;

  const MapScreenWidget({
    super.key,
    required this.list1,
    required this.list2,
    required this.name,
  });

  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          compassEnabled: true,
          mapToolbarEnabled: true,
          myLocationButtonEnabled: false,
          tiltGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.list1[0], widget.list2[0]),
            zoom: 10,
          ),
          markers: Set<Marker>.of(_markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _addMarker();
          },
        ),
      ),
    );
  }

  _addMarker() async {
    for (int i = 0; i < widget.list1.length; i++) {
      BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(
          context, 'assets/icons/loaction${i + 1}.svg');
      MarkerId markerIdOne = MarkerId(widget.name[i]);
      Marker markerOne = Marker(
        markerId: markerIdOne,
        icon: bitmapDescriptor,
        position: LatLng(widget.list1[i], widget.list2[i]),
      );
      _markers[markerIdOne] = markerOne;
    }
    setState(() {});
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");

    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 32 * devicePixelRatio;
    double height = 32 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    ui.Image image = await picture.toImage(100, 100);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
