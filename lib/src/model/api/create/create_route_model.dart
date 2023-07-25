class CreateRouteModel {
  CreateRouteModel({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  CreateRouteData data;
  String message;

  factory CreateRouteModel.fromJson(Map<String, dynamic> json) =>
      CreateRouteModel(
        success: json["success"] ?? false,
        data: json["data"] == null
            ? CreateRouteData.fromJson({})
            : CreateRouteData.fromJson(json["data"]),
        message: json["message"] ?? "",
      );
}

class CreateRouteData {
  CreateRouteData({
    required this.route,
    required this.taskId,
    required this.steps,
    required this.address,
    required this.price,
    required this.customFields,
  });

  String route;
  int taskId;
  int steps;
  int address;
  int price;
  List<CreateRouteCustomField> customFields;

  factory CreateRouteData.fromJson(Map<String, dynamic> json) =>
      CreateRouteData(
        route: json["route"] ?? "",
        taskId: json["task_id"] ?? 0,
        address: json["address"] ?? 0,
        price: json["price"] ?? 0,
        steps: json["steps"] ?? 0,
        customFields: json["custom_fields"] == null
            ? <CreateRouteCustomField>[]
            : List<CreateRouteCustomField>.from(json["custom_fields"]
                .map((x) => CreateRouteCustomField.fromJson(x))),
      );
}

class CreateRouteCustomField {
  CreateRouteCustomField({
    required this.description,
    required this.placeholder,
    required this.title,
    required this.label,
    required this.type,
    required this.order,
    required this.name,
    required this.taskValue,
    required this.options,
    required this.userValue,
    required this.dataType,
    required this.errorMessage,
    required this.required,
    required this.validator,
    required this.regax,
    required this.min,
    required this.max,
  });

  String description;
  String placeholder;
  String title;
  String label;
  String type;
  String dataType;
  String regax;
  int min;
  int max;
  int order;
  int required;
  String name;
  String taskValue;
  String userValue;
  String errorMessage;
  String validator;
  List<CustomFieldType> options;

  factory CreateRouteCustomField.fromJson(Map<String, dynamic> json) =>
      CreateRouteCustomField(
        description: json["description"] ?? "",
        placeholder: json["placeholder"] ?? "",
        title: json["title"] ?? "",
        label: json["label"] ?? "",
        dataType: json["data_type"] ?? "",
        type: json["type"] ?? "",
        errorMessage: json["error_message"] ?? "",
        order: json["order"] ?? 0,
        regax: json["regax"] ?? "",
        min: json["min"] ?? -1,
        max: json["max"] ?? -1,
        required: json["required"] ?? 0,
        name: json["name"] ?? "",
        taskValue: json["task_value"] ?? "",
        userValue: json["task_value"] ?? "",
        options: json["options"] == null
            ? <CustomFieldType>[]
            : List<CustomFieldType>.from(
                json["options"].map(
                  (x) => CustomFieldType.fromJson(x),
                ),
              ),
        validator: json["validator"] ?? "",
      );
}

class CustomFieldType {
  int id;
  bool selected;
  String value;

  CustomFieldType({
    required this.id,
    required this.selected,
    required this.value,
  });

  factory CustomFieldType.fromJson(Map<String, dynamic> json) =>
      CustomFieldType(
        id: json["id"] ?? "",
        selected: json["selected"] ?? false,
        value: json["value"] ?? "",
      );
}
