//Abdelrahman Essam
import 'package:flutter/material.dart';
import 'Movie.dart';
import 'poster.dart';
import 'cover.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
void main() => runApp(MaterialApp(
  home: MyApp()
  
));

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //fetching data
  List <Movie> MoviesList = [];
  Future<List<Movie>>_getMovies() async{
    var response = await get('https://api.themoviedb.org/4/list/1?page=1&api_key=0c453193cd4da19c00a9d99cb1ef2eae');    
    var ParsedData = json.decode(response.body);
   
    for(var i in ParsedData['results']){ 
      var title = i['title'];
      var vote =i['vote_average'];
      var overview =i['overview'];
      var date = i['release_date'];

      Movie movie = Movie(vote,title,overview,date);
      MoviesList.add(movie);
      Poster poster = Poster(i['poster_path']);
      String posterPath = "${poster.baseUrl}${poster.path}"; 

      Cover cover= Cover(i['backdrop_path']);
      String coverPath = "${cover.baseUrl}${cover.path}";
      
      movie.setPoster(posterPath);
      movie.setCover(coverPath);
    }
    return MoviesList;
  }

  Widget build(BuildContext context) {

    return MaterialApp
    ( 
      home:Scaffold(

        appBar: AppBar(   
          backgroundColor: Colors.redAccent,
          title : Text('The Review'),
        ),

        body: Column(
          children: <Widget>[

            Container(decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10.0)),
              margin:EdgeInsets.only(top: 30.0, bottom: 15.0, right: 230.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0 ,vertical:8.0),
                child: Text("Marvel Movies",
                style: TextStyle( color: Colors.white, fontSize: 18.0) ),
              ),
            ),

            Expanded(            
            child:FutureBuilder(
              future: _getMovies(),
              builder:(BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.data == null){
                return Container(child: Center(
                  child: Text('loading', style: TextStyle(
                  color: Colors.black
                  ),),)
                );
              }
              else{
               
                return ListView.builder(   
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.length,
                  itemBuilder:(BuildContext context, int index){
                  return ListTile(
                    contentPadding: EdgeInsets.all(7),
                    subtitle:Container(
                      child:Text(snapshot.data[index].title, 
                        style: TextStyle(
                        color: Colors.black87, 
                        fontSize:23,
                        fontWeight: FontWeight.bold,
                      ),),
                      alignment: Alignment(-.85, 0),
                      padding: EdgeInsets.only(top:10),
                    ),
            
                    title:Container(
                      width: 20.0,
                      height: 340.0,
                      margin: EdgeInsets.only(top: 20.0,right: 33.0),
                      decoration: BoxDecoration(
                      image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(snapshot.data[index].poster)
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),

                    trailing: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        radius: 30.0,
                        child: Text(snapshot.data[index].vote.toString(), style: TextStyle(
                          color: Colors.black,
                          fontSize:21,
                          )),
                      ),
                      padding: EdgeInsets.only(right: 40),
                    ),
                    onTap: (){
                      Navigator.push(context,
                      new MaterialPageRoute(builder: (context)=>MoviePage(snapshot.data[index])));
                    },
                  );
                  } 
                );
              }
              },
            )
            )
          ],
          )
    )
    );
  }
}
class MoviePage extends StatelessWidget{
  var data;
  MoviePage(this.data);
  Widget build(BuildContext context){
   return Scaffold(
     backgroundColor: Color(0xFF2d3447),
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       title:Text(data.title),
     ),
    body: Column(
    children: <Widget>[
     
      Stack(
        children: <Widget>[

          Container(margin: EdgeInsets.only(left: 15.0,top:15),
          width: 385.0,
          height: 250.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(data.cover)
              ),
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
            color: Colors.redAccent,
          ),
        ),   
  
        CircleAvatar(
          backgroundColor: Colors.yellow,
          radius: 30.0,
          child: Text(data.vote.toString(), style: TextStyle(
          color: Colors.black,
          fontSize:23,
            )
          ),
        ),

        Container(
         width:330,
         height:370,
         padding: EdgeInsets.only(top:10),
         margin: EdgeInsets.only(top: 215, left:30),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(8.0),
         ),
         child: Column(
           children: <Widget>[
            Align(
              alignment: Alignment(-.9, 2),
                child:Text('The Overview', 
                style: TextStyle(
                fontSize: 23,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:13, vertical: 8 ),
              child:Text(data.overview, style: TextStyle(
                fontSize: 16
              ))
            )       
           ],
         ),
        )
      ],
    )
  ],
   ));
 }  
}
