import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

import 'about.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchcontroller=TextEditingController();
  String token="0528f62586f9a7ba9af61d39314e0cc3bac1655b";
  String url="https://owlbot.info/api/v4/dictionary/";

  StreamController _streamController;
  Stream _stream;
  Timer typing;
  @override

  void initState(){
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  search() async {
    if (searchcontroller.text == null || searchcontroller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(url + searchcontroller.text.trim(), headers: {"Authorization": "Token " + token});
    print(response.body);

    // if(json.decode(response.body)[0]["message"].!=null){
    //   print("Ouch");
    //   return;
    // }
    
  // print(json.decode(response.body));
    _streamController.add(json.decode(response.body));
  }
  
  
  Widget build(BuildContext context) {
    return Scaffold
    (
      
      appBar: AppBar(
        elevation: 10,
        title: Text(" Dictionary",style: TextStyle(fontSize: 20),),
        actions: <Widget>[
          Container(
            
            margin:EdgeInsets.only(right:10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.info),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutPage()
               ));
                },
                ),
              
            ),
          )
        ],
        backgroundColor: Color(0xFF21BFBD),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Row(children: <Widget>[
            Expanded(
              child: Container(
                margin:EdgeInsets.only(left:15,right:10,bottom:10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  
                  borderRadius: BorderRadius.circular(50)
                  
                  ),
                child: TextFormField(
                  decoration: InputDecoration(
                  hintText: "Search for any word",
                  contentPadding: EdgeInsets.only(left:24),
                  border:InputBorder.none,
                  ),
                  onChanged: (String word){
                    if(typing?.isActive ?? false) typing.cancel();
                    typing=Timer(Duration(milliseconds: 1000),(){
                      search();
                    });
                    
                  },
                  controller: searchcontroller,
                  ),
              ),
            ),
          IconButton(icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){
            search();
          },
          )
          ],
          ),
        ),
        ),
        
        body:Container(
          margin:EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: StreamBuilder(
            stream:_stream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data==null){
                return Center(
                  child: Text("Come On, Search Something..."),
                  );
              }
               if (snapshot.data == "waiting") {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xFF21BFBD),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                );
              }
              if(snapshot.data=="error"){
                print("Error");
                return Center(child: Text("Error"),);
              }
              if(snapshot.data["definitions"].length==0){
                return Center(child: Text("Oops, couldn't find that word"),);
              }
              return ListView.builder(
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (context,int index){
                  return ListBody(children: <Widget>[
                    Container(
                      
                      color:Colors.grey[200],
                      child: ListTile(
                        leading: snapshot.data["definitions"][index]["image_url"]==null ? null :
                        CircleAvatar(backgroundImage: NetworkImage(snapshot.data["definitions"][index]["image_url"]),
                        ),
                        title: Text(searchcontroller.text.trim() + " (" + snapshot.data["definitions"][index]["type"] + ")"),
                        
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          snapshot.data["definitions"][index]["definition"],textAlign: TextAlign.justify
                          ),
                      )
                  ],);
                });
            },
          ),
        )
    );
  }
}