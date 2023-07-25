// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:youdu/src/constants/constants.dart';

class TwoPointMapWidget extends StatefulWidget {
  final List<double> list1;
  final List<double> list2;
  final List<String> name;

  const TwoPointMapWidget({
    super.key,
    required this.list1,
    required this.list2,
    required this.name,
  });

  @override
  State<TwoPointMapWidget> createState() => _TwoPointMapWidgetState();
}

class _TwoPointMapWidgetState extends State<TwoPointMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              bottom: 16,
            ),
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GoogleMap(
                compassEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(41.32094519677958, 69.2516476203812),
                  zoom: 5,
                ),
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _addMarker();
                },
              ),
            ),
          ),
          for (int i = 0; i < widget.list2.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    "assets/icons/loaction${i % 15 + 1}.svg",
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.name[i],
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamilyProxima,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.dark33,
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
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
