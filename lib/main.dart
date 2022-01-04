import 'package:firebase_cloud/models/message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await  Firebase.initializeApp();
  runApp(MaterialApp(
      home:MessageScreen()));
}

class MessageScreen extends StatefulWidget{
  MessageScreenState createState()=> MessageScreenState();

}
class MessageScreenState extends State<MessageScreen>{
  final messageController = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.ref();
    bool isActiveButton = true;
  // late List<Message> message;
  //create data
  void initState(){
    super.initState();
    messageController.addListener(() {
      final isButtonActive = messageController.text.isNotEmpty;
      setState(() => this.isActiveButton = isButtonActive);
    });

  }
  void createData(Message message){
   
    dbRef.push().set(message.toJson());
  }
  // read data
  // void readData(Message message){
  //   dbRef.once().then((DataSnapshot snap){
  //     final json = snap.value as Map<dynamic,dynamic>;
  //     final message= Message.fromJson(json);
  //
  //   });
  //
  //
  //
  //
  // }
  // update data
  // void updateData(Message message){
  //   Map<String, dynamic> data = <String, dynamic>{
  //     "text": text,
  //     "date": DateTime.now(),
  //   };
  //   dbRef.update(data);
  // }
  // delete data
  // void deleteData(){
  //   dbRef.child("-Ms_0cdcEORJG_-0_nmp").remove();
  // }

  void dipose(){
    super.dispose();
    messageController.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     body: Column(
       mainAxisAlignment: MainAxisAlignment.end,
       crossAxisAlignment: CrossAxisAlignment.start,
       children:[
         FirebaseAnimatedList(
           shrinkWrap: true,
             scrollDirection: Axis.vertical,
             query: dbRef, itemBuilder: (context,snapshot,index,animation){
           final json=snapshot.value as Map<dynamic,dynamic>;
           final message = Message.fromJson(json);
           return Padding(padding: EdgeInsets.only(right: 60,bottom: 10,left: 10),
             child:Column(
               children:[
                 Container(
                   height:50,
                   child:  GestureDetector(
                     onLongPress: (){
                         dbRef.child(snapshot.key!).remove();
                     },
          child: Card(
             shadowColor: Colors.grey,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20)
             ),

            child: Align(
               alignment: Alignment.bottomLeft,
             child:Padding(padding: EdgeInsets.all(10),
             child:Text(message.text,style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic,),)
             ),),
             ),
          ),
                 ),
                 Text(message.date.toString()),
             ]
             )
           );

         }),

     Form(
       key: _formkey,
       child:
       Row(
         children: [
           Expanded(
       child:Align(
         alignment: Alignment.bottomCenter,
             child:TextFormField(
               validator: (value){
                 if(value!.isEmpty){
                   return "Please enter a message";
                 }
               },
               controller: messageController,
               decoration: InputDecoration(
                   contentPadding: EdgeInsets.all(8),
                 hintText: "Enter a new message"
               ),
             ),
           ),
           ),
         Align(
                 alignment: Alignment.bottomCenter,
              child:Padding(padding: EdgeInsets.only(left: 60),
              child: IconButton(onPressed:messageController.text.isEmpty ?null: isActiveButton ? ()  {
                if(_formkey.currentState!.validate()) {
                  createData(Message(text: messageController.text, date: DateTime.now()));
                  setState(() => isActiveButton = false);
                  messageController.clear();
                  return;
                }
           }: null,
                  icon: Icon(CupertinoIcons.arrow_right_circle,size: 30,))),
         ),
           IconButton(
               onPressed: () {
                 // deleteData();
           }, icon: Icon(CupertinoIcons.delete) )
         ],
       ),
     )
      ]
       )
    );

  }
}
