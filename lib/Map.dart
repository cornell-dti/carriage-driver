import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Direction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
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
      body: Stack(
        children: <Widget>[
          Container(
            // Map will go here!
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.cover)),
          ),
          Container(
            child: Direction(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 140),
                    child: ButtonTheme(
                      minWidth: 150,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text('Arrived'),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 160, // height of sheet - radius
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/terry.jpg'),
                radius: 40,
              ),
            ),
          )
        ],
      )
    );
  }
}

