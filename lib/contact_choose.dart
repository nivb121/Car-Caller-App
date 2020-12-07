import 'package:car_caller/PhoneRecord.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactChoose extends StatefulWidget {
  ContactChoose({@required this.addElement,});
  final addElement;

  @override
  _ContactChooseState createState() => _ContactChooseState(
      addElement: addElement,
  );
}

class _ContactChooseState extends State<ContactChoose> {
  _ContactChooseState({@required this.addElement,});
  PhoneRecord toAdd;
  Contact chosen;
  List<Contact> _contacts;
  List<Contact> _filtered;
  final addElement;
  String search;

  @override
  void initState() {
    _contacts = [];
    _filtered = [];
    search = "";
    initContacts();
    super.initState();
  }

  void initContacts() async {
    await Permission.contacts.request();
    Iterable<Contact> _got = await ContactsService.getContacts();
    setState(() {
      for(Contact c in _got) {
        _contacts.add(c);
        _filtered.add(c);
      }
    });
  }

  Widget contactListItem(Contact contact) {
    return new Card(
      child: new Container(
        padding: EdgeInsets.all(5.0),
        child: new GestureDetector(
          child: new Text(contact.displayName, textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 24.0),),
          onTap: () {
            setState(() {
              chosen = contact;
            });
            List<Widget> numberOptions = [];
            for(Item item in contact.phones)
              numberOptions.add(phonenumberToDialogOption(item));
            showDialog(
                context: context,
                child: new SimpleDialog(
                  title: new Text("בחרו מספר טלפון מהרשימה", textAlign: TextAlign.center,),
                  children: numberOptions,
                )
            );
          },
        ),
      )
    );
  }

  Widget phonenumberToDialogOption(Item phoneItem) {
    return SimpleDialogOption(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text(phoneItem.label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, ),),
          new Text(phoneItem.value, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, ),),
        ],
      ),
      padding: new EdgeInsets.all(12.0),
      onPressed: () {
        PhoneRecord toAdd = new PhoneRecord(number: phoneItem.value, name: chosen.displayName);
        addElement(toAdd);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  List<Widget> _buildList() {
      if(_filtered.isEmpty)
        return [new Center(child: new Text("אין אנשי קשר", style: TextStyle(fontSize: 20.0,),),)];
      List<Widget> toView = [];
      for(Contact e in _filtered)
        toView.add(contactListItem(e));
      return toView;
  }

  void doSearch() {
    if(search == "")
      _filtered = _contacts;
    else {
      List<Contact> newFilt = [];
      for(Contact c in _filtered)
        if(c.displayName.contains(search))
          newFilt.add(c);
      _filtered = newFilt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("אנשי קשר"),
        centerTitle: true,
      ),
      body: new Flex(
        direction: Axis.vertical,
        children: [
          new TextField(
            onChanged: (str) {
              setState(() {
                search = str;
                doSearch();
              });
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "חיפוש",
            ),
          ),
          new ListView(
            children: _buildList(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}


