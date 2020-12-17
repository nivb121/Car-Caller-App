import 'dart:collection';
import 'package:contacts_service/contacts_service.dart';
import '../list_item_widgets/contact_list_item.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsWidgets{
  HashMap<String,Widget> nameToWidget;
  Function addElement;
  Iterable<Contact> _all;

  ContactsWidgets(Function addElement) {
    this.addElement = addElement;
    nameToWidget = new HashMap();
    this._all = null;
    buildMap();
  }
  
  void buildMap() async {
    await Permission.contacts.request();
    _all = await ContactsService.getContacts(withThumbnails: false);
    for(Contact c in _all)
      nameToWidget[c.displayName] = new ContactListItem(addElement: addElement, contact: c,);
  }

  List<Widget> filter(String query) {
    List<Widget> output = [];
    for(Contact c in _all)
      if(c.displayName.contains(query))
        output.add(nameToWidget[c.displayName]);
    return output;
  }

  Widget toWidget(String name) {
    return this.nameToWidget[name];
  }
}