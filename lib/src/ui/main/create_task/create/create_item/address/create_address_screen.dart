// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youdu/src/bloc/create/create_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/create/create_route_model.dart';
import 'package:youdu/src/model/api/create/send_address_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/create_task/create/create_item/address/choose_address_screen.dart';
import 'package:youdu/src/utils/rx_bus.dart';
import 'package:youdu/src/utils/utils.dart';
import 'package:youdu/src/widget/app/app_custom_button.dart';
import 'package:youdu/src/widget/dialog/center_dialog.dart';

import '../../../../../../model/api_model/tasks/product_model.dart';

class CreateAddressScreen extends StatefulWidget {
  final int taskId;
  final Function(String route) nextPage;
  final TaskModel? taskModel;

  const CreateAddressScreen({
    super.key,
    required this.taskId,
    required this.nextPage,
    required this.taskModel,
  });

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen>
    with AutomaticKeepAliveClientMixin<CreateAddressScreen> {
  @override
  bool get wantKeepAlive => true;
  int addressCount = 0;
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  List<SendAddressPoint> locations = [];
  SendAddressPoint? locationA, locationB;
  bool loading = false, isNext = false;
  int select = 0;

  @override
  void initState() {
    _initBus();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate("create_task.address_title"),
                  style: AppTypography.h2SmallSemiBold,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return ChooseAddressScreen(
                          selected: (SendAddressPoint _data) {
                            locationA = _data;
                            _addMarker(_data, "map_a_location", lok: 1);
                            _update();
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 64,
                    child: Row(
                      children: [
                        SvgPicture.asset(AppAssets.createAddressA),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                translate("create_task.address_add_label"),
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.pTinyGreyAD,
                              ),
                              locationA != null
                                  ? Text(
                                      locationA!.location,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.pTiny215,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        locationA != null
                            ? GestureDetector(
                                onTap: () {
                                  locationA = null;
                                  --select;
                                  _markers = <MarkerId, Marker>{};
                                  if (locationB != null) {
                                    _addMarker(locationB!, "map_b_location",
                                        lok: 2);
                                  }
                                  for (int i = 0; i < locations.length; i++) {
                                    _addMarker(locations[i],
                                        "map_location" + i.toString(),
                                        lok: addressCount + i + 1);
                                  }
                                  _update();
                                },
                                child: SvgPicture.asset(
                                  AppAssets.createClearAddress,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                Container(height: 1, color: AppColors.greyE9),
                addressCount >= 2
                    ? GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return ChooseAddressScreen(
                                selected: (SendAddressPoint _data) {
                                  locationB = _data;
                                  _addMarker(_data, "map_b_location", lok: 2);
                                  _update();
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 64,
                          child: Row(
                            children: [
                              SvgPicture.asset(AppAssets.createAddressB),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      translate(
                                          "create_task.address_add_label1"),
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.pTinyGreyAD,
                                    ),
                                    locationB != null
                                        ? Text(
                                            locationB!.location,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.pTiny215,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              locationB != null
                                  ? GestureDetector(
                                      onTap: () {
                                        locationB = null;
                                        --select;
                                        _markers = <MarkerId, Marker>{};
                                        if (locationA != null) {
                                          _addMarker(
                                              locationA!, "map_a_location",
                                              lok: 1);
                                        }
                                        for (int i = 0;
                                            i < locations.length;
                                            i++) {
                                          _addMarker(locations[i],
                                              "map_location" + i.toString(),
                                              lok: addressCount + i + 1);
                                        }
                                        _update();
                                      },
                                      child: SvgPicture.asset(
                                        AppAssets.createClearAddress,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      )
                    : Container(),
                addressCount >= 2
                    ? Container(height: 1, color: AppColors.greyE9)
                    : Container(),
                if (locations.isNotEmpty)
                  for (int i = 1; i <= locations.length; i++)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) {
                                return ChooseAddressScreen(
                                  selected: (SendAddressPoint _data) {
                                    _addMarker(locations[i],
                                        "map_location" + i.toString(),
                                        lok: addressCount + i + 1);
                                    _update();
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 64,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/loaction${i + addressCount}.svg"),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate(
                                                "create_task.address_add_label1") +
                                            " ${locations.length}",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.pTinyGreyAD,
                                      ),
                                      i - 1 < 0
                                          ? Container()
                                          : Text(
                                              locations[i - 1].location,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTypography.pTiny215,
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    locations.removeAt(i - 1);
                                    _markers = <MarkerId, Marker>{};
                                    if (locationB != null) {
                                      _addMarker(locationB!, "map_b_location",
                                          lok: 2);
                                    }
                                    if (locationA != null) {
                                      _addMarker(locationA!, "map_a_location",
                                          lok: 1);
                                    }
                                    for (int i = 0; i < locations.length; i++) {
                                      _addMarker(locations[i],
                                          "map_location" + i.toString(),
                                          lok: addressCount + i + 1);
                                    }
                                    _update();
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.createClearAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 1, color: AppColors.greyE9)
                      ],
                    ),
                locations.length > 12
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return ChooseAddressScreen(
                                selected: (SendAddressPoint _data) {
                                  _addMarker(
                                    _data,
                                    "map_location" +
                                        locations.length.toString(),
                                    lok: locations.length + addressCount + 1,
                                  );
                                  locations.add(_data);
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 48,
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.createFileAdd,
                                color: AppColors.yellow16,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Text(
                                  translate("create_task.address_label"),
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.pTiny215,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 550,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(41.311081, 69.240562),
                    zoom: 11,
                  ),
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _updateData();
                  },
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
                              zoom: 16,
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
      floatingActionButton: AppCustomButton(
        loading: loading,
        color: isNext ? AppColors.yellow16 : AppColors.greyD6,
        title: translate("next"),
        margin: EdgeInsets.only(
          left: 32,
          bottom: Platform.isIOS ? 32 : 24,
        ),
        onTap: () async {
          if (isNext) {
            setState(() {
              loading = true;
            });
            List<SendAddressPoint> dataLocation = [
              locationA!,
            ];
            dataLocation.addAll(locations);
            if (locationB != null) {
              dataLocation.add(locationB!);
            }
            SendAddressModel data = SendAddressModel(
              taskId: widget.taskId,
              points: dataLocation,
            );
            HttpResult response = await createBloc.createAddress(
              data,
              widget.taskModel,
            );
            if (response.isSuccess) {
              CreateRouteModel data =
                  CreateRouteModel.fromJson(response.result);
              if (data.success) {
                widget.nextPage(data.data.route);
              } else {
                CenterDialog.errorDialog(
                  context,
                  Utils.serverErrorText(response),
                  response.result.toString(),
                );
              }
            } else if (response.status == -1) {
              CenterDialog.networkErrorDialog(context);
            } else {
              CenterDialog.errorDialog(
                context,
                Utils.serverErrorText(response),
                response.result.toString(),
              );
            }
            setState(() {
              loading = false;
            });
          }
        },
      ),
    );
  }

  _update() {
    if ((addressCount == 1 && locationA != null) ||
        (addressCount >= 2 && locationA != null && locationB != null)) {
      setState(() {
        isNext = true;
      });
    } else {
      setState(() {
        isNext = false;
      });
    }
  }

  _addMarker(
    SendAddressPoint data,
    String key, {
    int lok = 0,
  }) async {
    BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(
        context, 'assets/icons/loaction$lok.svg');

    MarkerId markerId = MarkerId(key);
    Marker marker = Marker(
      markerId: markerId,
      icon: bitmapDescriptor,
      position: LatLng(
        data.latitude,
        data.longitude,
      ),
    );
    _markers[markerId] = marker;
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

  void _updateData() {
    if (widget.taskModel != null) {
      isNext = true;
      int count = 0;
      if (widget.taskModel!.address.isNotEmpty) {
        ++count;
        locationA = SendAddressPoint(
          location: widget.taskModel!.address.first.location,
          latitude: widget.taskModel!.address.first.latitude,
          longitude: widget.taskModel!.address.first.longitude,
        );
        _addMarker(locationA!, "map_a_location", lok: 1);
      }
      if (widget.taskModel!.address.length > 1) {
        ++count;
        locationB = SendAddressPoint(
          location: widget.taskModel!.address[1].location,
          latitude: widget.taskModel!.address[1].latitude,
          longitude: widget.taskModel!.address[1].longitude,
        );
        _addMarker(locationB!, "map_b_location", lok: 2);
      }
      for (int i = count; i < widget.taskModel!.address.length; i++) {
        locations.add(
          SendAddressPoint(
            location: widget.taskModel!.address[i].location,
            latitude: widget.taskModel!.address[i].latitude,
            longitude: widget.taskModel!.address[i].longitude,
          ),
        );
        _addMarker(
            SendAddressPoint(
              location: widget.taskModel!.address[i].location,
              latitude: widget.taskModel!.address[i].latitude,
              longitude: widget.taskModel!.address[i].longitude,
            ),
            "map_location${i + 1}",
            lok: i + 1);
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "CREATE_ADDRESS");
    super.dispose();
  }

  void _initBus() {
    RxBus.register<int>(tag: "CREATE_ADDRESS").listen((event) {
      if (mounted) {
        setState(() {
          addressCount = event;
        });
      }
    });
  }
}
