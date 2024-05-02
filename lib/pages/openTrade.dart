import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fx_journal/MODELS/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/utilities.dart';
import 'account.dart';

class OpenTrade extends StatefulWidget {
  String? startday;
  String? endDay;
  OpenTrade({super.key, this.startday, this.endDay});

  @override
  State<OpenTrade> createState() => _OpenTradeState();
}

class _OpenTradeState extends State<OpenTrade> {
  DatabaseHelper database = DatabaseHelper();
  List<JournalData> db = [];
  List<JournalData> filteredList = [];
  List<bool> isShow = [];
  TextEditingController _calender = TextEditingController();
  String stopLoss = "TP";

  var _selectedDate = DateTime.now();
  getdatabaseData() async {
    var data = await database.getJournalData();

  debugPrint("the database data is ${data[0].takeProfit},${data[0].opendate},${data[0].lotSize},${data[0].stoploss},${data[0].hitby},${data[0].open},${data[0].notes}");
  if(data!=null){
    db=data;
    for(int i=0;i<db.length;i++){
      List<String> parts = db[i].opendate.split("-"); // Split the date string by '-'
      String formattedDate = "${parts[2]}-${parts[1]}-${parts[0]}";
      debugPrint("date is ${db[i].opendate}");
      DateTime date=   DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(formattedDate)));
      DateTime monday = date.subtract(Duration(days: date.weekday - 1));
      DateTime friday = monday.add(Duration(days: 4));
      ///========================///
      List<String> dayParts = widget.startday!.split("-");
      String formattedDay = "${dayParts[2]}-${dayParts[1]}-${dayParts[0]}";
      DateTime dayDateTime = DateTime.parse(formattedDay);
      ///==============================///
      List<String> endParts = widget.endDay!.split("-");
      String form = "${endParts[2]}-${endParts[1]}-${endParts[0]}";
      DateTime endDayTime = DateTime.parse(form);
      debugPrint("In open trade $date and $monday and $friday");
      if (dayDateTime == monday && endDayTime==friday) {
       filteredList.add(db[i]);
      } else {
        print("The day is not equal to Friday");
      }
    }
    setState(() {

    });
  }

  }

  @override
  void initState() {
    // TODO: implement initState
    getdatabaseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                )),
            backgroundColor: Color.fromARGB(255, 24, 21, 21),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.startday}',
                    style: TextStyle(color: Colors.white,fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("-",style: TextStyle(color: Colors.white)),
                ),
                Expanded(child: Text('${widget.endDay}',style: TextStyle(color: Colors.white,fontSize: 15),)),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AccountScreen(),
                    ));
                  },
                  icon: Icon(Icons.account_circle))
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  //Color(0xFF9B75DA),
                  Color(0xFFFF7600),
                  Color(0xFFFF7600),
                ],
              ),
            ),
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                isShow.add(false);
                return customCard(isShow, index, filteredList);
              },
            ),
          )
          // body: Container(
          //   height: getHeight(context,1),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [ Color(0xFF9B75DA),
          //         Color(0xFF9B75DA),
          //         Colors.white],
          //     ),
          //   ),
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Expanded(child: customRadio(context,'Stop')),
          //             Expanded(child: customRadio(context,'Loss'))
          //           ],
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Card(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("EURUSD",style: Theme.of(context).textTheme.headlineSmall,),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("15%",style: Theme.of(context).textTheme.headlineMedium),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(5.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text("Mar 4"),
          //                         Text('-'),
          //                         Text('10 Mar'),
          //                         Text(',2024'),
          //                         Icon(Icons.do_not_disturb_on_total_silence,color: Colors.green,size: 10,)
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             Card(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("Return",style: Theme.of(context).textTheme.headlineSmall,),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text("15%",style: Theme.of(context).textTheme.headlineMedium),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.all(5.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text("Mar 4"),
          //                         Text('-'),
          //                         Text('10 Mar'),
          //                         Text(',2024'),
          //                         Icon(Icons.do_not_disturb_on_total_silence,color: Colors.green,size: 10,)
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          ),
    );
  }

  Future<void> _pickImage(File image) async {
    // Request permission if needed (Android only)
    // await Permission.storage.request();

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Widget customRadio(BuildContext context, String text) {
    return Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            //height: 50.0,
            width: MediaQuery.of(context).size.width / 3,
            child: new Center(
              child: new Text(text,
                  style: new TextStyle(
                      color: true ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: true ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0, color: true ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          // new Container(
          //   margin: new EdgeInsets.only(left: 10.0),
          //   child: new Text("ppp"),
          // )
        ],
      ),
    );
  }

  customCard(List<bool> isShow, int index, List<JournalData> data) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(color: Colors.grey)
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data[index].symbol,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              data[index].opendate,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    // Container(
                    //   width: 1, // Adjust the width of the divider
                    //   //height: 40, // Adjust the height of the divider
                    //   color: Colors.grey, // Change the color as needed
                    //   margin: EdgeInsets.symmetric(horizontal: 10), // Adjust the margin as needed
                    // ),
                    Expanded(
                      child: Container(
                       // width: 100,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(color: Colors.grey)
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (data[index].open == "Close")
                                ? Container(
                                    child: Column(
                                      children: [Text('Return'), Text('26%')],
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Status'),
                                        Text('Active')
                                      ],
                                    ),
                                  ),
                            Divider(
                              thickness: 2,
                            ),
                            (data[index].open == "Close")
                                ? Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(20),
                                    //     border: Border.all(color: Colors.grey)
                                    // ),
                                    child: Column(
                                      children: [
                                        Text('Duration'),
                                        Text('2:00 hrs%')
                                      ],
                                    ),
                                  )
                                : Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(20),
                                    //     border: Border.all(color: Colors.grey)
                                    // ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (data[index].longShort == "Long")
                                            ? Icon(Icons.arrow_circle_up)
                                            : Icon(Icons.arrow_circle_down),
                                        (data[index].longShort == "Long")
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Buy"),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Sell"),
                                              )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (data[index].open == "Close")
                Divider(
                  thickness: 2,
                ),
              if (data[index].open == "Close")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(color: Colors.grey)
                      // ),
                      child: Column(
                        children: [Text('Open'), Text(data[index].entryLevel)],
                      ),
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(color: Colors.grey)
                      // ),
                      child: Column(
                        children: [
                          Text('Close'),
                          if (data[index].open == "Close")
                            (stopLoss=="SL")?Text(data[index].stoploss):Text(data[index].takeProfit)
                        ],
                      ),
                    )
                  ],
                ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (data[index].open == "Close")
                        ? Column(
                            children: [Text("P&L"), Text(data[index].PL)],
                          )
                        : Column(
                            children: [
                              Text("Entry"),
                              Text(data[index].entryLevel)
                            ],
                          ),
                    Column(
                      children: [Text("Size"), Text(data[index].lotSize)],
                    ),
                    Column(
                      children: [Text("SL"), Text(data[index].stoploss)],
                    ),
                    Column(
                      children: [Text("TP"), Text(data[index].takeProfit)],
                    )
                  ],
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (data[index].images == null)
                      ? IconButton(
                          onPressed: () {}, icon: Icon(Icons.camera_alt))
                      : Icon(Icons.add),
                  (isShow[index])
                      ? IconButton(
                          onPressed: () {
                            isShow[index] = !isShow[index];
                            setState(() {});
                          },
                          icon: Icon(Icons.expand_less))
                      : IconButton(
                          onPressed: () {
                            isShow[index] = !isShow[index];
                            setState(() {});
                          },
                          icon: Icon(Icons.expand_more))
                ],
              ),
              if (isShow[index]) Divider(),
              if (isShow[index]) Text("Notes: ${data[index].notes}"),
              // if(isShow[index]) Row(
              //   children: [
              //     // Show uploaded images (if any)
              //     ...List.generate(
              //       uploadedImagesCount,
              //           (index) => Image.asset(
              //         // Replace with your image asset path
              //         "assets/images/image_${index + 1}.jpg",
              //         width: 50, // Adjust as needed
              //       ),
              //     ),
              //
              //     // Show upload icon if less than 3 images are uploaded
              //     if (uploadedImagesCount < 3)
              //       IconButton(
              //         icon: Icon(Icons.upload_file),
              //         onPressed: () {
              //           // Handle image upload logic
              //         },
              //       ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {

                    editTrade();
                  }, child: Text('Edit')),
                  if (data[index].open != "Close")
                    TextButton(
                        onPressed: () {
                          closeTrade(
                              data[index].stoploss,
                              data[index].takeProfit,
                              data[index].lotSize,
                              data[index].symbol,
                              data[index].id,
                              data[index].entryLevel,
                              data[index].opendate
                          );
                        },
                        child: Text('Close'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  closeTrade(String sl,String tp,String lot,String curency ,int id,String entry,String opendate)async{
    TextEditingController date=TextEditingController();
    TextEditingController close=TextEditingController();
    TextEditingController lotSize=TextEditingController();
    TextEditingController PL=TextEditingController();
    TextEditingController fees=TextEditingController();
    TextEditingController notes=TextEditingController();
    var _select=DateTime.now();
    close.text=sl;
    lotSize.text=lot;
    await calculatePandL(lot,entry,tp,sl).then((value) => showDialog(context: context, builder: (context) {
      PL.text=value;
      stopLoss="TP";
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Close Trade',style: Theme.of(context).textTheme.titleLarge),
                    Spacer(),
                    Expanded(
                      child: TextField(
                        controller: date,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                          // border: OutlineInputBorder(),
                          hintText: 'Select Date',
                        ),
                      ),
                    ),
                    IconButton(onPressed: ()async{
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _select,
                        firstDate: DateTime(2000, 1), // Optional: Set minimum date
                        lastDate: DateTime.now(), // Optional: Set maximum date
                      );
                      if (pickedDate != null && pickedDate != _select) {
                        setState(() {
                          _select = pickedDate;
                          date.text=DateFormat('dd-MM-yyyy').format(_select).toString();
                          setState((){});
                        });
                      }
                    }, icon:  Icon(Icons.calendar_today)),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          stopLoss="TP";
                          close.text=tp;
                          PL.text=value;
                          setState((){});
                        },
                        child: Container(
                          //height: 50.0,
                          //width: MediaQuery.of(context).size.width/3,
                          child: new Center(
                            child: new Text('TP',
                                style: new TextStyle(
                                    color:
                                    (stopLoss=="TP")?Colors.white:Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                          ),
                          decoration: new BoxDecoration(
                            color:(stopLoss=="TP")?Colors.blue:Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color:true
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          stopLoss="SL";
                          close.text=sl;
                          PL.text="-$value";
                          setState((){});
                        },
                        child: Container(
                          //height: 50.0,
                          // width: MediaQuery.of(context).size.width/3,
                          child: new Center(
                            child: new Text('SL',
                                style: new TextStyle(
                                    color:
                                    (stopLoss=="SL")?Colors.white:Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                          ),
                          decoration: new BoxDecoration(
                            color:(stopLoss=="SL")?Colors.blue:Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color:true
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          stopLoss="manual";
                          close.text="";
                          PL.text="";
                          setState((){});
                        },
                        child: Container(
                          //height: 50.0,
                          // width: MediaQuery.of(context).size.width/3,
                          child: new Center(
                            child: new Text('manual',
                                style: new TextStyle(
                                    color:
                                    (stopLoss=="manual")?Colors.white:Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                          ),
                          decoration: new BoxDecoration(
                            color:(stopLoss=="manual")?Colors.blue:Colors.transparent,
                            border: new Border.all(
                                width: 1.0,
                                color:true
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("Close Price"),
                            TextField(
                              controller: close,
                              onChanged: (String? value)async{
                                PL.text=await calculatePandL(lot, entry, value!, value!);
                                setState((){});
                              },

                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Lot Size"),
                            TextField(
                              controller: lotSize,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("Net P&L"),
                            TextField(
                              controller: PL,
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Fees"),
                            TextField(
                              controller: fees,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Notes"),
                TextField(
                  controller: notes,
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text('Cancel')),
                    TextButton(onPressed: (){
                      debugPrint("data is close");
                      JournalData newEntry = JournalData(
                          id: id,
                          symbol: curency,
                          opendate: opendate,
                          closedate: date.text,
                          setup: "",
                          entryLevel:entry,
                          lotSize: lotSize.text,
                          stoploss: sl,
                          takeProfit: tp,
                          images: null,
                          open: "Close",
                          PL: PL.text,
                          hitby: close.text,
                          notes: notes.text,
                          longShort:""
                      );
                      database.updateJournalData(newEntry);
                      setState((){
                        getdatabaseData();
                      });
                      Navigator.pop(context);
                    }, child: Text('Close'))
                  ],
                )
              ],
            ),
          ),
        );
      },);
    },));

  }

  editTrade(){
    DateTime _select=DateTime.now();
    TextEditingController opendate=TextEditingController();
    TextEditingController closedate=TextEditingController();
    TextEditingController entrylevel=TextEditingController();
    TextEditingController SL=TextEditingController();
    TextEditingController TP=TextEditingController();
    TextEditingController close=TextEditingController();
    TextEditingController lotSize=TextEditingController();
    TextEditingController PL=TextEditingController();
    TextEditingController fees=TextEditingController();
    TextEditingController notes=TextEditingController();
    showDialog(context: context, builder: (context) => StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Trade',style: Theme.of(context).textTheme.titleLarge),
                  Spacer(),

                  IconButton(onPressed: ()async{
                    // final pickedDate = await showDatePicker(
                    //   context: context,
                    //   initialDate: _select,
                    //   firstDate: DateTime(2000, 1), // Optional: Set minimum date
                    //   lastDate: DateTime.now(), // Optional: Set maximum date
                    // );
                    // if (pickedDate != null && pickedDate != _select) {
                    //   setState(() {
                    //     _select = pickedDate;
                    //     date.text=DateFormat('dd-MM-yyyy').format(_select).toString();
                    //     setState((){});
                    //   });
                    // }
                  }, icon:  Icon(Icons.delete)),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text("Open"),
                  Expanded(
                    child: TextField(
                      controller: opendate,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontWeight: FontWeight.normal),
                        // border: OutlineInputBorder(),
                        hintText: '',
                      ),
                    ),
                  ),
                  IconButton(onPressed: ()async{
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _select,
                      firstDate: DateTime(2000, 1), // Optional: Set minimum date
                      lastDate: DateTime.now(), // Optional: Set maximum date
                    );
                    if (pickedDate != null && pickedDate != _select) {
                      setState(() {
                        _select = pickedDate;
                        //date.text=DateFormat('dd-MM-yyyy').format(_select).toString();
                        setState((){});
                      });
                    }
                  }, icon:  Icon(Icons.calendar_today)),
                ],
              ),
              TextField(
               // controller: date,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontWeight: FontWeight.normal),
                  // border: OutlineInputBorder(),
                  hintText: 'Select Date',
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //         onTap: (){
              //           stopLoss="TP";
              //           close.text=tp;
              //           PL.text=value;
              //           setState((){});
              //         },
              //         child: Container(
              //           //height: 50.0,
              //           //width: MediaQuery.of(context).size.width/3,
              //           child: new Center(
              //             child: new Text('TP',
              //                 style: new TextStyle(
              //                     color:
              //                     (stopLoss=="TP")?Colors.white:Colors.black,
              //                     //fontWeight: FontWeight.bold,
              //                     fontSize: 18.0)),
              //           ),
              //           decoration: new BoxDecoration(
              //             color:(stopLoss=="TP")?Colors.blue:Colors.transparent,
              //             border: new Border.all(
              //                 width: 1.0,
              //                 color:true
              //                     ? Colors.blueAccent
              //                     : Colors.grey),
              //             borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
              //           ),
              //         ),
              //       ),
              //       InkWell(
              //         onTap: (){
              //           stopLoss="SL";
              //           close.text=sl;
              //           PL.text="-$value";
              //           setState((){});
              //         },
              //         child: Container(
              //           //height: 50.0,
              //           // width: MediaQuery.of(context).size.width/3,
              //           child: new Center(
              //             child: new Text('SL',
              //                 style: new TextStyle(
              //                     color:
              //                     (stopLoss=="SL")?Colors.white:Colors.black,
              //                     //fontWeight: FontWeight.bold,
              //                     fontSize: 18.0)),
              //           ),
              //           decoration: new BoxDecoration(
              //             color:(stopLoss=="SL")?Colors.blue:Colors.transparent,
              //             border: new Border.all(
              //                 width: 1.0,
              //                 color:true
              //                     ? Colors.blueAccent
              //                     : Colors.grey),
              //             borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
              //           ),
              //         ),
              //       ),
              //
              //       InkWell(
              //         onTap: (){
              //           stopLoss="manual";
              //           close.text="";
              //           PL.text="";
              //           setState((){});
              //         },
              //         child: Container(
              //           //height: 50.0,
              //           // width: MediaQuery.of(context).size.width/3,
              //           child: new Center(
              //             child: new Text('manual',
              //                 style: new TextStyle(
              //                     color:
              //                     (stopLoss=="manual")?Colors.white:Colors.black,
              //                     //fontWeight: FontWeight.bold,
              //                     fontSize: 18.0)),
              //           ),
              //           decoration: new BoxDecoration(
              //             color:(stopLoss=="manual")?Colors.blue:Colors.transparent,
              //             border: new Border.all(
              //                 width: 1.0,
              //                 color:true
              //                     ? Colors.blueAccent
              //                     : Colors.grey),
              //             borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Close Price"),
                          TextField(
                            controller: close,
                            onChanged: (String? value)async{
                            //  PL.text=await calculatePandL(lot, entry, value!, value!);
                              setState((){});
                            },

                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Lot Size"),
                          TextField(
                            controller: lotSize,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Close Price"),
                          TextField(
                            controller: close,
                            onChanged: (String? value)async{
                             // PL.text=await calculatePandL(lot, entry, value!, value!);
                              setState((){});
                            },

                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Lot Size"),
                          TextField(
                            controller: lotSize,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Close Price"),
                          TextField(
                            controller: close,
                            onChanged: (String? value)async{
                             // PL.text=await calculatePandL(lot, entry, value!, value!);
                              setState((){});
                            },

                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Lot Size"),
                          TextField(
                            controller: lotSize,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Net P&L"),
                          TextField(
                            controller: PL,
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Fees"),
                          TextField(
                            controller: fees,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              Text("Notes"),
              TextField(
                controller: notes,
              ),
              // SizedBox(
              //   height: 50,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     TextButton(onPressed: (){
              //       Navigator.pop(context);
              //     }, child: Text('Cancel')),
              //     TextButton(onPressed: (){
              //       debugPrint("data is close");
              //       JournalData newEntry = JournalData(
              //           id: id,
              //           symbol: curency,
              //           opendate: opendate,
              //           closedate: date.text,
              //           setup: "",
              //           entryLevel:entry,
              //           lotSize: lotSize.text,
              //           stoploss: sl,
              //           takeProfit: tp,
              //           images: null,
              //           open: "Close",
              //           PL: PL.text,
              //           hitby: close.text,
              //           notes: notes.text,
              //           longShort:""
              //       );
              //       database.updateJournalData(newEntry);
              //       setState((){
              //         getdatabaseData();
              //       });
              //       Navigator.pop(context);
              //     }, child: Text('Close'))
              //   ],
              // )
            ],
          ),
        ),
      );
    },),);
  }






  Future <String> calculatePandL(String lot,String entry,String profit,String SL)async{
    var ratio;
    var pip_profit;
    var pip_loss;
    var risk;
    var reward;
    ratio=((0.0001/double.parse(entry))*(double.parse(lot)*100000));
    pip_profit=(double.parse(profit)-double.parse(entry))*10000;
    pip_loss=(double.parse(entry)-double.parse(SL))*10000;
    risk=ratio*pip_loss;
    reward=ratio*pip_profit;
    risk=risk*double.parse(entry);
    reward=reward*double.parse(entry);
    // var data=await getCurrncies2();
    //
    // int aer=data["USD"];
    // double aer2=data["$spl"];
    // double curreRatio=aer/aer2;
    // debugPrint('currency api $aer and $aer2 and $curreRatio and $ratio and $pip_profit and $pip_loss');
    //    risk*=curreRatio;
    // reward*=curreRatio;
    return risk.toStringAsFixed(2);
   // rewardi=reward.toStringAsFixed(2);
   //  setState(() {
   //
   //  });

  }


  void showPhotoSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  // Handle selecting a photo from gallery
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  // Handle taking a photo with camera
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle getting an image from gallery or camera
  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // You can now use the pickedFile to display or store the image
      print('Image path: ${pickedFile.path}');
    } else {
      print('No image selected.');
    }
  }
}
