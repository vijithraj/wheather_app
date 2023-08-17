import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'constraints.dart'as k;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoaded = false;
  num? temp;
  num? pressure;
  num? humidity;
  num? cover;
  String cityname = '';
  void initstat(){
   // TODO:implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/image1.jpg"),
                ),
              ),
              child: Visibility(
                  visible: isLoaded,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       /* Container(
                          height: MediaQuery.of(context).size.width * 0.85,
                          width: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: TextFormField(
                              onFieldSubmitted: (String text) {
                                setState(() {
                                  cityname = text;
                                    getCityWeather(text);
                                  setState(() {
                                    isLoaded = false;
                                  });
                                });
                              },
                              cursorColor: Colors.white,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.7)),
                              decoration: InputDecoration(
                                  hintText: 'Search city',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),*/
                        Text(
                          cityname,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Saturday,Feb,2022",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 130,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.cloud,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Cloud',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Pressure:${pressure?.toInt()}hpa',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Humidity:${humidity?.toInt()}%',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            '${temp?.toInt()}',
                            style: TextStyle(
                                fontSize: 90,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                  ),
                  replacement: Center(
                    child: const CircularProgressIndicator(),
                  )))),
    );
  }
  getCurrentLocation()async{
    var position=await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (position!=null){
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    }
    else{
      print('Data Unavailable');
    }
  }
  getCurrentCityWeather(Position pos)async{
    var url='${k.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${k.apiKey}';
    var uri=Uri.parse(url);
    var response=await http.get (uri);
    if (response.statusCode==200){
      var data=response.body;
      var decodeData=jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded=true;
      });
    }
    else{
      print(response.statusCode);
    }
  }
  updateUI(var decodeData){
    setState(() {
      if (decodeData==null){
        temp=0;
        pressure=0;
        humidity=0;
        cover=0;
        cityname="Not available";
      }
      else{
        temp=decodeData['main']['temp']-273;
        pressure=decodeData['main']['pressure'];
        humidity=decodeData['clouds']['all'];
        cityname=decodeData['name'];
      }
    });
  }
 /* getCityWeather(String cityname)async{
    var client=http.Client();
    var uri='${k.domain}q=$cityname&appid=${k.apiKey}';
    var url=Uri.parse(uri);
    var response=await client.get(url);
    if (response.statusCode==200){
      var data=response.body;
      var decodeData=jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded=true;
      });
    }
    else{
      print(response.statusCode);

    }
  }
*/

}
