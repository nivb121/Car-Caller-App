import 'package:call_log/call_log.dart';
import '../data_types/PhoneRecord.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:date_format/date_format.dart';

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
  DateTime startDate;
  DateTime endDate;
  List<CallLogEntry> _allLogs;
  final addElement;

  @override
  void initState() {
    _allLogs = [];
    DateTime now = DateTime.now();
    endDate = new DateTime(now.year, now.month, now.day + 1);
    startDate = endDate.subtract(Duration(days: 7));
    getLogs();
    super.initState();
  }

  void getLogs() async {
    await Permission.phone.request();
    Iterable<CallLogEntry> _got = await CallLog.query(
        dateFrom: startDate.millisecondsSinceEpoch,
        dateTo: endDate.millisecondsSinceEpoch
    );
    _allLogs = [];
    setState(() {
      for(CallLogEntry l in _got) {
        _allLogs.add(l);
      }
    });
  }

  List<Widget> _buildList() {
      if(_allLogs.isEmpty)
        return [new Center(child: new Text("אין שיחות להציג", style: TextStyle(fontSize: 20.0,),),)];
      List<Widget> toView = [];
      for(CallLogEntry e in _allLogs)
        toView.add(CallLogItem(log: e, addElement: addElement));
      return toView;
  }

  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != startDate && picked.compareTo(endDate) <= 0) {
      setState(() {
        startDate = picked;
      });
      getLogs();
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),

    );
    if (picked != null && picked != endDate && startDate.compareTo(picked) <= 0) {
      setState(() {
        endDate = picked.add(Duration(days: 1));
      });
      getLogs();
    }
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
          new Container(
            color: Colors.blue,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new GestureDetector(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text("עד תאריך " + formatDate(endDate.subtract(Duration(days: 1)), [dd,'/',mm,]), textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 20.0, color: Colors.white),),
                      ],
                    ),
                    onTap: () => _selectEndDate(context),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new GestureDetector(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Text("מתאריך " + formatDate(startDate, [dd,'/',mm,]), textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      ],
                    ),
                    onTap: () => _selectStartDate(context),
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            child: new ListView(
              children: _buildList(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }
}

class CallLogItem extends StatelessWidget {
  final CallLogEntry log;
  final addElement;
  CallLogItem({@required this.log, @required this.addElement});

  @override
  Widget build(BuildContext context) {
    String name = (log.name == null || log.name =="") ? "לא מזוהה" : log.name;
    String number = log.number;
    Icon type = new Icon(Icons.not_interested);
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(log.timestamp);
    if (log.callType == CallType.missed) {type = new Icon(Icons.phone_missed, color: Colors.red,);}
    else if (log.callType == CallType.incoming) {type = new Icon(Icons.call_received, color: Colors.lightGreen);}
    else if (log.callType == CallType.outgoing) {type = new Icon(Icons.call_made, color: Colors.amber);}

    return new Card(
        child: new Container(
          padding: EdgeInsets.all(5.0),
          child: new GestureDetector(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text(formatDate(timestamp, [dd,'/',mm,' ',HH,':',nn]), textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 20.0,),),
                new Column(
                  children: [
                    new Text(name, textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20.0),),
                    new Text(number, textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20.0,),),
                  ],
                ),
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
}



