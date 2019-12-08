// import 'package:flutter/material.dart';

// import 'package:blood_collector/UI/connections/destination.dart';

// class ListPage extends StatelessWidget{
//   final Destination destination;
  
//   const ListPage({Key key, this.destination}):super(key:key);

//   @override
//   Widget build(BuildContext context) {
//     // const List<int> shades =<int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(destination.title),
       
//       ),
//       // body: SizedBox.expand(
//       //   child: ListView.builder(
//       //     // itemCount: shades.length,
//       //     itemBuilder: (BuildContext context, int index){
//       //       return SizedBox(
//       //         height: 128,
//       //         child: Card(
//       //           child: InkWell(
//       //             onTap: (){
//       //               Navigator.pushNamed(context, "/text");
//       //             },
//       //             child: Center(child: Text('Item $index', style:  Theme.of(context).primaryTextTheme.display1,),),
//       //           ),
//       //         ),
//       //       );
//       //     },
//       //   ),
//       // ),
//     );
//   }

// }

import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello"),
    );
  }
}