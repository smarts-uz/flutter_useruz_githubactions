class SearchToLocationModel {
  SearchToLocationModel({
    required this.features,
  });

  List<Feature> features;

  factory SearchToLocationModel.fromJson(Map<String, dynamic> json) =>
      SearchToLocationModel(
        features: json["features"] == null
            ? <Feature>[]
            : List<Feature>.from(
                json["features"].map((x) => Feature.fromJson(x))),
      );
}

class Feature {
  Feature({
    required this.geometry,
    required this.properties,
  });

  Geometry geometry;
  Properties properties;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        geometry: json["geometry"] == null
            ? Geometry.fromJson({})
            : Geometry.fromJson(json["geometry"]),
        properties: json["properties"] == null
            ? Properties.fromJson({})
            : Properties.fromJson(json["properties"]),
      );
}

class Geometry {
  Geometry({
    required this.coordinates,
  });

  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null
            ? [0.0, 0.0]
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );
}

class Properties {
  Properties({
    required this.name,
    required this.description,
    required this.geocoderMetaData,
  });

  String name;
  String description;
  GeocoderMetaData geocoderMetaData;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        geocoderMetaData: json["GeocoderMetaData"] == null
            ? GeocoderMetaData.fromJson({})
            : GeocoderMetaData.fromJson(json["GeocoderMetaData"]),
      );
}

class GeocoderMetaData {
  GeocoderMetaData({
    required this.text,
  });

  String text;

  factory GeocoderMetaData.fromJson(Map<String, dynamic> json) =>
      GeocoderMetaData(
        text: json["text"] ?? "",
      );
}
