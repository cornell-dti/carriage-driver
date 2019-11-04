import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Direction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 600),
      child: Container(
        height: 30,
        width: 30,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Icon(Icons.arrow_upward, size: 100),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('600 Feet', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40
                  )),
                  Text('Tower Road',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    color: Colors.blueGrey
                  ))
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

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
          // Map will go here!
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover)),
          child: Direction()
        ),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/terry.jpg'),
              radius: 30,
            ),
            SizedBox(height: 80.0),
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
