import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  final String token="0528f62586f9a7ba9af61d39314e0cc3bac1655b";
  final String url="https://owlbot.info/api/v4/dictionary/";

  TextEditingController searchcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      
      appBar: AppBar(
        title: Text("Dictionary"),
        centerTitle: true,
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

                  },
                  controller: searchcontroller,
                  ),
              ),
            ),
          IconButton(icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){

          },
          )
          ],
          ),
        ),
        ),
        
        body:Container(

        )
    );
  }
}