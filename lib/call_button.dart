import 'package:car_caller/PhoneRecord.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallButton extends StatelessWidget {
  CallButton({Key key, @required this.contact, @required this.removeElement, @required this.index}) : super(key: key);
  final PhoneRecord contact;
  final int index;
  final removeElement;

  void _callNumber() async {
    bool res = await FlutterPhoneDirectCaller.callNumber(contact.number);
  }

  void _onClick() {
    try {
      _callNumber();
    } catch(Exception) {
      removeElement(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: new Icon(Icons.call), onPressed: _onClick,
      //   onPressed: () {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: new Text("מתקשר ל${contact.name}",textDirection: TextDirection.rtl,),
      //         content: new Text(contact.number,textDirection: TextDirection.rtl),
      //         actions: [FlatButton(onPressed: (){
      //           Navigator.of(context).pop();
      //           removeElement(index);
      //           }, child: new Text("OK",textDirection: TextDirection.rtl))],
      //         elevation: 24.0,
      //       );}
      // );
    color: Colors.green, iconSize: 37.0);
  }
}
