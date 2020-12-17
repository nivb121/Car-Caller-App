import './data_types/PhoneRecord.dart';
import 'pages/add_manually.dart';
import 'package:flutter/material.dart';
import 'buttons/call_button.dart';
import 'pages/call_log_picker.dart';
import 'buttons/remove_button.dart';
import 'pages/contact_choose.dart';
import './data_types/contacts_widgets.dart';



void main() async {
  runApp(new MaterialApp(
    home: Directionality(
      child: HomePage(),
      textDirection: TextDirection.rtl,
    ),
    darkTheme: ThemeData.dark(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<PhoneRecord> elements = [];
  List<BottomNavigationBarItem> navBar = [
    BottomNavigationBarItem(icon: Icon(Icons.list), label: "רשימה",backgroundColor: Colors.blueAccent,),
    BottomNavigationBarItem(icon: Icon(Icons.add_call), label: "יומן שיחות", backgroundColor: Colors.blueAccent,),
    BottomNavigationBarItem(icon: Icon(Icons.contact_phone), label: "אנשי קשר", backgroundColor: Colors.blueAccent,),
    BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: "ידני", backgroundColor: Colors.blueAccent,),
  ];
  ContactsWidgets nameToWidget;

  @override
  void initState() {
    List<PhoneRecord> elements = [];
    nameToWidget = new ContactsWidgets(_addElement);
    super.initState();
  }

  void _navTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {}
    else if (index == 1) {
      _callLogClick();
    }
    else if(index == 2) {
      _contactsClick();
    }
    else if (index == 3) {
      showDialog(
          context: context,
          builder: (context) => AddManuallyForm(addElement: _addElement)
      );
    }
  }

  void _callLogClick () {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new CallLogPicker(addElement: _addElement)
        )
    );
  }

  void _contactsClick () {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) =>
              new ContactChoose(
                addElement: _addElement,
                nameToWidget: nameToWidget,
              )
        )
    );
  }

  void _removeElement(int index){
    setState(() {
      this.elements.removeAt(index);
    });
  }

  void _addElement(PhoneRecord contact) {
    setState(() {
      elements.add(contact);
    });
  }

  Widget contactToTile(PhoneRecord contact, int index) {
    return new Card(
      child: new ListTile(
        title: new Text(contact.name, style: TextStyle(fontSize: 21.0),),
        // subtitle: new Text(contact.number),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CallButton(contact: contact, removeElement: _removeElement, index: index),
            RemoveButton(index: index, removeElement: _removeElement,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Car Caller"),
        centerTitle: true,
      ),
      body: new Container(
        padding: new EdgeInsets.all(15.0),
        child: elements.isEmpty ?
        Center(child: Text("אין שיחות ברשימה", style: TextStyle(fontSize: 20.0,),),) :
        ListView.builder(
            itemCount: elements.length,
            itemBuilder: (BuildContext context, int index) {
              return contactToTile(elements[index], index);
        },),
      ),
      // drawer: new Container(
      //     color: Colors.white,
      //     padding: new EdgeInsets.all(32.0),
      //     child: new Column(
      //         children: <Widget>[
      //           IconButton(icon: new Icon(Icons.nights_stay), onPressed: () {
      //             print("clicked!");
      //           }),
      //         ]
      //     )
      // ),
      bottomNavigationBar: new BottomNavigationBar(
        items: navBar,
        onTap: _navTap,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}