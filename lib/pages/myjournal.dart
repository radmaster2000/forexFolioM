import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../MODELS/database.dart';
import '../utils/config.dart';
import '../utils/utilities.dart';
import 'account.dart';
import 'openTrade.dart';

class MyJournal extends StatefulWidget {
  const MyJournal({super.key});

  @override
  State<MyJournal> createState() => _MyJournalState();
}

class _MyJournalState extends State<MyJournal> {
  List currencies=[];
  List <Trade>weekDays=[];
  var _selectedDate = DateTime.now();
  final List<String> currency = [
    'EUR/USD', // Euro/US Dollar
    'USD/JPY', // US Dollar/Japanese Yen
    'GBP/USD', // British Pound Sterling/US Dollar
    'USD/CHF', // US Dollar/Swiss Franc
    'AUD/USD', // Australian Dollar/US Dollar
    'USD/CAD', // US Dollar/Canadian Dollar
    'NZD/USD', // New Zealand Dollar/US Dollar
    'EUR/GBP', // Euro/British Pound Sterling
    'EUR/JPY', // Euro/Japanese Yen
    'GBP/JPY', // British Pound Sterling/Japanese Yen
    'AUD/JPY', // Australian Dollar/Japanese Yen
    'EUR/AUD', // Euro/Australian Dollar
    // Add more currency pairs as needed
  ];
  TextEditingController _calender=TextEditingController();
  TextEditingController entry=TextEditingController();
  TextEditingController lot=TextEditingController();
  TextEditingController SL=TextEditingController();
  TextEditingController profit=TextEditingController();
  TextEditingController balance=TextEditingController();
  String _errorText = '';
  String longShort='';
String selectCurrency='';
String newcurrency='';
  DatabaseHelper dbHelper = DatabaseHelper();
  List <JournalData>db=[];
  List<AccountData> acc=[];
  List<bool> isShow=[];
  getdatabaseData()async{
    var account=await dbHelper.getAccountData();
    acc=account;
    debugPrint("account is $acc");
    if(account!=null){
      var data=  await dbHelper.getJournalData();

      debugPrint("the database data is $data");
      if(data!=null){
        db=data;
        var data2=await dbHelper.getWeekTrade();
        if(data2!=null){
          weekDays=data2;
        }
      //  debugPrint("data2 ${data2[0].startDate}and ${data2[0].endDate}");
        setState(() {
        });
      }
    }


  }
  @override
  void initState() {
    //getCurrencyData();
    newcurrency=currency[0];
    selectCurrency="USD";
    // TODO: implement initState
    longShort="Long";
    getdatabaseData();
    super.initState();
  }

  getCurrencyData()async{
    currencies=await getCurrency();
    // currencies = data.map((currency) => DropdownMenuItem(
    //   value: currency, // Assuming `currency` is a String
    //   child: Text(currency["currencyName"]),
    // )).toList();
    selectCurrency=currency[0];
    print("resulkt is $currencies");
  }
  void showCurrencyDialog(BuildContext context,Function fn) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: Scrollbar(
            child: ListView.builder(
              itemCount: currency.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(currency[index]),
                  onTap: () {
                    newcurrency=currency[index];
                    fn();
                    // Handle the selection of the tapped currency
                    Navigator.pop(context, currency[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Color.fromARGB(255, 24, 21, 21),
        title: const Text('My Journal',style: TextStyle(color: Colors.white),),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen(),));
        }, icon: Icon(Icons.account_circle))],
      ),
     // backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
              if(acc.isEmpty){
                showDialog(context: context, builder: (context) =>contentBox(context) ,);
              }

        else{
                _selectedDate=DateTime.now();
                SL.clear();
                lot.clear();
                profit.clear();
                entry.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.all(10),
                child: entryCard(),
              );
            },
          );
              }
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: getHeight(context,1),
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
        child: GridView.builder(
          itemCount: weekDays.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OpenTrade(startday:DateFormat('dd-MM-yyyy').format(weekDays[index].startDate),endDay: DateFormat('dd-MM-yyyy').format(weekDays[index].endDate), ),));
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Adjust color and opacity as needed
                      spreadRadius: 2, // Adjust spread and blur for desired effect
                      blurRadius: 5,
                      offset: Offset(0, 3), // Adjust offset for shadow position
                    ),
                  ],
                  // ...other decoration properties
                ),
                child: Card(
                  elevation: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(db[index].symbol,style: Theme.of(context).textTheme.headlineSmall,),
                            Icon(Icons.do_not_disturb_on_total_silence,color: Colors.green,size: 10,)
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(DateFormat('dd-MM-yyyy').format(weekDays[index].startDate),style: Theme.of(context).textTheme.headlineMedium),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(DateFormat('dd-MM-yyyy').format(weekDays[index].startDate)),
                      ),
                      Text('-'),
                      Text(DateFormat('dd-MM-yyyy').format(weekDays[index].endDate)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },),
      ),
    );
  }
