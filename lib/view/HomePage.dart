import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:tlab_overflow/model/searchResponse.dart';
import 'package:tlab_overflow/service/httpConnection.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Connection api = new Connection();
  static String _searchText = 'stackoverflow';
  static int pageSize = 10;
  static BuildContext myContext;
  static String _pageSelected;
  TextEditingController searchController = new TextEditingController();

  List<int> pages = [10, 20, 30, 40, 50];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (int pages in pages) {
      items.add(new DropdownMenuItem(
          value: pages.toString(),
          child: new Text(pages.toString())
      ));
    }
    return items;
  }

  final _pageLoadController = PagewiseLoadController(
    pageSize: pageSize,
    pageFuture: (pageIndex) => getResult(pageIndex * pageSize),
  );

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _HomePageState._pageSelected = _dropDownMenuItems[0].value;
    searchController = new TextEditingController(text: _HomePageState._searchText);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey),
                ),
                width: (MediaQuery.of(context).size.width),
                margin: EdgeInsets.only(top: 16, right: 16, left: 16),
                height: 40,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  width: (MediaQuery.of(context).size.width) * 0.75,
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
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _HomePageState._searchText = value;
                        this._pageLoadController.init();
                        this._pageLoadController.reset();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, bottom: 10, top: 10),
            child: DropdownButton(
              isExpanded: true,
              style: TextStyle(
                fontFamily: 'Work Sans Medium',
                fontSize: 16,
                color: Colors.black
              ),
              iconEnabledColor: Theme.of(context).cursorColor,
              underline: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              value: _pageSelected,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
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

  void changedDropDownItem(String page) {
    setState(() {
      _HomePageState._pageSelected = page;
      this._pageLoadController.init();
      this._pageLoadController.reset();
    });
  }

  Widget _searchBuilder(context, Item data, index) {
    return Container(
      color: Colors.grey,
      margin: EdgeInsets.only(top: 10),
      child: Row(
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
                      child: Text(data.owner.displayName,
                        style: TextStyle(
                          fontFamily: 'Work Sans Medium',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      child: Text(data.creationDate.toString(),
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

  static Future<List<Item>> getResult(int offset) async{

    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append('pagesize',_HomePageState._pageSelected);
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
