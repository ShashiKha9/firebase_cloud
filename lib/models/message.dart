class Message{
  final String text;
  final DateTime date;

  Message({
    required this.text,
    required this.date,
});
  Message.fromJson(Map<dynamic,dynamic> json):
        date= DateTime.parse(json["date"] as String),
        text=json["text"] as String;

  Map<dynamic,dynamic> toJson()=>{
    "date" : date.toString(),
    "text" : text,
  };

}
