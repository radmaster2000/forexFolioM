import 'dart:math';

import 'package:flutter/material.dart';

class CoumpoundingCalculator extends StatefulWidget {
  @override
  _CoumpoundingCalculatorState createState() => _CoumpoundingCalculatorState();
}

class _CoumpoundingCalculatorState extends State<CoumpoundingCalculator> {
  double startingBalance = 0.0;
  String period = 'Yearly';
  double growthRate = 0.0;
  int year=0;
  int month=0;
  double monthlyDeposit = 0.0;
  double futureValue = 0.0;
  String deposit="None";
  String end="End";
  List future=[];
  List interest=[];
  List accruedInterest=[];
   calculateCompoundInterest(double principal, double rate, int years,double monthly,int monthchoosen) {
    // Calculate compound interest without regular deposits
    if(deposit=="None"){
      double futureValue = principal * pow(1 + rate /12 , years*12);
       double r=rate/100;
      // Calculate future value of regular deposits
      for (int i = 0; i <= years; i++) {
        debugPrint('running $principal and $rate and ');
        future.add((principal * pow(1 + r / 12, i*12)));
        //  futureValue += deposit * pow(1 + rate / 100, i);
      }
    }
    else if(deposit=="Deposit"){
      if(end=="End"){
        ///-----------------end----------
        double accruedInterest=0.0;
        double firstFuture=0.0;
        double futureValue=principal;
        //double yearEndValue = principal;
        double r=rate/100;
        List<double> yearEndValue = List.filled(11, 0.0); // List to store year-end values (11 elements for 10 years)
             /// month <= years*12+monthchoosen
        for (int month = 1; month <= years*12; month++) {
          // Calculate interest earned on current balance
          firstFuture=futureValue;
          debugPrint("Now the interest is $firstFuture");
          //debugPrint("in end ist $futureValue");
          futureValue += futureValue * r/12;

          // Add monthly investment
          futureValue += monthly;

          // Update year-end value (assuming year starts in January)
       /// commented   month == years*12+monthchoosen
          if (month % 12 == 0 ) {
            debugPrint("In end $futureValue and ${(firstFuture*r/12)/12} and $firstFuture aND $principal");
            yearEndValue[month ~/ 12 - 1] = futureValue;
          }
        }

        // Print year-end values
        for (int year = 0; year < 10; year++) {
          print("Year ${year + 1}: \$%.2f${ yearEndValue[year]}");
          future.add(yearEndValue[year]);
        }
      }
      else{
        ///-----------------begiinning-----------

        double r=rate/100;
       // double fut = principal;
        double monthlyInterestRate = r/ 12; // Monthly interest rate
        int totalMonths = years * 12; // Total number of months
        double monthlyInvestment = monthly;
        double futureValue = principal;

        for (int month = 1; month <= totalMonths; month++) {
          futureValue += monthlyInvestment;
          futureValue += futureValue * monthlyInterestRate;
          if (month % 12 == 0) {
           future.add(futureValue);
          }

        }
      }
    }
setState(() {

});
   // return futureValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF7600),
      appBar: AppBar(
        title: Text('Compounding Calculator',style: TextStyle(color: Colors.white)),
        backgroundColor:Color.fromARGB(255, 24, 21, 21),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Starting Balance:',style: Theme.of(context).textTheme.titleMedium),
               // SizedBox(width: 10.0),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                        Icons.currency_exchange
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                  ),
            
                  keyboardType: TextInputType.number,
                  onChanged: (value) => startingBalance = double.parse(value),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(

                          children: [
                            Text('Interest Rate:',style: Theme.of(context).textTheme.titleMedium),
                            //SizedBox(width: 10.0),
                            TextField(
                              decoration: InputDecoration(

                                filled: true,
                                suffixIcon: Icon(Icons.percent),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                              ),

                              keyboardType: TextInputType.number,
                              onChanged: (value) => growthRate = double.parse(value),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Text('Period:',style: Theme.of(context).textTheme.titleMedium),
                            //SizedBox(width: 10.0),
                            Container(
                            //  padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),

                              ),
                              child: DropdownButton<String>(
                                  value: period,
                                  elevation: 5,
                                  underline: SizedBox.shrink(),
                                  borderRadius: BorderRadius.circular(10),
                                  items: <DropdownMenuItem<String>>[
                                    DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                                    DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                                    DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                                    DropdownMenuItem(value: 'Quarterly', child: Text('Quarterly')),
                                  ],
                                  onChanged: (value) {
                                    period=value!;
                                    setState(() {

                                    });                    }

                              ),
                            ),
                          ],
                            crossAxisAlignment: CrossAxisAlignment.start
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(

                          children: [
                            Text('Year',style: Theme.of(context).textTheme.titleMedium),
                            //SizedBox(width: 10.0),
                            TextField(
                              decoration: InputDecoration(

                                filled: true,
                                //suffixIcon: Icon(Icons.percent),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                              ),

                              keyboardType: TextInputType.number,
                              onChanged: (value) => year = int.parse(value),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      SizedBox(width: 2,),
                      Flexible(
                        child: Column(

                          children: [
                            Text('Months',style: Theme.of(context).textTheme.titleMedium),
                            //SizedBox(width: 10.0),
                            TextField(
                              decoration: InputDecoration(

                                filled: true,
                               // suffixIcon: Icon(Icons.percent),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                              ),

                              keyboardType: TextInputType.number,
                              onChanged: (value) => month = int.parse(value),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
            
            SizedBox(height: 20,),
                Divider(thickness: 2,),
                Padding(
                  padding:  EdgeInsets.only(top: 10),
                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(thickness: 2,),
                      Text("Additional contributions:(optional)",style: Theme.of(context).textTheme.titleMedium),
                      Divider(thickness: 5,)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  InkWell(
                      onTap: (){
                        setState(() {
                          deposit="None";
                        });
                      },
                      child: Chip(label: Text("None",style:TextStyle(color: (deposit=="None")?Colors.white:Colors.black),),color: MaterialStatePropertyAll((deposit=="None")?Colors.black:Colors.white),)),

                  InkWell(
            
                      onTap: (){
                        setState(() {
                          deposit="Deposit";
                        });                    },
                      child: Chip(label: Text("Deposit",style:TextStyle(color: (deposit=="Deposit")?Colors.white:Colors.black)),color:  MaterialStatePropertyAll((deposit=="Deposit")?Colors.black:Colors.white),))
                    ,InkWell(
                        onTap: (){
                          setState(() {
                            deposit="Withdrawal";
                          });
                        },
                        child: Chip(label: Text("Withdrawal",style:TextStyle(color: (deposit=="Withdrawal")?Colors.white:Colors.black),),color:  MaterialStatePropertyAll((deposit=="Withdrawal")?Colors.black:Colors.white),)),
                ],),

                if(deposit!="None")  Padding(
                  padding:  EdgeInsets.only(top: 10),
                  child: Text('Deposit Amount:(optional)',style: Theme.of(context).textTheme.titleMedium),
                ),
              //  if(deposit!="None")  SizedBox(width: 10.0),
                if(deposit!="None")  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => monthlyDeposit = double.parse(value),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 10),
                  child: Text("Deposits made at what point of Time",style: Theme.of(context).textTheme.titleMedium),
                ),
                if(deposit!="None")  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // InkWell(
                    //     onTap: (){
                    //       setState(() {
                    //         deposit="None";
                    //       });
                    //     },
                    //     child: Chip(label: Text("None",style:TextStyle(color: (deposit=="None")?Colors.white:Colors.black),),color: MaterialStatePropertyAll((deposit=="None")?Colors.black:Colors.white),)),

                    Padding(
                      padding:  EdgeInsets.only(right: 8),
                      child: InkWell(

                          onTap: (){
                            setState(() {
                              end="Beginning";
                            });                    },
                          child: Chip(label: Text("Beginning",style:TextStyle(color: (end=="Beginning")?Colors.white:Colors.black)),color:  MaterialStatePropertyAll((end=="Beginning")?Colors.black:Colors.white),)),
                    )
                    ,Padding(
                      padding:  EdgeInsets.only(left: 8),
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              end="End";
                            });
                          },
                          child: Chip(label: Text("End",style:TextStyle(color: (end=="End")?Colors.white:Colors.black),),color:  MaterialStatePropertyAll((end=="End")?Colors.black:Colors.white),)),
                    ),
                  ],),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
            
                        shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: (){
                          debugPrint("ruu");
                          future.clear();
                          calculateCompoundInterest(startingBalance,growthRate,year,monthlyDeposit,month);
                        },
                        color:  Colors.green,
                        child: Text('Calculate',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                    (future.isNotEmpty)?     ListView.builder(
            shrinkWrap: true,
            itemCount: future.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
                  return Center(child: Text(future[index].toStringAsFixed(2)));
                },):Container(
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
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget projectionValue( ){
     return Column(
       children: [
         Text("Projection for ${year.toString()} years "),
         Divider(),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
               Column(
                 children: [
                   Text("Future investment value"),
                   Text(startingBalance.toString()),
                 ],
               ),
               Column(
                 children: [
                   Text("Additional deposits"),
                   Text(monthlyDeposit.toString()),
                 ],
               )
             ],
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
               Column(
                 children: [
                   Text("Total interest earned"),
                   Text(growthRate.toString()),
                 ],
               ),
               Column(
                 children: [
                   Text("Interest rate (yearly)"),
                   Text(growthRate.toString()),
                 ],
               )
             ],
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
               Column(
                 children: [
                   Text("Initial balance"),
                   Text(startingBalance.toString()),
                 ],
               ),
               // Column(
               //   children: [
               //     Text(),
               //     Text(),
               //   ],
               // )
             ],
           ),
         ),
       ],
     );
  }



}
