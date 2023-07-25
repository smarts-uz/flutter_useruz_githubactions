// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';

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
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/ui/main/search/filter/item/map/search/search_address_screen.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';

import '../../../../../../model/api/create/send_address_model.dart';
import '../../../../../../utils/utils.dart';

class ChooseAddressScreen extends StatefulWidget {
  final Function(SendAddressPoint data) selected;

  const ChooseAddressScreen({super.key, required this.selected});

  @override
  State<ChooseAddressScreen> createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  bool load = true;
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 120,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: Center(
              child: Text(
                translate("create_task.address_title"),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: MapPicker(
                      iconWidget: SvgPicture.asset(
                        AppAssets.locationIcon,
                        height: 60,
                      ),
                      mapPickerController: mapPickerController,
                      child: GoogleMap(
                        // ignore: prefer_collection_literals
                        gestureRecognizers: Set()
                          ..add(Factory<EagerGestureRecognizer>(
                              () => EagerGestureRecognizer())),
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        initialCameraPosition: cameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMoveStarted: () {
                          load = true;
                          setState(() {});
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
                              YandexGeocoder(apiKey: Utils.yandexApiKey);

                          final GeocodeResponse placemarks =
                              await geocoder.getGeocode(GeocodeRequest(
                            geocode: PointGeocode(
                              latitude: cameraPosition.target.latitude,
                              longitude: cameraPosition.target.longitude,
                            ),
                            lang: Lang.ru,
                          ));
                          textController.text =
                              '${placemarks.firstCountry!.addressLine},${placemarks.firstCountry!.countryName}';

                          load = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
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
                                LatLng _location = LatLng(
                                  _latitude,
                                  _longitude,
                                );
                                final GoogleMapController controller =
                                    await _controller.future;
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: _location,
                                      zoom: 14,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 56,
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    controller: textController,
                    style: AppTypography.pSemiBold,
                  ),
                ),
                Positioned(
                  bottom: Platform.isIOS ? 32 : 24,
                  left: 16,
                  right: 16,
                  child: AppCustomButton(
                    title: translate("create_task.address_choose"),
                    color: load ? AppColors.grey85 : AppColors.yellow16,
                    onTap: () {
                      if (!load) {
                        widget.selected(
                          SendAddressPoint(
                            longitude: cameraPosition.target.longitude,
                            latitude: cameraPosition.target.latitude,
                            location: textController.text,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: (Platform.isIOS ? 32 : 24) + 80,
                  child: GestureDetector(
                    onTap: () async {
                      if (await Permission.locationWhenInUse
                          .request()
                          .isGranted) {
                        Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );
                        LatLng _location =
                            LatLng(position.latitude, position.longitude);
                        final GoogleMapController controller =
                            await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _location,
                              zoom: 14,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.mapMeLocation),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: (Platform.isIOS ? 32 : 24) + 80,
                  child: GestureDetector(
                    onTap: () async {
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(CameraUpdate.zoomOut());
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.mapZoomOut),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: (Platform.isIOS ? 32 : 24) + 140,
                  child: GestureDetector(
                    onTap: () async {
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(CameraUpdate.zoomIn());
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(AppAssets.mapZoomIn),
                      ),
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
}
