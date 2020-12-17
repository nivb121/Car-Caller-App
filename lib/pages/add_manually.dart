import '../data_types/PhoneRecord.dart';
import 'package:flutter/material.dart';

class AddManuallyButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(onPressed: () {
    }, icon: new Icon(Icons.dialpad), label: new Text("ידני"), );
  }
}



class AddManuallyForm extends StatefulWidget {
  AddManuallyForm({@required this.addElement});
  final addElement;

  @override
  _AddManuallyFormState createState() => _AddManuallyFormState(addElement: addElement);
}

class _AddManuallyFormState extends State<AddManuallyForm> {
  _AddManuallyFormState({@required this.addElement});
  String _name = "מתקשר מסתורי";
  String _number = "000-0000000";
  final addElement;

  void submitForm() {
    if(_name == "מתקשר מסתורי")
      setState(() {_name = _number;});
    PhoneRecord record = new PhoneRecord(number: _number, name: _name);
    addElement(record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: Text("הוספת מספר ידנית", textDirection: TextDirection.rtl,),
      children: <Widget>[
        Container(
          padding: new EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "שם",
            ),
            textDirection: TextDirection.rtl,
            onChanged: (value) {setState(() {
              _name = value=="" ? "מתקשר מסתורי" : value;
            });},
          )
        ),
        Container(
          padding: new EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "טלפון",
            ),
            textDirection: TextDirection.rtl,
            onChanged: (value) {setState(() {
              _number = value=="" ? "000-0000000" : value;
            });},
          )
        ),
        Container(
          padding: new EdgeInsets.symmetric(horizontal: 45.0),
          child: RaisedButton(onPressed: submitForm, child: Text("אישור", textDirection: TextDirection.rtl,style: TextStyle(color: Colors.white),),
          color: Colors.blue,),
        )
      ],
    );
  }
}
