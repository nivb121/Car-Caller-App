import 'package:flutter/material.dart';
import '../data_types/contacts_widgets.dart';

class ContactChoose extends StatefulWidget {
  ContactChoose({@required this.addElement, @required this.nameToWidget});
  final Function addElement;
  final ContactsWidgets nameToWidget;

  @override
  _ContactChooseState createState() => _ContactChooseState(
    addElement: addElement,
    nameToWidget: nameToWidget,
  );
}

class _ContactChooseState extends State<ContactChoose> {
  _ContactChooseState({@required this.addElement, @required this.nameToWidget});
  final Function addElement;
  final ContactsWidgets nameToWidget;

  List<Widget> _toShow;
  String search;

  @override
  void initState() {
    search = "";
    _toShow = [];
    showAll();
    super.initState();
  }

  void showAll() {
    setState(() {
      _toShow = nameToWidget.filter("");
    });
  }

  void doSearch(str) {
    setState(() {
      search = str;
      _toShow = nameToWidget.filter(search);
    });
  }

  // void showAll() async {
  //   List<Widget> all = await nameToWidget.filter("");
  //   setState(() {
  //     _toShow = all;
  //   });
  // }
  //
  // void doSearch() async {
  //   if(search == "")
  //     showAll();
  //   else {
  //     List<Widget> filtered = await nameToWidget.filter(search);
  //     setState(() {
  //       _toShow = filtered;
  //     });
  //   }
  // }

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
            onChanged: (str) {doSearch(str);},
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "חיפוש",
            ),
          ),
          new Expanded(
              child: new ListView(
                children: _toShow,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
              ),
          )
        ],
      ),
    );
  }
}