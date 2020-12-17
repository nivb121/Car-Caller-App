import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  RemoveButton({Key key,this.index, this.removeElement}) : super(key: key);
  final int index;
  final removeElement;

  void _onClick() {
    removeElement(index);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: new Icon(Icons.delete), onPressed: (){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("בטוח שברצונך למחוק?",textDirection: TextDirection.rtl,),
              actions: [
                FlatButton(onPressed: (){
                  _onClick();
                  Navigator.of(context).pop();
                }, child: new Text("כן",textDirection: TextDirection.rtl)),
                FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("לא",textDirection: TextDirection.rtl))
              ],
              elevation: 24.0,
            );}
      );
    }, color: Colors.red, iconSize: 37.0,);
  }
}
