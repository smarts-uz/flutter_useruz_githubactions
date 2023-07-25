class TaskListModel {
  String image;
  String type;
  String address;
  String time;
  int price;
  String click;
  String sale;
  bool isCard;
  bool active;
  List<double> location;

  TaskListModel({
    required this.image,
    required this.type,
    required this.address,
    required this.time,
    required this.price,
    required this.click,
    required this.sale,
    required this.isCard,
    required this.location,
    this.active = true,
  });
}
