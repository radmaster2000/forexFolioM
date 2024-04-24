import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../MODELS/database.dart';
import '../utils/utilities.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFFF7600),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        backgroundColor: Color.fromARGB(255, 24, 21, 21),
        title: Text('Account',style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        //height: getHeight(context,1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF7600),
              Color(0xFFFF7600),
              Color(0xFFFF7600),],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyCard(),
        ),
      ),
    );
  }
}
class MyCard extends StatefulWidget {
  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  TextEditingController balance=TextEditingController();

  TextEditingController _calender=TextEditingController();

  var _selectedDate = DateTime.now();

  DatabaseHelper dbHelper = DatabaseHelper();

  List <AccountHistory>accountData=[];

  @override
  void initState() {
    // TODO: implement initState
    getAccountData();
    super.initState();
  }
  getAccountData()async{
    var data= await dbHelper.getAccountHistoryData();
    debugPrint("accountData is ${data}");
    accountData=data;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Account Balance',
                  style: TextStyle(fontSize: 16),
                ),
              ),
             if(accountData.isNotEmpty) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  accountData.last.total.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) =>contentBox(context,"Deposit") ,);
                },
                child: Text(
                  'Deposit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) =>contentBox(context,"Withdrawal") ,);
                },
                child: Text(
                  'Withdrawal',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) =>historyDialog() ,);
                },
                child: Text(
                  'History',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget historyDialog(){
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding( padding: const EdgeInsets.all(8.0),child: Container(
         // width: MediaQuery.of(context).size.width/1.5,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Account History",style: Theme.of(context).textTheme.headlineSmall,),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: accountData.length,
                  itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(accountData[index].date),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(accountData[index].name),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(accountData[index].amount.toString()),
                      )
                    ],
                  );
                },)
              ],
            ),
          ),
        ), ),
      ),
    );
  }





  Widget contentBox(BuildContext context,String type) {
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
                      Text(type,style: Theme.of(context).textTheme.headlineSmall,),
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
                      // Padding(
                      //   padding: EdgeInsets.only(top: 5),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text('Base currency',style:Theme.of(context).textTheme.titleMedium),
                      //       //SizedBox(width: 10),
                      //       // Expanded(
                      //       //   flex: 2,
                      //       //   child: Container(
                      //       //     constraints: BoxConstraints(maxWidth: 200),
                      //       //     child: DropdownButton<String>(
                      //       //      // value: selectCurrency,
                      //       //       items:  currencies.map((map) {
                      //       //         // Choose the key you want to use for value and text (dynamic or String?)
                      //       //         return DropdownMenuItem<String>(
                      //       //           value: selectCurrency,
                      //       //           // Example using an 'id' key
                      //       //           child: Text(map['currencyName'].toString(),style: TextStyle(color: Colors.black),), // Example using a 'name' key
                      //       //         );
                      //       //       }).toList(),
                      //       //       onChanged: (String ?newValue) {
                      //       //         setState(() {
                      //       //           selectCurrency=newValue!;
                      //       //       debugPrint("selectcurrency is $selectCurrency");
                      //       //         });                              // Handle dropdown value change
                      //       //       },
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //       // Expanded(
                      //       //   child: Padding(
                      //       //     padding: const EdgeInsets.all(8.0),
                      //       //     child: DropdownButton<String>(
                      //       //       value: selectCurrency,
                      //       //       onChanged: (String? newValue) {
                      //       //         setState(() {
                      //       //           selectCurrency = newValue!;
                      //       //         });
                      //       //       },
                      //       //       items: [
                      //       //         'USD', // United States Dollar
                      //       //         'EUR', // Euro
                      //       //         'JPY', // Japanese Yen
                      //       //         'GBP', // British Pound Sterling
                      //       //         'AUD', // Australian Dollar
                      //       //         'CAD', // Canadian Dollar
                      //       //         'CHF', // Swiss Franc
                      //       //         'NZD', // New Zealand Dollar
                      //       //         'CNY', // Chinese Yuan Renminbi
                      //       //         'SEK', // Swedish Krona
                      //       //         'NOK', // Norwegian Krone
                      //       //         'KRW', // South Korean Won
                      //       //         'SGD', // Singapore Dollar
                      //       //         'HKD', // Hong Kong Dollar
                      //       //         'MXN', // Mexican Peso
                      //       //       ]
                      //       //           .map<DropdownMenuItem<String>>((value) {
                      //       //         return DropdownMenuItem<String>(
                      //       //           value: value.toString(),
                      //       //           child: Text(value.toString()),
                      //       //         );
                      //       //       }).toList(),
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
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
                              // AccountData newEntry = AccountData(
                              //     id: db.length+1,
                              //     currency:selectCurrency ,
                              //     balance:double.parse(balance.text) ,
                              //     date:_calender.text
                              // );

                              AccountHistory history=AccountHistory(amount: double.parse(balance.text), name: type=="Deposit"?"Deposit":"Withdrawal", date: _calender.text,total:accountData.last.total+double.parse(balance.text) );
                              setState((){});

// Insert the new entry into the database
                              await dbHelper.insertAccounthistory(history);
                              setState((){
                                getAccountData();
                              });
                              //List<AccountData> dat=  await dbHelper.getAccountData();

                             // await getdatabaseData();
                              Navigator.pop(context);
                              //debugPrint("getdata is ${dat[0].date}");

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
