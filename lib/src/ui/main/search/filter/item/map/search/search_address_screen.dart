// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:youdu/src/bloc/map/search_address_bloc.dart';
import 'package:youdu/src/constants/constants.dart';
import 'package:youdu/src/model/api/search_to_location_model.dart';

class SearchAddressScreen extends StatefulWidget {
  final Function(double _latitude, double _longitude, String _address) selected;

  const SearchAddressScreen({super.key, required this.selected});

  @override
  State<SearchAddressScreen> createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  final TextEditingController _controller = TextEditingController();
  String oldText = "";
  List<Feature> data = [];

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.length >= 3) {
        if (_controller.text != oldText) {
          searchAddressBloc.allAddressSearch(_controller.text);
          oldText = _controller.text;
        }
      } else {
        setState(() {
          data = [];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.greyF4,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    SvgPicture.asset(AppAssets.search),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: AppTypography.pSmallRegularDark,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: translate("search_hint"),
                          hintStyle: AppTypography.pSmallRegularGrey9A,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  translate("cancel"),
                  style: AppTypography.pTinyYellow16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<SearchToLocationModel>(
        stream: searchAddressBloc.getAddressSearch,
        builder: (context, snapshot) {
          if (snapshot.hasData || data.isNotEmpty) {
            if (snapshot.hasData) {
              data = snapshot.data!.features;
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.selected(
                      data[index].geometry.coordinates[1],
                      data[index].geometry.coordinates[0],
                      data[index].properties.name,
                    );
                    Navigator.pop(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index].properties.name,
                              style: AppTypography.pSmall3Dark00,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data[index].properties.geocoderMetaData.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.pTinyGreyADH11,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: AppColors.greyF4,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
