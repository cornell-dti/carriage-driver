import 'package:flutter/material.dart';


final arr = [1,2,3,4,5,6,7,8,9,10];

class Upcoming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: SizedBox(height: 5.0, width: 70.0,
                child: Container(color: Colors.grey)
            ),
          ),
          SizedBox(height: 10.0),
          Text('Upcoming Rides',
            style: Theme.of(context).textTheme.headline
          ),
          Flexible(
              child: ListView.builder(
                itemCount: arr.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${arr[index]}'),
                  );
                }
              ),
            )

            ],
          ),
    );
  }
}