Widget entryCard(){
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.8,
       decoration: BoxDecoration(
           color: Colors.white,
         borderRadius: BorderRadius.circular(20)
       ),
       // height: MediaQuery.of(context).size.height / 2,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Widget for symbol selection
                // ...
                Padding(
                  padding: EdgeInsets.only(top: 20,left: 5,right: 5),
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
                            //SizedBox(width: 10,),
                           // Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(newcurrency,style:Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black)),
                            ),
                            //Spacer(),
                           // SizedBox(width: 10,),
                            IconButton(onPressed: (){
                              showCurrencyDialog(context,()=>setState((){}));
                            }, icon: Icon(Icons.edit))
                          ],
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: InkWell(
                              onTap: (){

                                setState(() {
                                  longShort="Long";
                                });
                              },
                              child: customRadio(context,'BUY',(longShort=="Long")?Colors.green:Colors.blueAccent,(longShort=="Long")?Colors.grey:Colors.blue)))
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
                      Flexible(
                        flex: 1,
                        child: InkWell(
                            onTap: (){

                              setState(() {
                                longShort="Short";
                              });
                              debugPrint("LongShort is $longShort");
                            },
                            child: customRadio(context,'SELL',(longShort=="Short")?Colors.green:Colors.blueAccent,(longShort=="Short")?Colors.grey:Colors.blue)),
                      )
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

                        child: TextField(
                          controller: entry,
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontWeight: FontWeight.normal,textBaseline: TextBaseline.ideographic),
                            // border: OutlineInputBorder(),
                            hintText: 'Lot Size',
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                    onPressed: () async{
                      if (entry.text.isEmpty) {
                        _errorText = 'Please provide some value';
                      }
                      else if(lot.text.isEmpty){
                        _errorText = 'Please provide some value';
                      }
                      else if(SL.text.isEmpty){
                        _errorText = 'Please provide some value';
                      }
                      else if(profit.text.isEmpty){
                        _errorText = 'Please provide some value';
                      }
                      else if(_calender.text.isEmpty){
                        _errorText = 'Please provide some value';
                      }
                      // Perform trade calculation logic
                      // ...
                      else{
                        debugPrint("new entry data is $newcurrency,${_calender.text},${entry.text},${lot.text},${SL.text},${profit.text}");
                        JournalData newEntry = JournalData(
                            id: db.length+1,
                            symbol: newcurrency,
                            date: _calender.text,
                            setup: "",
                            entryLevel: entry.text,
                            lotSize: lot.text,
                            stoploss: SL.text,
                            takeProfit: profit.text,
                            images: null,
                            open: "Open",
                          notes: "",
                          hitby: "",
                            longShort: longShort
                        );
                        debugPrint("dateformat is ${DateFormat('dd-MM-yyyy').format(_selectedDate)}");
                        DateTime date=   DateTime.parse(DateFormat('yyyy-MM-dd').format(_selectedDate));
                        DateTime monday = date.subtract(Duration(days: date.weekday - 1));
                        DateTime friday = monday.add(Duration(days: 4));
                        debugPrint("dateformat is $date and $mounted and $friday");
                        Trade trade=Trade(startDate: monday ,
                            endDate: friday);
                        setState((){});
                      //  debugPrint("trade weekday is ${DateFormat('dd-MM-yyyy').format(trade)}");
                  // Insert the new entry into the database
                        await dbHelper.insertJournalData(newEntry);
                        await dbHelper.insertWeekTrade(trade);
                        List<JournalData> dat=  await dbHelper.getJournalData();
                        await getdatabaseData();
                        Navigator.pop(context);
                        debugPrint("getdata is ${dat[0].date}");
                      }

                    },
                    child: Text('Submit',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },);
}
  Widget customRadio(BuildContext context,String text,Color col,Color border){
    return Card(
      elevation: 10,
      child: new Container(
        //height: 50.0,
        width: MediaQuery.of(context).size.width/3,
        child: new Center(
          child: new Text(text,
              style: new TextStyle(
                  color:
                 Colors.white,
                  //fontWeight: FontWeight.bold,
                  //fontSize: 18.0
              )),
        ),
        decoration: new BoxDecoration(
          color:col,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5), // Shadow color
          //     spreadRadius: 5, // Spread radius
          //     blurRadius: 7, // Blur radius
          //     offset: Offset(0, 3), // Offset
          //   ),
          // ],
          border: new Border.all(
              width: 2.0,
              color:border),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
      ),
    );
  }
  Widget contentBox(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
        //color: Color(0xFF9B75DA),
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.5,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Starting Balance',style: Theme.of(context).textTheme.headlineSmall,),
                      // First Row
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date',style:Theme.of(context).textTheme.titleMedium),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _calender,
                                decoration: InputDecoration(
                                  hintStyle:Theme.of(context).textTheme.titleSmall,
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
                      ),
                      SizedBox(height: 10),

                      // Second Row
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Base currency',style:Theme.of(context).textTheme.titleMedium),
                            //SizedBox(width: 10),
                            // Expanded(
                            //   flex: 2,
                            //   child: Container(
                            //     constraints: BoxConstraints(maxWidth: 200),
                            //     child: DropdownButton<String>(
                            //      // value: selectCurrency,
                            //       items:  currencies.map((map) {
                            //         // Choose the key you want to use for value and text (dynamic or String?)
                            //         return DropdownMenuItem<String>(
                            //           value: selectCurrency,
                            //           // Example using an 'id' key
                            //           child: Text(map['currencyName'].toString(),style: TextStyle(color: Colors.black),), // Example using a 'name' key
                            //         );
                            //       }).toList(),
                            //       onChanged: (String ?newValue) {
                            //         setState(() {
                            //           selectCurrency=newValue!;
                            //       debugPrint("selectcurrency is $selectCurrency");
                            //         });                              // Handle dropdown value change
                            //       },
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: selectCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectCurrency = newValue!;
                                    });
                                  },
                                  items: [
                                    'USD', // United States Dollar
                                    'EUR', // Euro
                                    'JPY', // Japanese Yen
                                    'GBP', // British Pound Sterling
                                    'AUD', // Australian Dollar
                                    'CAD', // Canadian Dollar
                                    'CHF', // Swiss Franc
                                    'NZD', // New Zealand Dollar
                                    'CNY', // Chinese Yuan Renminbi
                                    'SEK', // Swedish Krona
                                    'NOK', // Norwegian Krone
                                    'KRW', // South Korean Won
                                    'SGD', // Singapore Dollar
                                    'HKD', // Hong Kong Dollar
                                    'MXN', // Mexican Peso
                                  ]
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),

                      // Third Textfield
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: TextField(
                          controller: balance,
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            hintText: 'Enter balance',
                            hintStyle:Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: ()async {
                              AccountData newEntry = AccountData(
                                  id: db.length+1,
                                  currency:selectCurrency ,
                                balance:double.parse(balance.text) ,
                                date:_calender.text
                              );

                              AccountHistory history=AccountHistory(amount: double.parse(balance.text), name: "Initial Depopsit", date: _calender.text,total:double.parse(balance.text) );
                              setState((){});

// Insert the new entry into the database
                              await dbHelper.insertAccountData(newEntry);
                              await dbHelper.insertAccounthistory(history);
                              List<AccountData> dat=  await dbHelper.getAccountData();

                              await getdatabaseData();
                              Navigator.pop(context);
                              debugPrint("getdata is ${dat[0].date}");

                              //Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }



}
