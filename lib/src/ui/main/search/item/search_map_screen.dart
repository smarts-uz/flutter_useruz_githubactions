// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youdu/src/api/repository.dart';
import 'package:youdu/src/bloc/task/tasks_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/dialog/task_bottom_dialog.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';
import 'package:youdu/src/model/api_model/tasks/task_filter_model.dart';
import 'package:youdu/src/model/api_model/tasks/tasks_model.dart';
import 'package:youdu/src/model/http_result.dart';
import 'package:youdu/src/ui/main/search/filter/item/map/map_filter_screen.dart';
import 'package:youdu/src/ui/main/search/item/helpers/map_helper.dart';
import 'package:youdu/src/ui/main/search/item/helpers/map_markers.dart';
import 'package:youdu/src/utils/rx_bus.dart';

class SearchMapScreen extends StatefulWidget {
  final TaskFilterModel filterData;
  final Function(TaskFilterModel _data) selected;

  const SearchMapScreen({
    super.key,
    required this.filterData,
    required this.selected,
  });

  @override
  State<SearchMapScreen> createState() => _SearchMapScreenState();
}

class _SearchMapScreenState extends State<SearchMapScreen>
    with AutomaticKeepAliveClientMixin<SearchMapScreen> {
  @override
  bool get wantKeepAlive => true;

  String text = "";
  double zoom = 12.0;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  bool isLoading = false;
  int page = 1;
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  Fluster<MapMarker>? _clusterManager;
  double _currentZoom = 14;
  double value = 1;
  double _distance = 150;
  int budget = 0;
  final List<CategoryModel> _category = [];
  String address = "";
  double latitude = 41, longitude = 69;
  bool remote = false, response = false, work = false;
  bool loading = false;

  late TaskFilterModel filterData;
  Set<Circle> circles = {};

  void _sendData() {
    taskBloc.getFilterCount(
      TaskFilterModel(
        response: response,
        budget: budget,
        remote: remote,
        address: address,
        category: _category,
        longitude: longitude,
        work: work,
        latitude: latitude,
        distance: _distance,
      ),
      context,
    );
    widget.selected(
      TaskFilterModel(
        response: response,
        budget: budget,
        remote: remote,
        address: address,
        category: _category,
        longitude: longitude,
        work: work,
        latitude: latitude,
        distance: _distance,
      ),
    );
  }

  @override
  void initState() {
    filterData = widget.filterData;
    // _locationPermission();
    _getCircles(filterData.distance);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMoreData(page, filterData);
    });
    _initBus();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onCameraMove: (position) {
                _updateMarkers(position.zoom);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(filterData.latitude, filterData.longitude),
                zoom: _currentZoom,
              ),
              circles: circles,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 80,
          child: GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MapFilterScreen(
                      filterData: widget.filterData,
                      value: filterData.distance,
                      address: filterData.address,
                      longitude: filterData.longitude,
                      latitude: filterData.latitude,
                      change: (
                        double _latitude,
                        double _longitude,
                        String _address,
                        double value,
                      ) {
                        setState(() {
                          _distance = value;
                          longitude = _longitude;
                          latitude = _latitude;
                          address = _address;
                          _sendData();
                        });
                      },
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.white,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.location3,
                  color: AppColors.grey9A,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 140,
          child: GestureDetector(
            onTap: () async {
              _locationPermission();
            },
            child: Container(
              height: 48,
              width: 48,
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
          left: 16,
          bottom: 50,
          child: GestureDetector(
            onTap: () async {
              final GoogleMapController controller = await _controller.future;
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
          left: 16,
          bottom: 100,
          child: GestureDetector(
            onTap: () async {
              final GoogleMapController controller = await _controller.future;
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
    );
  }

  _getCircles(double _value) async {
    value = _value;
    _updateZoom(value);
    circles = {
      Circle(
        circleId: const CircleId("myCircle"),
        radius: value == 150
            ? 100000000
            : value < 70
                ? value * 1000
                : value < 100
                    ? value * 1500
                    : value < 120
                        ? value * 2500
                        : value < 140
                            ? value * 3000
                            : value < 150
                                ? value * 4000
                                : 100000000,
        center: LatLng(filterData.latitude, filterData.longitude),
        fillColor: const Color(0xFF005A91).withOpacity(0.3),
        strokeColor: const Color(0xFF005A91),
        strokeWidth: 2,
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
      position: LatLng(filterData.latitude, filterData.longitude),
    );
    _markers.add(marker);
    if (mounted) {
      setState(() {});
    }
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
    } else if (h <= 149) {
      zoom = 4.6;
    } else if (h.toInt() == 150) {
      zoom = 1;
    } else {
      zoom = (h / 0.4) / 12;
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(filterData.latitude, filterData.longitude),
          zoom: zoom,
        ),
      ),
    );
  }

  void _initBus() {
    RxBus.register<String>(tag: "SEARCH_TASK_EVENT").listen((event) {
      page = 1;
      isLoading = false;
      text = event;
      _getMoreData(page, filterData);
    });

    RxBus.register<TaskFilterModel>(tag: "SEARCH_TASK_FILTER").listen(
      (event) {
        page = 1;
        isLoading = false;
        filterData = event;
        _getCircles(filterData.distance);
        _getMoreData(page, event);
      },
    );
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "SEARCH_TASK_EVENT");
    RxBus.destroy(tag: "SEARCH_TASK_FILTER");
    super.dispose();
  }

  void _getMoreData(int index, TaskFilterModel filter) async {
    if (!isLoading) {
      TasksModel taskModel = TasksModel.fromJson({});
      String category = "[";
      for (int i = 0; i < filter.category.length; i++) {
        for (int j = 0; j < filter.category[i].chooseItem.length; j++) {
          category += filter.category[i].chooseItem[j].id.toString() + ",";
        }
      }
      if (category != "[") {
        category = category.substring(0, category.length - 1);
        category += "]";
      } else {
        category = "";
      }
      HttpResult response = await Repository().getTask(
        lat: filter.latitude.toString(),
        long: filter.longitude.toString(),
        difference: (filter.distance.toInt()).toString(),
        withoutResponse: filter.response ? "1" : "",
        isRemote: filter.remote ? "1" : "",
        search: text,
        budget: filter.budget == 0 ? "" : filter.budget.toString(),
        category: '',
        categoryChild: filter.category.isEmpty ? "" : category,
        page: page,
      );
      if (response.isSuccess) {
        if (page == 1) {
          _markers = {};
          markers = [];
        }
        taskModel = TasksModel.fromJson(
          response.result,
        );
        _addMarker(taskModel.data);

        page++;
        taskModel.lastPage == page - 1 ? isLoading = true : isLoading = false;
        if (!isLoading) {
          _getMoreData(page, filterData);
        }
      }
    }
  }

  List<MapMarker> markers = [];

  _addMarker(List<TaskModelResult> data) async {
    BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      AppAssets.marker1,
    );
    for (int i = 0; i < data.length; i++) {
      data[i].addresses.isEmpty
          ? null
          : markers.add(
              MapMarker(
                id: data[i].id.toString(),
                position: LatLng(
                  data[i].addresses.first.latitude,
                  data[i].addresses.first.longitude,
                ),
                icon: markerImage,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return TaskBottomDialog(
                        data: data[i],
                      );
                    },
                  );
                },
                // icon: await MapHelper.getClusterMarker(
                //   AppColors.blueE6,
                //   const Color(0xFFFFFFFF),
                //   72,
                // ),
              ),
            );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
      (LatLng _location) async {
        final GoogleMapController controller = await _controller.future;
        double k = await controller.getZoomLevel();
        k += 2;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _location,
              zoom: k,
            ),
          ),
        );
      },
    );

    await _updateMarkers();
  }

  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      AppColors.blueE6,
      const Color(0xFFFFFFFF),
      96,
    );

    if (mounted) {
      setState(() {
        _markers
          ..clear()
          ..addAll(updatedMarkers);
      });
    }
  }

  Future<void> _locationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      Position v = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      BitmapDescriptor markerImage = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(24, 24)),
        AppAssets.locationMap,
      );

      MarkerId markerId = const MarkerId(
        "my_location_1",
      );
      Marker marker = Marker(
        markerId: markerId,
        icon: markerImage,
        position: LatLng(v.latitude, v.longitude),
      );
      _markers.add(marker);
      setState(() {});

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              v.latitude,
              v.longitude,
            ),
            zoom: 14,
          ),
        ),
      );
    }
  }
}
