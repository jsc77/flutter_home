class ItemModel {
  String name;
  String img;
  String time;
  String profile;
  String room;
  ItemModel({this.name, this.img, this.time, this.profile, this.room});
  ItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
    time = json['time'];
    profile = json['profile'];
    room = json['room'];
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'img': img,
        'time': time,
        'room': room,
        'profile': profile
      };
}
