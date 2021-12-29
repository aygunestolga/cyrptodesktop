import 'dart:convert';

import 'package:cryptodesktop/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {


  fetchData() async {
    var url = "https://api.coinlore.net/api/tickers/";
    var response = await http.get(Uri.parse(url));


    if (response.statusCode == 200) {
      var items = json.decode(response.body)["data"];
      setState(() {});
      datas = items;
      isloading = false;
    } else {
      datas = [];
      isloading = true;
    }


  }

  List  datas = [];
  bool  isloading = false;


  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coin Follow"),
        centerTitle: true,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (datas.contains(null) || datas.length < 0 || isloading) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(primary)),
      );
    }
    return ListView.builder(
        itemCount: datas.length ,
        itemBuilder: (context, index){
          return getCard(datas[index]);
        }
    );
  }

  Widget getCard(item){
    var name = item['name'];
    var price_usd = item["price_usd"];
    var symbol = item["symbol"];
    
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    symbol,style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 20,),

              Column(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width-140,
                    child: Text(name,style: TextStyle(color: Colors.blue),),
                  ),
                  SizedBox(height: 10,),
                  Text(price_usd,style: TextStyle(color: Colors.green),)
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
