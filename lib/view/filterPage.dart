import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlab_overflow/view/HomePage.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _pageSelected;
  String toDate, fromDate;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  TextEditingController dateFromController, dateToController;
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

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();

    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Filter',
          style: TextStyle(
            fontFamily: 'Work Sans Medium',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,color: Colors.blue,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 16, left: 16, bottom: 10, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text('Page size',
                                  style: TextStyle(
                                    fontFamily: 'Work Sans Medium',
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                margin: EdgeInsets.only(right: 16),
                              ),
                              Container(
                                child: DropdownButton(
                                  isExpanded: false,
                                  style: TextStyle(
                                    fontFamily: 'Work Sans Medium',
                                    fontSize: 16,
                                    color: Colors.black,
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
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            selectFromDate(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16, left: 16, bottom: 10),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: dateFromController,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Work Sans Regular',
                                    color: Colors.black,
                                  ),
                                  labelText: 'Dari',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today, color: Theme.of(context).cursorColor,),
                                    onPressed: null,
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            selectToDate(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16, left: 16, bottom: 10),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: dateToController,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Work Sans Regular',
                                    color: Colors.black,
                                  ),
                                  labelText: 'Sampai',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today, color: Theme.of(context).cursorColor,),
                                    onPressed: null,
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                      HomePage(
                        pageSize: int.parse(this._pageSelected),
                        fromDate: this.selectedFromDate.millisecondsSinceEpoch,
                        toDate: this.selectedToDate.millisecondsSinceEpoch,
                      ),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: (MediaQuery.of(context).size.width),
                padding: EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cursorColor,
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Cari',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Work Sans Medium',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changedDropDownItem(String page) {
    setState(() {
      this._pageSelected = page;
      savePageSize(page);
    });
  }

  getPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      if(prefs.getInt('pagesize')!=null) {
        this._pageSelected = prefs.getInt('pagesize').toString();
      } else{
        this._pageSelected = _dropDownMenuItems[0].value;
      }

    });
  }

  Future<Null> selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child){
          return Theme(
            child: child,
            data: ThemeData(
              primaryColor: Theme.of(context).primaryColor,
              accentColor: Theme.of(context).primaryColor,
            ),
          );
        }
    );

    if(picked == null){
      setState(() {
      });
    }
    else if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
        fromDate = DateFormat('yyyy-MM-dd').format(selectedFromDate);
        saveFromDate(selectedFromDate.millisecondsSinceEpoch);
        dateFromController = new TextEditingController(text: fromDate);
      });
    } else if (picked == selectedFromDate){
      setState(() {
        selectedFromDate = DateTime.now();
        saveFromDate(selectedFromDate.millisecondsSinceEpoch);
        fromDate = DateFormat('yyyy-MM-dd').format(selectedFromDate);
        dateFromController = new TextEditingController(text: fromDate);
      });
    }
  }

  Future<Null> selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child){
          return Theme(
            child: child,
            data: ThemeData(
              primaryColor: Theme.of(context).primaryColor,
              accentColor: Theme.of(context).primaryColor,
            ),
          );
        }
    );

    if(picked == null){
      setState(() {
      });
    }
    else if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
        saveToDate(selectedToDate.millisecondsSinceEpoch);
        toDate = DateFormat('yyyy-MM-dd').format(selectedToDate);
        dateToController = new TextEditingController(text: toDate);
      });
    } else if (picked == selectedToDate){
      setState(() {
        selectedToDate = DateTime.now();
        saveToDate(selectedToDate.millisecondsSinceEpoch);
        toDate = DateFormat('yyyy-MM-dd').format(selectedToDate);
        dateToController = new TextEditingController(text: toDate);
      });
    }
  }

  savePageSize(String size) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('pagesize', int.parse(size));
  }

  saveFromDate(int fromDate) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('fromDate', fromDate);
  }

  saveToDate(int toDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('toDate', toDate);
  }

}
