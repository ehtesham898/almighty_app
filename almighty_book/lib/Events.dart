import 'package:AlmightyBook/main.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  String id;
  Events({this.id});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<String> events = List<String>();
  fetchEvents() async {
    setState(() {
      events = [
        "Mass gathering for prayer",
        "Baptism session",
        "Carol singing practice",
        "Christmas arrivals",
        "Noble prayers",
        "Priest St.Lucas session"
      ];
    });
  }

  @override
  void initState() {
    fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.withOpacity(0.5),
        appBar: AppBar(
          title: Text("Events"),
        ),
        body:
    Column(
      children: [
        Container(
          decoration: BoxDecoration(
          //  gradient: LinearGradient(colors: [Colors.grey.withOpacity(0.8), Colors.amber, Colors.amberAccent])
          color: Colors.amber.withOpacity(0.6),
          ),
            padding: EdgeInsets.all(9),
          child:
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.notifications_active, color: Colors.white,),
              Text("Upcoming Events", style: TextStyle(color: Colors.white))
            ],
          )

        ),
        Expanded(
          child: Container(
            child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset("assets/images/calendar.jpg",width: 55, height: 55,),
                                  Text("02 Nov,\n2020", style: TextStyle(fontSize:11, fontWeight: FontWeight.bold,color: Colors.brown))
                                ],
                              ),

                              Column(
                                children: [
                                  Text(events[index],
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.amberAccent,
                                          fontWeight: FontWeight.bold)),
                                  Divider(color: Colors.white,),
                                  Row(
                                    children: [

                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                      ),
                                      Text("12:30 pm",
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text("- by Father Adam",
                                          style: TextStyle(
                                              fontSize: 11, color: Colors.white)),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white,),
                                  Text("Vatican City",
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ],
                              )

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                            Icon(Icons.people, color: Colors.white,),
                            Text("231 attending", style: TextStyle(fontSize:11, color: Colors.white)),
                            FlatButton(
                              color: Colors.amber.withOpacity(0.4),
                              onPressed: (){},
                              child: Text("Attend", style: TextStyle(fontSize:11, color: Colors.white)),
                            )
                          ],)
                        ],
                      )

                    ),


                  );
                }),
          ),
        ),
        Container(
            color: Colors.amber.withOpacity(0.6),
            padding: EdgeInsets.all(9),
            child:
            Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.notifications, color: Colors.white70,),
                Text("Past Events", style: TextStyle(color: Colors.white))
              ],
            )
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset("assets/images/calendar.jpg",width: 55, height: 55,),
                                Text("02 Nov,\n2020", style: TextStyle(fontSize:11, fontWeight: FontWeight.bold,color: Colors.brown))
                              ],
                            ),

                            Column(
                              children: [
                                Text(events[index],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.amberAccent,
                                        fontWeight: FontWeight.bold)),
                                Divider(color: Colors.white,),
                                Row(
                                  children: [

                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                    ),
                                    Text("12:30 pm",
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.white)),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("- by Father Adam",
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
Column(
  children: [
    Icon(Icons.location_on, color: Colors.white,),
    Text("Vatican City",
        style: TextStyle(
            fontSize: 11, color: Colors.white)),
  ],
)

                          ],
                        ),
                      ),


                  );
                }),
          ),
        ),
      ],
    )


    );
  }
}
