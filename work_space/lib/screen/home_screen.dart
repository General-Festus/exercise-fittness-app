import 'package:flutter/material.dart';
import 'package:work_space/screen/exercise_hub.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work_space/exercise_start_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
 
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String apiURL = 'https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json';

  ExerciseHub execiseHub;

  @override
  void initState() {
    
    getExercises();

    super.initState();
  }

  void getExercises() async{
    var response = await http.get(apiURL);
    var body = response.body;
    var decodedJson = jsonDecode(body);
    
     execiseHub = ExerciseHub.fromJson(decodedJson);
     setState(() {
       
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness App'),
        centerTitle: true,
      ),
      body: Container(
        child: execiseHub != null
         ? ListView(
          children: execiseHub.exercises.map((e) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ExerciseStartScreen(exercises: e,),),);
              },
              child: Hero(
                tag: e.id,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        //child: FadeInImage(
                         // image: NetworkImage(e.thumbnail),
                         // placeholder: AssetImage('assets/placeholder.jpg'),
                         // width: MediaQuery.of(context).size.width,
                         // height: 250,
                         // fit:  BoxFit.cover,
                       //),
                        child: CachedNetworkImage(
                          imageUrl: e.thumbnail,
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/placeholder.jpg'),
                            fit: BoxFit.cover,
                            height: 250,
                            width:  MediaQuery.of(context).size.width,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 250,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff000000),
                                Color(0x00000000),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ) 
        : LinearProgressIndicator(),
      ),
    );
  }
}