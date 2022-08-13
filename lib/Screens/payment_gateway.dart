import 'package:eclass/common/global.dart';
import 'package:eclass/gateways/paypal/PaypalPayment.dart';
import 'package:eclass/gateways/paypal/paypal_screen.dart';
import 'package:eclass/gateways/stripe_payment.dart';
import 'package:eclass/provider/user_profile.dart';

import '../Widgets/utils.dart';
import '../gateways/bank_payment.dart';
import '../gateways/paystack_payment.dart';
import '../gateways/paytm_payment_page.dart';
import '../gateways/razor_payments.dart';
import '../model/home_model.dart';
import '../provider/home_data_provider.dart';
import '../provider/payment_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class PaymentGateway extends StatefulWidget {
  final int tAmount;
  final disCountedAmount;

  PaymentGateway(this.tAmount, this.disCountedAmount);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  int value;
  var payAbleAmount;

  List<String> gateways = [
    "RazorPay",
    "PayStack",
    "Stripe",
    "Paytm",
    "Bank Transfer",
    "Paypal"
  ];

  List<String> wallets = [
    "assets/placeholder/razorpay.png",
    "assets/placeholder/paystackwallets.png",
    "assets/placeholder/stripe.png",
    "assets/placeholder/paytm.png",
    "assets/placeholder/bankwallets.png",
    "assets/placeholder/paypal.png"
  ];

  Widget gateWayTile(int idx) {
    return Row(
      children: [
        Container(
          height: 65,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(wallets[idx]),
              ),
              borderRadius: BorderRadius.circular(15)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            gateways[idx],
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget bottomFixed(payment, user) {
    var homeData = Provider.of<HomeDataProvider>(context);
    return InkWell(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: Offset(0.0, -20.5),
              spreadRadius: -15.0)
        ]),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(12.0),
          height: 50.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6E1A52),
                    Color(0xFFF44A4A),
                  ]),
              borderRadius: BorderRadius.circular(15.0)),
          child: Text(
            "Total Amount to be Paid : ${payAbleAmount.toString()} >>",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
      onTap: () {
        if (value == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyRazorPaymentPage(
                  amount: payAbleAmount,
                ),
              ));
        } else if (value == 1) {
          if ("${homeData.homeModel.currency}" == "NGN") {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: PayStackPage(
                  amount: payAbleAmount,
                ),
              ),
            );
          } else {
            Fluttertoast.showToast(msg: "Supported only NGN currency");
          }
        } else if (value == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    StripePaymentScreen(amount: payAbleAmount),
              ));
        } else if (value == 3) {
          Fluttertoast.showToast(msg: "Supported only live mode");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => PaytmPaymentPage(amount: payAbleAmount),
          //     ));
        } else if (value == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BankPayment(),
              ));
        } else if (value == 5) {
         onPayWithPayPal(homeData, user);
        } else {
          Fluttertoast.showToast(msg: "Please select payment gateway");
        }
      },
    );
  }

  void onPayWithPayPal(homeData, user){
    currency = homeData.homeModel.currency.currency;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalPayment(
          onFinish: (number) async {
            print('order id: '+number);
          },
          currency: currency, userFirstName: user.profileInstance.fname,
          userLastName: user.profileInstance.lname,
          userEmail: user.profileInstance.email,
          payAmount: "$payAbleAmount",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    payAbleAmount = widget.disCountedAmount;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PaymentAPIProvider paymentAPIProvider =
          Provider.of<PaymentAPIProvider>(context, listen: false);
      await paymentAPIProvider.fetchPaymentAPI(context);
    });
  }

  List<bool> getGatewaysStatus(Settings sett) {
    List<bool> status = [false, false, false, true];
    if (sett.razorpayEnable == "1" || sett.razorpayEnable == 1)
      status[0] = true;
    if (sett.paystackEnable == "1" || sett.paystackEnable == 1)
      status[1] = true;
    if (sett.paytmEnable == "1" || sett.paytmEnable == 1) status[2] = true;
    return status;
  }

  Widget listsOfGateways() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 90,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: index == 0
                  ? BorderSide(width: 1, color: Colors.grey.withOpacity(0.4))
                  : BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
          child: RadioListTile(
            activeColor: const Color(0xFF0284A2),
            value: index,
            groupValue: value,
            onChanged: (ind) {
              setState(() => value = ind);
            },
            title: gateWayTile(index),
          ),
        );
      },
      itemCount: gateways.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var payment = Provider.of<PaymentAPIProvider>(context).paymentApi;
    var user = Provider.of<UserProfile>(context);
    return Scaffold(
        appBar:
            secondaryAppBar(Colors.black, mode.bgcolor, context, "Checkout"),
        backgroundColor: mode.bgcolor,
        bottomNavigationBar: bottomFixed(payment, user),
        body: payment == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listsOfGateways());
  }
}
