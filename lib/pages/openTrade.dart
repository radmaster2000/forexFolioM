import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fx_journal/MODELS/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/utilities.dart';
import 'account.dart';

class OpenTrade extends StatefulWidget {
  String? week;
   OpenTrade({super.key,this.week});

  @override
  State<OpenTrade> createState() => _OpenTradeState();
}

class _OpenTradeState extends State<OpenTrade> {
  DatabaseHelper database=DatabaseHelper();
  List <JournalData>db=[];
  List<bool> isShow=[];
  TextEditingController _calender=TextEditingController();
  String stopLoss="TP";

  var _selectedDate = DateTime.now();
  getdatabaseData()async{
  var data=  await database.getJournalData();

  debugPrint("the database data is ${data[0].takeProfit},${data[0].date},${data[0].lotSize},${data[0].stoploss},${data[0].hitby},${data[0].open},${data[0].notes}");
  if(data!=null){
    db=data;
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
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
            backgroundColor:Color.fromARGB(255, 24, 21, 21),
            title:  Text('${widget.week}',style: TextStyle(color: Colors.white),),
            actions: [IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen(),));
            }, icon: Icon(Icons.account_circle))],
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
            itemCount: db.length,
            itemBuilder: (context, index) {
              isShow.add(false);
              return customCard(isShow,index,db);
            },),
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

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }
  Widget customRadio(BuildContext context,String text){
    return Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            //height: 50.0,
            width: MediaQuery.of(context).size.width/3,
            child: new Center(
              child: new Text(text,
                  style: new TextStyle(
                      color:
                      true ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color:true
                  ? Colors.blueAccent
                  : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color:true
                      ? Colors.blueAccent
                      : Colors.grey),
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
  customCard(List<bool> isShow,int index,List<JournalData> data){
    return Builder(
      builder: (context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(color: Colors.grey)
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(data[index].symbol,style: Theme.of(context).textTheme.headlineMedium,)
                      ],
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
                  Container(
                    width: 100,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(color: Colors.grey)
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(

                            children: [
                              Text('Return'),
                              Text('26%')
                            ],
                          ),
                        ),
                        Divider(thickness: 2,),
                        Container(
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
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(thickness: 2,),
           if(data[index].open=="Close") Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: Colors.grey)
                  // ),
                  child: Column(
                    children: [
                      Text('Open'),
                      Text(data[index].entryLevel)
                    ],
                  ),
                )
                ,
                Container(
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: Colors.grey)
                  // ),
                  child: Column(
                    children: [
                      Text('Close'),
                     if(data[index].open=="Close") Text(data[index].stoploss)
                    ],
                  ),
                )],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("P&L"),
                    Text(" ")
                  ],
                ),
                Column(
                  children: [
                    Text("Size"),
                    Text(data[index].lotSize)
                  ],
                ),
                Column(
                  children: [
                    Text("SL"),
                    Text(data[index].stoploss)
                  ],
                ),
                Column(
                  children: [
                    Text("TP"),
                    Text(data[index].takeProfit)
                  ],
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (data[index].images==null)?IconButton(onPressed: (){

                }, icon: Icon(Icons.camera_alt)):Icon(Icons.add),
                (isShow[index])?IconButton(onPressed: (){
                  isShow[index]=!isShow[index];
                  setState(() {

                  });
                }, icon: Icon(Icons.expand_less)):IconButton(onPressed: (){
                  isShow[index]=!isShow[index];
                  setState(() {

                  });
                }, icon: Icon(Icons.expand_more))
              ],
            ),
            if(isShow[index]) Divider(),
            if(isShow[index])Text("Notes: ${data[index].notes}"),
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
                TextButton(onPressed: (){}, child: Text('Edit')),
              if(data[index].open!="Close")  TextButton(onPressed: (){
                  closeTrade(data[index].stoploss,data[index].takeProfit,data[index].lotSize,data[index].symbol,data[index].id);
                }, child: Text('Close'))
              ],
            )
          ],
        ),
      ),
    ),);
  }

  closeTrade(String sl,String tp,String lot,String curency ,int id){
    TextEditingController date=TextEditingController();
    TextEditingController close=TextEditingController();
    TextEditingController lotSize=TextEditingController();
    TextEditingController PL=TextEditingController();
    TextEditingController fees=TextEditingController();
    TextEditingController notes=TextEditingController();
    close.text=sl;
    lotSize.text=lot;
    showDialog(context: context, builder: (context) {
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
                        controller: _calender,
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
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000, 1), // Optional: Set minimum date
                        lastDate: DateTime.now(), // Optional: Set maximum date
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _calender.text=DateFormat('dd-MM-yyyy').format(_selectedDate).toString();
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
                          date: date.text,
                          setup: "",
                          entryLevel:close.text,
                          lotSize: lotSize.text,
                          stoploss: close.text,
                          takeProfit: close.text,
                          images: null,
                          open: "Close",
                        hitby: stopLoss,
                        notes: notes.text
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
    },);
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
