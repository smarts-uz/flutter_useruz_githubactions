// ignore_for_file: sort_child_properties_last, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/total_model.dart';
import 'package:youdu/src/ui/main/search/filter/item/map/search/search_address_screen.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/button/yellow_button.dart';
import 'package:youdu/src/widget/circle_thumb_shape.dart';
import 'package:youdu/src/widget/search/filter/filter_item_widget.dart';

class MapFilterScreen extends StatefulWidget {
  final TaskFilterModel filterData;
  final double value;
  final String address;
  final double latitude;
  final double longitude;
  final Function(
    double _latitude,
    double _longitude,
    String address,
    double value,
  ) change;

  const MapFilterScreen({
    super.key,
    required this.value,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.change,
    required this.filterData,
  });

  @override
  State<MapFilterScreen> createState() => _MapFilterScreenState();
}

class _MapFilterScreenState extends State<MapFilterScreen> {
  double value = 150;
  double zoom = 9.0;
  bool loading = false;

  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  LatLng _location = const LatLng(41.311081, 69.240562);
  String address = "";

  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 8.6,
  );

  var textController = TextEditingController();

  Set<Circle> circles = {};

  @override
  void initState() {
    _updateZoom(widget.value);
    _location = LatLng(widget.latitude, widget.longitude);
    setState(() {
      address = widget.address;
    });
    _getCircles(widget.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.passthrough,
                        children: [
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height - 220,
                              width: MediaQuery.of(context).size.width,
                              child: MapPicker(
                                iconWidget: Image.asset(
                                  AppAssets.locationMap,
                                  height: 60,
                                ),
                                mapPickerController: mapPickerController,
                                child: GoogleMap(
                                  // ignore: prefer_collection_literals
                                  gestureRecognizers: Set()
                                    ..add(Factory<EagerGestureRecognizer>(
                                        () => EagerGestureRecognizer())),
                                  circles: circles,
                                  myLocationEnabled: true,
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  mapType: MapType.normal,
                                  initialCameraPosition: cameraPosition,
                                  zoomGesturesEnabled: false,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  onCameraMoveStarted: () {
                                    mapPickerController.mapMoving!();
                                    textController.text =
                                        translate("create_task.checking");
                                  },
                                  onCameraMove: (cameraPosition) {
                                    this.cameraPosition = cameraPosition;
                                  },

                                  onCameraIdle: () async {
                                    mapPickerController.mapFinishedMoving!();
                                    final YandexGeocoder geocoder =
                                        YandexGeocoder(
                                            apiKey: Utils.yandexApiKey);

                                    final GeocodeResponse placemarks =
                                        await geocoder
                                            .getGeocode(GeocodeRequest(
                                      geocode: PointGeocode(
                                        latitude:
                                            cameraPosition.target.latitude,
                                        longitude:
                                            cameraPosition.target.longitude,
                                      ),
                                      lang: Lang.enEn,
                                    ));

                                    _location = cameraPosition.target;
                                    _getCircles(value);
                                    address =
                                        '${placemarks.firstCountry!.addressLine},${placemarks.firstCountry!.countryName}';

                                    updateCount();
                                  },
                                ),
                              ),
                            ),
                          ),
                          value == 150
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF005A91)
                                          .withOpacity(0.2),
                                      border: Border.all(
                                        width: 3,
                                        color: const Color(0xFF005A91),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      height: 237,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          FilterItemWidget(
                            color: Colors.transparent,
                            icon: AppAssets.addressLocation,
                            title: translate("filter.location"),
                            message: address,
                            arrow: false,
                            onTap: () {},
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.only(left: 56),
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xFFEFEDE9),
                          ),
                          Container(
                            color: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.gps,
                                  height: 24,
                                  width: 24,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          "${translate("filter.search")} ${value.toInt() > 146 ? "∞" : value.toInt()} ${translate("km")}",
                                          style: AppTypography.pTinyGreyAD,
                                        ),
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          bottom: 4,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor:
                                                AppColors.yellow16,
                                            inactiveTrackColor:
                                                const Color(0xFFFAF8F5),
                                            thumbColor: AppColors.yellow16,
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                              overlayRadius: 2,
                                            ),
                                            thumbShape: const CircleThumbShape(
                                              thumbRadius: 10,
                                            ),
                                          ),
                                          child: Slider(
                                            max: 150,
                                            min: 1.5,
                                            divisions: null,
                                            value: value,
                                            onChanged: (newValue) {
                                              _getCircles(newValue);

                                              _updateZoom(value);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          StreamBuilder<TaskCount>(
                            stream: taskBloc.getTaskCount,
                            builder: (context, snapshot) {
                              int countResult = 0;
                              String text = translate("filter.result");
                              bool _loading = false;
                              if (snapshot.hasData) {
                                _loading = false;
                                countResult = snapshot.data!.total;
                                if (countResult != 0) {
                                  text += " ${snapshot.data!.total}";
                                } else {
                                  _loading = true;
                                }
                              }
                              return YellowButton(
                                text: text,
                                // loading: _loading,
                                onTap: () {
                                  widget.change(
                                    _location.latitude,
                                    _location.longitude,
                                    address,
                                    value,
                                  );
                                  Navigator.pop(context);
                                },
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 24),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 44, left: 16, right: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: SvgPicture.asset(AppAssets.back),
                          ),
                        ),
                        onTap: () {
                          taskBloc.getFilterCount(widget.filterData, context);
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.search,
                              color: AppColors.dark33,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchAddressScreen(
                                  selected: (
                                    double _latitude,
                                    double _longitude,
                                    String _address,
                                  ) async {
                                    address = _address;
                                    value = 50;
                                    _location = LatLng(_latitude, _longitude);
                                    final GoogleMapController controller =
                                        await _controller.future;
                                    controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: _location,
                                          zoom: 8,
                                        ),
                                      ),
                                    );
                                    widget.change(
                                      _location.latitude,
                                      _location.longitude,
                                      address,
                                      value,
                                    );
                                    setState(() {
                                      _getCircles(value);
                                    });
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () async {
                      loading = true;
                      setState(() {});
                      if (await Permission.locationWhenInUse
                          .request()
                          .isGranted) {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);

                        _location =
                            LatLng(position.latitude, position.longitude);
                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _location,
                              zoom: zoom,
                            ),
                          ),
                        );
                        cameraPosition = cameraPosition;

                        mapPickerController.mapFinishedMoving!();
                        final YandexGeocoder geocoder =
                            YandexGeocoder(apiKey: Utils.yandexApiKey);

                        final GeocodeResponse placemarks =
                            await geocoder.getGeocode(GeocodeRequest(
                          geocode: PointGeocode(
                            latitude: cameraPosition.target.latitude,
                            longitude: cameraPosition.target.longitude,
                          ),
                          lang: Lang.ru,
                        ));

                        address =
                            '${placemarks.firstCountry!.addressLine},${placemarks.firstCountry!.countryName}';

                        _location = cameraPosition.target;

                        _getCircles(value);

                        widget.change(
                          _location.latitude,
                          _location.longitude,
                          address,
                          value,
                        );
                      }
                      loading = false;
                      setState(() {});
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.gpsMe),
                      ),
                    ),
                  ),
                  right: 16,
                  bottom: 252,
                ),
                !loading
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.dark00.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 56,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator.adaptive(
                                    backgroundColor: AppColors.dark00,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    translate("loading"),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getCircles(double _value) async {
    value = _value;

    circles = {
      Circle(
        visible: false,
        circleId: const CircleId("myCircle"),
        radius: value > 146 ? 100000000 : value * 1000,
        center: _location,
        fillColor: Colors.transparent,
        strokeColor: Colors.transparent,
        // fillColor: const Color(0xFF005A91).withOpacity(0.3),
        // strokeColor: const Color(0xFF005A91),
        strokeWidth: 0,
      )
    };

    ///marker
    BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      AppAssets.filterMarker,
    );

    MarkerId markerId = const MarkerId(
      "custom_marker_0",
    );
    Marker marker = Marker(
      markerId: markerId,
      icon: markerImage,
      position: _location,
    );
    _markers[markerId] = marker;
    setState(() {});
  }

  _updateZoom(double h) async {
    h = h.toInt().toDouble();
    if (h == 1) {
      zoom = 14;
    } else if (h >= 4 && h < 10) {
      zoom = 11.4;
    } else if (h <= 11) {
      zoom = 11;
    } else if (h <= 16) {
      zoom = 10.6;
    } else if (h <= 21) {
      zoom = 10.2;
    } else if (h <= 26) {
      zoom = 9.8;
    } else if (h <= 31) {
      zoom = 9.4;
    } else if (h <= 36) {
      zoom = 9.2;
    } else if (h <= 41) {
      zoom = 9;
    } else if (h <= 46) {
      zoom = 8.8;
    } else if (h <= 51) {
      zoom = 8.6;
    } else if (h <= 56) {
      zoom = 8.4;
    } else if (h <= 61) {
      zoom = 8.2;
    } else if (h <= 66) {
      zoom = 8.0;
    } else if (h <= 71) {
      zoom = 7.8;
    } else if (h <= 76) {
      zoom = 7.6;
    } else if (h <= 81) {
      zoom = 7.4;
    } else if (h <= 86) {
      zoom = 7.2;
    } else if (h <= 91) {
      zoom = 7.0;
    } else if (h <= 96) {
      zoom = 6.8;
    } else if (h <= 101) {
      zoom = 6.6;
    } else if (h <= 106) {
      zoom = 6.4;
    } else if (h <= 111) {
      zoom = 6.2;
    } else if (h <= 116) {
      zoom = 6.0;
    } else if (h <= 121) {
      zoom = 5.8;
    } else if (h <= 126) {
      zoom = 5.6;
    } else if (h <= 131) {
      zoom = 5.4;
    } else if (h <= 136) {
      zoom = 5.2;
    } else if (h <= 141) {
      zoom = 5.0;
    } else if (h <= 146) {
      zoom = 4.8;
    } else if (h.toInt() > 146) {
      zoom = 1;
    } else {
      zoom = (h / 0.4) / 12;
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _location,
          zoom: zoom,
        ),
      ),
    );
  }

  updateCount() async {
    loading = true;
    setState(() {});
    taskBloc
        .getFilterCount(
            TaskFilterModel(
              category: widget.filterData.category,
              latitude: _location.latitude,
              longitude: _location.longitude,
              budget: widget.filterData.budget,
              distance: value,
              remote: widget.filterData.remote,
              work: widget.filterData.work,
              response: widget.filterData.response,
              address: address,
            ),
            context)
        .then((_) {
      setState(() {
        loading = false;
      });
    });
  }
}
