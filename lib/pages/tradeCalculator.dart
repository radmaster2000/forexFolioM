import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fx_journal/utils/utilities.dart';
import 'package:intl/intl.dart';

import '../MODELS/database.dart';
import '../utils/config.dart';

class TradeCalculatorScreen extends StatefulWidget {
  @override
  _TradeCalculatorScreenState createState() => _TradeCalculatorScreenState();
}

class _TradeCalculatorScreenState extends State<TradeCalculatorScreen> {
  // Define variables to store user inputs and calculated values
  // ...
  TextEditingController entry=TextEditingController();
  TextEditingController lot=TextEditingController();
  TextEditingController SL=TextEditingController();
  TextEditingController TP=TextEditingController();
  TextEditingController balance=TextEditingController();
  TextEditingController profit=TextEditingController();
  var _selectedDate = DateTime.now();
  List <JournalData>db=[];
  List<AccountData> acc=[];
  String currency="";
  String longShort='';
  String _errorText = '';
String?riski="";
String? rewardi="";
  DatabaseHelper dbHelper = DatabaseHelper();
  final List<String> currencies = [
    'EUR/USD', // Euro/US Dollar
    'USD/JPY', // US Dollar/Japanese Yen
    'GBP/USD', // British Pound Sterling/US Dollar
    'USD/CHF', // US Dollar/Swiss Franc
    'AUD/USD', // Australian Dollar/US Dollar
    'USD/CAD', // US Dollar/Canadian Dollar
    'NZD/USD',
    'XAU/USD',
    'XAG/USD',// New Zealand Dollar/US Dollar
    'EUR/GBP', // Euro/British Pound Sterling
    'EUR/JPY', // Euro/Japanese Yen
    'GBP/JPY', // British Pound Sterling/Japanese Yen
    'AUD/JPY', // Australian Dollar/Japanese Yen
    'EUR/AUD', // Euro/Australian Dollar
    // Add more currency pairs as needed
  ];
  String newcurrency='';
  TextEditingController _calender=TextEditingController();
  void showCurrencyDialog(BuildContext context,Function fn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: Scrollbar(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(currencies[index]),
                  onTap: () {
                    newcurrency=currencies[index];
                    fn();
                    // Handle the selection of the tapped currency
                    Navigator.pop(context, currencies[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  getdatabaseData()async{
    var account=await dbHelper.getAccountData();
    acc=account;
    debugPrint("account is $acc");
    if(account!=null){
      var data=  await dbHelper.getJournalData();
      debugPrint("the database data is $data");
      if(data!=null){
        db=data;
        setState(() {

        });
      }
    }


  }

@override
  void initState() {
    // TODO: implement initState
  currency= 'USD';
  longShort="Long";
newcurrency=currencies[0];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 24, 21, 21) ,
        title: Text('Trade Calculator',style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
      Builder(
        builder: (context) {
          return Container(
            height: getHeight(context, 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF7600),
                  Color(0xFFFF7600),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                child: Container(
                  height: getHeight(context, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Widget for symbol selection
                        // ...
                    
                        Padding(
                          padding:  EdgeInsets.only(top: 20,left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Widgets for LONG inputs
                              // ...
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text('Symbol'),
                                  SizedBox(width: 10,),
                                  // Spacer(),
                                  Text(newcurrency,style:Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black)),
                                  //Spacer(),
                                  // SizedBox(width: 10,),
                                  IconButton(onPressed: (){
                                    showCurrencyDialog(context,()=>setState((){}));
                                  }, icon: Icon(Icons.edit))
                                ],
                              ),
                              InkWell(
                                  onTap: (){
                    
                                    setState(() {
                                      longShort="Long";
                                    });
                                  },
                                  child: customRadio(context,'Long',(longShort=="Long")?Colors.green:Colors.blueAccent))
                              // Widgets for SHORT inputs
                              // ...
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: EdgeInsets.only(right: 5,left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                // flex:1,
                                child: TextField(
                                  controller: _calender,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontWeight: FontWeight.normal),
                                    // border: OutlineInputBorder(),
                                    hintText: 'Select Date',
                                    errorText: _errorText.isNotEmpty ? _errorText : null,
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
                              //Spacer(),
                              //SizedBox(width: 20,),
                              InkWell(
                                  onTap: (){
                    
                                    setState(() {
                                      longShort="Short";
                                    });
                                    debugPrint("LongShort is $longShort");
                                  },
                                  child: customRadio(context,'Short',(longShort=="Short")?Colors.green:Colors.blueAccent))
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                    
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: entry,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                                      // border: OutlineInputBorder(),
                                      hintText: 'Entry Level',
                                      errorText: _errorText.isNotEmpty ? _errorText : null,
                                    ),
                                  ),
                                ),
                              ),
                              // Spacer(),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: lot,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),
                                      // border: OutlineInputBorder(),
                                      hintText: 'Lot Size',
                                      errorText: _errorText.isNotEmpty ? _errorText : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(child: customRadio(context,'Long')),
                        //       Expanded(child: customRadio(context,"Short"))
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: SL,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                                      // border: OutlineInputBorder(),
                                      hintText: 'Stop Loss',
                                      errorText: _errorText.isNotEmpty ? _errorText : null,
                                    ),
                                  ),
                                ),
                              ),
                              // Spacer(),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: profit,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),
                    
                                      // border: OutlineInputBorder(),
                                      hintText: 'Take Profit',
                                      errorText: _errorText.isNotEmpty ? _errorText : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontWeight: FontWeight.normal),
                                      // border: OutlineInputBorder(),
                                      hintText: 'Account Balance',
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                  flex: 1,
                                  child: Container())
                              // Expanded(
                              //   child: DropdownButton<String>(
                              //
                              //     items: ['Option 1', 'Option 2', 'Option 3']
                              //         .map((String value) {
                              //       return DropdownMenuItem<String>(
                              //         value: value,
                              //         child: Text(value),
                              //       );
                              //     }).toList(),
                              //     onChanged: (String ?newValue) {
                              //       // Handle dropdown value change
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // Widgets for account balance, risk, and reward inputs
                        // ...
                        SizedBox(
                          height: 150,
                          child: Padding(
                            padding: EdgeInsets.only(left: 50,right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Text('Risk',style: TextStyle(color: Colors.red,fontSize: 20),)),
                                   (riski!=null||riski!="")?Text(riski!): Center(child: Text('-',style: TextStyle(color: Colors.red,fontSize: 20))),
                                    if(riski==null||riski=="")   Center(child: Text('-',style: TextStyle(color: Colors.red,fontSize: 20))),
                                    if(riski==null||riski=="")  Center(child: Text('-',style: TextStyle(color: Colors.red,fontSize: 20))),
                                  ],
                                ),
                                Padding(
                                  padding:EdgeInsets.only(left: 40,right: 10),
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Text('Reward',style: TextStyle(color: Colors.green,fontSize: 20))),
                                   (rewardi!=null||rewardi!="")?Text(rewardi!):  Center(child: Text('-',style: TextStyle(color: Colors.green,fontSize: 20))),
                                    if(rewardi==null||rewardi=="")  Center(child: Text('-',style: TextStyle(color: Colors.green,fontSize: 20))),
                                    if(rewardi==null||rewardi=="") Center(child: Text('-',style: TextStyle(color: Colors.green,fontSize: 20))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: MediaQuery.of(context).size.height/3,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text('Risk:'),
                        //             Expanded(
                        //               child: TextField(
                        //                 keyboardType: TextInputType.number,
                        //                 decoration: InputDecoration(hintText: '% of Account Balance'),
                        //                 onChanged: (value) {},
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text('Reward:'),
                        //             Expanded(
                        //               child: TextField(
                        //                 keyboardType: TextInputType.number,
                        //                 decoration: InputDecoration(hintText: 'Potential Profit'),
                        //                 onChanged: (value) {},
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                            onPressed: () async{
                              //                         if (entry.text.isEmpty) {
                              //                           _errorText = 'Please provide some value';
                              //                         }
                              //                         else if(lot.text.isEmpty){
                              //                           _errorText = 'Please provide some value';
                              //                         }
                              //                         else if(SL.text.isEmpty){
                              //                           _errorText = 'Please provide some value';
                              //                         }
                              //                         else if(profit.text.isEmpty){
                              //                           _errorText = 'Please provide some value';
                              //                         }
                              //                         else if(_calender.text.isEmpty){
                              //                           _errorText = 'Please provide some value';
                              //                         }
                              //                         // Perform trade calculation logic
                              //                         // ...
                              //                         else{
                              //                           debugPrint("new entry data is $newcurrency,${_calender.text},${entry.text},${lot.text},${SL.text},${profit.text}");
                              //                           JournalData newEntry = JournalData(
                              //                               id: db.length+1,
                              //                               symbol: newcurrency,
                              //                               date: _calender.text,
                              //                               setup: "",
                              //                               entryLevel: entry.text,
                              //                               lotSize: lot.text,
                              //                               stoploss: SL.text,
                              //                               takeProfit: profit.text,
                              //                               images: jsonEncode([]),
                              //                               open: "Open",
                              //                               notes: "",
                              //                               hitby: ""
                              //                           );
                              //                           setState((){});
                              //
                              // // Insert the new entry into the database
                              //                           await dbHelper.insertJournalData(newEntry);
                              //                           List<JournalData> dat=  await dbHelper.getJournalData();
                              //                           await getdatabaseData();
                              //                           Navigator.pop(context);
                              //                           debugPrint("getdata is ${dat[0].date}");
                              //                         }
                              riskCalculation();
                            },
                            child: Text('Calculate',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget entryCard(){
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Widget for symbol selection
                // ...

                Padding(
                  padding:  EdgeInsets.only(top: 20,left: 5,right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Widgets for LONG inputs
                      // ...
                      Flexible(
                        flex:2,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text('Symbol'),
                            SizedBox(width: 10,),
                            // Spacer(),
                            Text(newcurrency,style:Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black)),
                            //Spacer(),
                            // SizedBox(width: 10,),
                            IconButton(onPressed: (){
                              showCurrencyDialog(context,()=>setState((){}));
                            }, icon: Icon(Icons.edit))
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: InkWell(
                              onTap: (){

                                setState(() {
                                  longShort="Long";
                                });
                              },
                              child: customRadio(context,'Long',(longShort=="Long")?Colors.green:Colors.blueAccent)))
                      // Widgets for SHORT inputs
                      // ...
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.only(right: 5,left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        // flex:1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _calender,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontWeight: FontWeight.normal),
                              // border: OutlineInputBorder(),
                              hintText: 'Select Date',
                              errorText: _errorText.isNotEmpty ? _errorText : null,
                            ),
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
                      //Spacer(),
                      //SizedBox(width: 20,),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                            onTap: (){

                              setState(() {
                                longShort="Short";
                              });
                              debugPrint("LongShort is $longShort");
                            },
                            child: customRadio(context,'Short',(longShort=="Short")?Colors.green:Colors.blueAccent)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(

                        child: TextField(
                          controller: entry,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.normal),
                            // border: OutlineInputBorder(),
                            hintText: 'Entry Level',
                            errorText: _errorText.isNotEmpty ? _errorText : null,
                          ),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextField(
                          controller: lot,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),
                            // border: OutlineInputBorder(),
                            hintText: 'Lot Size',
                            errorText: _errorText.isNotEmpty ? _errorText : null,
                           // contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Expanded(child: customRadio(context,'Long')),
                //       Expanded(child: customRadio(context,"Short"))
                //     ],
                //   ),
                // ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: SL,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.normal),
                            // border: OutlineInputBorder(),
                            hintText: 'Stop Loss',
                            errorText: _errorText.isNotEmpty ? _errorText : null,
                          ),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextField(
                          controller: profit,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),

                            // border: OutlineInputBorder(),
                            hintText: 'Take Profit',
                            errorText: _errorText.isNotEmpty ? _errorText : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: TextField(
                //           decoration: InputDecoration(
                //             hintStyle: TextStyle(fontWeight: FontWeight.normal),
                //             // border: OutlineInputBorder(),
                //             hintText: 'Account Balance',
                //           ),
                //         ),
                //       ),
                //       Spacer(),
                //       Expanded(
                //         child: DropdownButton<String>(
                //
                //           items: ['Option 1', 'Option 2', 'Option 3']
                //               .map((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //           onChanged: (String ?newValue) {
                //             // Handle dropdown value change
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Widgets for account balance, risk, and reward inputs
                // ...
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Center(child: Text('Risk:')),
                //           Center(child: Text('-')),
                //           Center(child: Text('-')),
                //           Center(child: Text('-')),
                //         ],
                //       ),
                //       VerticalDivider(
                //         thickness: 5.0, // Adjust thickness as needed
                //         color: Colors.black, // Adjust color as needed
                //       ),
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Center(child: Text('Risk:')),
                //           Center(child: Text('-')),
                //           Center(child: Text('-')),
                //           Center(child: Text('-')),
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   height: MediaQuery.of(context).size.height/3,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text('Risk:'),
                //             Expanded(
                //               child: TextField(
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(hintText: '% of Account Balance'),
                //                 onChanged: (value) {},
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text('Reward:'),
                //             Expanded(
                //               child: TextField(
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(hintText: 'Potential Profit'),
                //                 onChanged: (value) {},
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    onPressed: () async{
//                       if (entry.text.isEmpty) {
//                         _errorText = 'Please provide some value';
//                       }
//                       else if(lot.text.isEmpty){
//                         _errorText = 'Please provide some value';
//                       }
//                       else if(SL.text.isEmpty){
//                         _errorText = 'Please provide some value';
//                       }
//                       else if(profit.text.isEmpty){
//                         _errorText = 'Please provide some value';
//                       }
//                       else if(_calender.text.isEmpty){
//                         _errorText = 'Please provide some value';
//                       }
//                       // Perform trade calculation logic
//                       // ...
//                       else{
//                         debugPrint("new entry data is $newcurrency,${_calender.text},${entry.text},${lot.text},${SL.text},${profit.text}");
//                         JournalData newEntry = JournalData(
//                             id: db.length+1,
//                             symbol: newcurrency,
//                             date: _calender.text,
//                             setup: "",
//                             entryLevel: entry.text,
//                             lotSize: lot.text,
//                             stoploss: SL.text,
//                             takeProfit: profit.text,
//                             images: jsonEncode([]),
//                             open: "Open",
//                             notes: "",
//                             hitby: ""
//                         );
//                         setState((){});
//
// // Insert the new entry into the database
//                         await dbHelper.insertJournalData(newEntry);
//                         List<JournalData> dat=  await dbHelper.getJournalData();
//                         await getdatabaseData();
//                         Navigator.pop(context);
//                         debugPrint("getdata is ${dat[0].date}");
//                       }
                    //  riskCalculation();

                    },
                    child: Text('calculate',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }

  Widget customRadio(BuildContext context,String text,Color col){
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
              color:col,
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

  riskCalculation() async {
var ratio;
var pip_profit;
var pip_loss;
var risk;
var reward;
    String cur=newcurrency;
    var spl=cur.split("/")[0];
    var spl2=cur.split("/")[1];
    debugPrint("risk calculation is $spl and $spl2");
    
 if(spl2=="JPY" || spl=="JPY"||spl=="XAU"||spl=="XAG"){
   if(spl2=="JPY" || spl=="JPY"){
     ratio=((0.01/double.parse(entry.text))*(double.parse(lot.text)*100000));
     pip_profit=(double.parse(profit.text)-double.parse(entry.text))*100;
     pip_loss=(double.parse(entry.text)-double.parse(SL.text))*100;
     risk=ratio*pip_loss;
     reward=ratio*pip_profit;
     var data=await getCurrncies2();
     debugPrint("data from api $data");
     int aer=data["USD"];
     int aer2=data["$spl"];
     double curreRatio=aer/aer2;
     debugPrint('currency api $aer and $aer2 and $curreRatio and $ratio and $pip_profit and $pip_loss');
     risk*=curreRatio;
     reward*=curreRatio;
     riski=risk.toStringAsFixed(2);
     rewardi=reward.toStringAsFixed(2);
     setState(() {

     });
   }else if(spl=="XAU"){
     ratio=((0.01/double.parse(entry.text))*(double.parse(lot.text)*100));
     pip_profit=(double.parse(profit.text)-double.parse(entry.text))*100;
     pip_loss=(double.parse(entry.text)-double.parse(SL.text))*100;
     risk=ratio*pip_loss;
     reward=ratio*pip_profit;
     risk*=double.parse(entry.text);
     reward*=double.parse(entry.text);
     debugPrint("ratio is $ratio and $pip_profit and $pip_loss");
     riski=risk.toStringAsFixed(2);
     rewardi=reward.toStringAsFixed(2);
     setState(() {

     });
   }
   else{
     ratio=((0.01/double.parse(entry.text))*(double.parse(lot.text)*5000));
     pip_profit=(double.parse(profit.text)-double.parse(entry.text))*100;
     pip_loss=(double.parse(entry.text)-double.parse(SL.text))*100;
     risk=ratio*pip_loss;
     reward=ratio*pip_profit;
     risk*=double.parse(entry.text);
     reward*=double.parse(entry.text);
     debugPrint("ratio is $ratio and $pip_profit and $pip_loss");
     riski=risk.toStringAsFixed(2);
     rewardi=reward.toStringAsFixed(2);
     setState(() {

     });
   }

 }else{
   ratio=((0.0001/double.parse(entry.text))*(double.parse(lot.text)*100000));
   pip_profit=(double.parse(profit.text)-double.parse(entry.text))*10000;
   pip_loss=(double.parse(entry.text)-double.parse(SL.text))*10000;
   risk=ratio*pip_loss;
   reward=ratio*pip_profit;
   if(spl2=="USD"){
     risk=risk*double.parse(entry.text);
     reward=reward*double.parse(entry.text);
     // var data=await getCurrncies2();
     //
     // int aer=data["USD"];
     // double aer2=data["$spl"];
     // double curreRatio=aer/aer2;
     // debugPrint('currency api $aer and $aer2 and $curreRatio and $ratio and $pip_profit and $pip_loss');
     //    risk*=curreRatio;
     // reward*=curreRatio;
     riski=risk.toStringAsFixed(2);
     rewardi=reward.toStringAsFixed(2);
     setState(() {

     });
   }
   else
     if(spl!="USD" && spl2!="USD"){
     ///api
       var data=await getCurrncies2();
       debugPrint("data from api $data");
       int aer2=data["USD"];
       int aer=data["$spl"];
       double curreRatio=aer/aer2;
       debugPrint('currency api $aer');
       risk*=curreRatio;
       reward*=curreRatio;
       riski=risk.toStringAsFixed(2);
       rewardi=reward.toStringAsFixed(2);
       setState(() {

       });
    // if(spl2!="USD"){
    //   String aer=data["USD"];
    //   debugPrint('currency api $aer');
    // }
    //
   }

 }
  }
  }

