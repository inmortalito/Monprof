import 'dart:convert';
import 'dart:io';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/payment_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaytmPaymentPage extends StatefulWidget {
  final int amount;
  PaytmPaymentPage({Key key, this.amount}) : super(key: key);

  @override
  _PaytmPaymentPageState createState() => _PaytmPaymentPageState();
}

class _PaytmPaymentPageState extends State<PaytmPaymentPage> {
  String paymentResponse = '';
  bool isBack = false;
  bool isShowing = false;
  var razorResponse;
  var msgResponse;
  var razorSubscriptionResponse;
  var ind;
  var createdDate;
  var createdTime;

  Widget payButtonRow() {
    var payment = Provider.of<PaymentAPIProvider>(context);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            onPressed: () {
              if (payment.paymentApi.paytmMerchantKey == null) {
                Fluttertoast.showToast(msg: "Paytm key not entered.");
                return;
              } else {
                generateCheckSum();
              }
            },
            color: Color.fromRGBO(72, 163, 198, 1.0),
            child: Text(
              "Continue Pay",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Paytm Payment"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              generateCheckSum();
            },
            child: Text("Pay Now"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isBack = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Color(0xFF3F4654)),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }

  void generateCheckSum() async {
    var url =
        'https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum';

    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    //Please use your parameters here
    //CHANNEL_ID etc provided to you by paytm

    final response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "mid": "ParloS79006455919746",
      "CHANNEL_ID": "WAP",
      'INDUSTRY_TYPE_ID': 'Retail',
      'WEBSITE': 'APPSTAGING',
      'PAYTM_MERCHANT_KEY': '380W#7mf&_SpEgsy',
      'TXN_AMOUNT': '10',
      'ORDER_ID': orderId,
      'CUST_ID': '122',
      'testing': '0'
    });

    //for Testing(Stagging) use this

    //https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=

    //https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=

    //Parameters are like as per given below

    // Testing (Staging or Production) if true then Stagginh else Production
    // MID provided by paytm
    // ORDERID your system generated order id
    // CUSTOMER ID
    // CHANNEL_ID provided by paytm
    // AMOUNT
    // WEBSITE provided by paytm
    // CallbackURL (As used above)
    // INDUSTRY_TYPE_ID provided by paytm
    // checksum generated now
    //Testing Credentials
    //Mobile number: 7777777777
    //OTP: 489871

//    var paytmResponse = Paytm.startPaytmPayment(
//      true,
//      "ParloS79006455919746",
//      orderId,
//      "122",
//      "WAP",
//      "10",
//      'APPSTAGING',
//      callBackUrl,
//      'Retail',
//      response.body,
//    );
//
//    paytmResponse.then((value) {
//      setState(() {
//        paymentResponse = value.toString();
//      });
//    });
//
//    paytmResponse.then((value) {
//      setState(() {
//        paymentResponse = value.toString();
//        if(value['RESPCODE'] == "01"){
//          setState(() {
//            isShowing = true;
//            isBack = false;
//          });
//        sendPaymentDetails(value['ORDERID'], "Paytm");
//        }else{
//          Fluttertoast.showToast(msg: "Payment Failed contact to support");
//        }
//      });
//    });
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "Your transaction successful",
                      purchaseDate: subdate,
                      time: time,
                      transactionAmount: widget.amount,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBottomNavigationBar(
                                      pageInd: 0,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {
      final sendResponse =
          await http.post("${APIData.payStore}${APIData.secretKey}", body: {
        "transaction_id": "$transactionId",
        "payment_method": "$paymentMethod",
        "pay_status": "1",
        "sale_id": "null",
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      });
      paymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200) {
        setState(() {
          isShowing = false;
        });

        goToDialog2();
        goToDialog(createdDate, createdTime);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
  }
}
