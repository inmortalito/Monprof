import 'dart:convert';
import '../common/apidata.dart';
import '../model/payment_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class PaymentAPIProvider with ChangeNotifier {
  PaymentApi paymentApi = PaymentApi();

  Future<PaymentApi> fetchPaymentAPI(context) async {
    Response res = await get("${APIData.paymentGatewayKeys}${APIData.secretKey}");
    if (res.statusCode == 200) {
      paymentApi = PaymentApi.fromJson(json.decode(res.body));
    } else {
      throw "Can't get payment API keys";
    }
    notifyListeners();
    return paymentApi;
  }
}
