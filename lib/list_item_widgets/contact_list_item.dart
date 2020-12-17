import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import '../data_types/PhoneRecord.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final Function addElement;
  ContactListItem({@required this.contact, @required this.addElement});

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new Container(
          padding: EdgeInsets.all(5.0),
          child: new GestureDetector(
            child: new Text(contact.displayName, textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 24.0),),
            onTap: () {
              List<Widget> numberOptions = [];
              for(Item item in contact.phones.toSet())
                numberOptions.add(
                    PhoneNumberDialog(
                      phoneItem: item, name: contact.displayName, addElement: addElement,
                ));
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
}

class PhoneNumberDialog extends StatelessWidget {
  final Item phoneItem;
  final String name;
  final Function addElement;
  PhoneNumberDialog({@required this.phoneItem, @required this.name ,@required this.addElement});

  @override
  Widget build(BuildContext context) {
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
        PhoneRecord toAdd = new PhoneRecord(number: phoneItem.value, name: name);
        addElement(toAdd);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}
