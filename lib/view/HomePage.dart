import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlab_overflow/model/searchResponse.dart';
import 'package:tlab_overflow/service/httpConnection.dart';
import 'package:tlab_overflow/view/filterPage.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key,
    this.pageSize,
    this.fromDate,
    this.toDate,
  }) : super(key : key);

  final int pageSize;
  final int fromDate;
  final int toDate;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Connection api = new Connection();
  static String _searchText = 'stackoverflow';
  static int pageSize = 10;
  static int fromDate = 0;
  static int toDate = 0;
  static BuildContext myContext;
  TextEditingController searchController = new TextEditingController();

  final _pageLoadController = PagewiseLoadController(
    pageSize: pageSize,
    pageFuture: (pageIndex) => getResult(pageIndex * pageSize),
  );

  @override
  void initState() {
    super.initState();

    if(this.widget.pageSize!=null) _HomePageState.pageSize = this.widget.pageSize;
    _HomePageState.fromDate = this.widget.fromDate;
    _HomePageState.toDate = this.widget.toDate;

    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: SafeArea(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: (MediaQuery.of(context).size.width),
                      margin: EdgeInsets.all(16.0),
                      height: 40,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        width: (MediaQuery.of(context).size.width) * 0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).bottomAppBarColor,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent,),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent,),
                            ),
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(144, 144, 144, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.grey,),
                              onPressed: () {
                                setState(() {
                                  _HomePageState._searchText = _HomePageState._searchText;
                                  FocusScope.of(context).unfocus();
                                  this._pageLoadController.init();
                                  this._pageLoadController.reset();
                                });
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: _HomePageState._searchText != null && _HomePageState._searchText.length > 0 ?
                              Icon(Icons.clear, color: Colors.grey,) : Container(),
                              onPressed: () {
                                setState(() {
                                  WidgetsBinding.instance.addPostFrameCallback((_){
                                    searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    _HomePageState._searchText = '';
                                    this._pageLoadController.init();
                                    this._pageLoadController.reset();
                                  });
                                });
                              },
                            ),
                          ),
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              _HomePageState._searchText = value;
                              saveSearch(value);
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _HomePageState._searchText = value;
                              saveSearch(value);
                              this._pageLoadController.init();
                              this._pageLoadController.reset();
                            });
                          },
                        ),
                      ),
                    ),
                    flex: 9,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FilterPage())),
                      child: Container(
                        color: Colors.transparent,
                        height: 25,
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Image.asset('assets/images/filter-button.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  PagewiseListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    pageLoadController: this._pageLoadController,
                    itemBuilder: this._searchBuilder,
                    loadingBuilder: (context){
                      return Container(
                        child: SpinKitFadingCircle(
                          color: Colors.grey,
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context){
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 35),
                          child: Text(
                            'Search not found',
                            style: TextStyle(
                              fontFamily: 'Work Sans Bold',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBuilder(context, Item data, index) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      padding: EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: CircleAvatar(
                backgroundImage: data.owner == null || data.owner.profileImage ==''
                    ? AssetImage('assets/images/profile.png')
                    : NetworkImage(data.owner.profileImage),
                backgroundColor: Colors.white,
                radius: 40,
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: Text(data.title,
                        style: TextStyle(
                          fontFamily: 'Work Sans Bold',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      child: Text(data.owner.displayName,
                        style: TextStyle(
                          fontFamily: 'Work Sans Medium',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      child: Text(
                        stringToDateFormat(DateTime.fromMillisecondsSinceEpoch(data.creationDate * 1000, isUtc: true).toString()),
                        style: TextStyle(
                          fontFamily: 'Work Sans Regular',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 5,
          ),
        ],
      ),
    );
  }

  saveSearch(String search) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('search', search);
    print('pref : '+prefs.getString('search').toString());
  }

  getPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if(prefs.getString('search')!=null){
        _HomePageState._searchText = prefs.getString('search');
        searchController = new TextEditingController(text: _HomePageState._searchText);
      } else{
        searchController = new TextEditingController(text: 'stackoverflow');
      }

      if(prefs.getInt('pagesize')!=null) {
        _HomePageState.pageSize = prefs.getInt('pagesize');
      }

      if(prefs.getInt('fromDate')!=null) {
        _HomePageState.fromDate = prefs.getInt('fromDate');
      }

      if(prefs.getInt('toDate')!=null) {
        _HomePageState.toDate = prefs.getInt('toDate');
      }
    });
  }

  static Future<List<Item>> getResult(int offset) async{

    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append('pagesize',_HomePageState.pageSize);
    queryParams.append('fromdate',_HomePageState.fromDate);
    queryParams.append('todate',_HomePageState.toDate);
    queryParams.append('order', '');
    queryParams.append('tagged',_HomePageState._searchText);
    queryParams.append('site',"stackoverflow");
    print(queryParams.toString());

    var uri = api.baseUrl + api.endPoint + queryParams.toString();

    final responseBody = (await http.get(uri));
    var jsonResponse = json.decode(responseBody.body);
    print(jsonResponse.toString());

    if(jsonResponse['error_id'] != null){
      Fluttertoast.showToast(
        msg: jsonResponse['error_message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: 16.0,
      );
    }
    return Item.fromJsonList(jsonResponse['items']);
  }

}
