import 'package:call_log/call_log.dart';
import 'package:car_caller/PhoneRecord.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class CallLogPicker extends StatefulWidget {
  CallLogPicker({@required this.addElement,});
  final addElement;

  @override
  _CallLogPickerState createState() => _CallLogPickerState(
      addElement: addElement,
  );
}

class _CallLogPickerState extends State<CallLogPicker> {
  _CallLogPickerState({@required this.addElement,});
  List<CallLogEntry> _allLogs;
  final addElement;

  @override
  void initState() {
    _allLogs = [];
    initLogs();
    super.initState();
  }

  void initLogs() async {
    await Permission.phone.request();
    Iterable<CallLogEntry> _got = await CallLog.get();
    setState(() {
      for(CallLogEntry l in _got) {
        _allLogs.add(l);
      }
    });
  }

  Widget logListItem(CallLogEntry log) {
    String name = (log.name == null || log.name =="") ? "לא מזוהה" : log.name;
    String number = log.number;
    Icon type = new Icon(Icons.not_interested);
    if (log.callType == CallType.missed) {type = new Icon(Icons.phone_missed, color: Colors.red,);}
    else if (log.callType == CallType.incoming) {type = new Icon(Icons.call_received, color: Colors.lightGreen);}
    else if (log.callType == CallType.outgoing) {type = new Icon(Icons.call_made, color: Colors.amber);}

    return new Card(
      child: new Container(
        padding: EdgeInsets.all(5.0),
        child: new GestureDetector(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Text(number, textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 24.0,),),
              new Text(name, textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 24.0),),
              type,
            ],
          ),
          onTap: () {
            if(name == "לא מזוהה")
              name = number;
            addElement(new PhoneRecord(name: name, number: number));
            Navigator.pop(context);
          },
        ),
      )
    );
  }

  List<Widget> _buildList() {
      if(_allLogs.isEmpty)
        return [new Center(child: new Text("אין שיחות להציג", style: TextStyle(fontSize: 20.0,),),)];
      List<Widget> toView = [];
      for(CallLogEntry e in _allLogs)
        toView.add(logListItem(e));
      return toView;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("יומן שיחות"),
        centerTitle: true,
      ),
      body: new Flex(
        direction: Axis.vertical,
        children: [
          new ListView(
            children: _buildList(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}


