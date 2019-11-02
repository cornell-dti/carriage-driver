import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Map extends StatelessWidget {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 200.0,
        maxHeight: 300.0,
        isDraggable: false,
        borderRadius: radius,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover)),
        ),
        panel: Column(
          children: <Widget>[
            Center(
                child:
                    Text('Terry Cruz', style: TextStyle(color: Colors.black))),
            RaisedButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Arrived'),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            )
          ],
        ),
      ),
    );
  }
}
