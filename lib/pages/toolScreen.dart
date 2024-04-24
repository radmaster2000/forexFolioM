import 'package:flutter/material.dart';
import 'package:fx_journal/pages/tradeCalculator.dart';

import '../utils/utilities.dart';
import 'account.dart';
import 'compundingCalculator.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Color.fromARGB(255, 24, 21, 21),
        title: const Text('My Journal',style: TextStyle(color: Colors.white)),
        actions: [IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen(),));
        }, icon: Icon(Icons.account_circle))],
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
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: ( ) {
                  //
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TradeCalculatorScreen(),));
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white30,
                      borderRadius: BorderRadius.circular(20)
                    ),
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width/1.2,
                      child: Center(child: Text("Trade Calculator",style: Theme.of(context).textTheme.headlineMedium))),
                ),
              ),
            ),
          ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: InkWell(
            onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoumpoundingCalculator(),));
                  },
                    child: Card(
                      elevation: 5,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          height: MediaQuery.of(context).size.height/3,
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Center(child: Text("Compounding Calculator",style: Theme.of(context).textTheme.headlineMedium))),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
