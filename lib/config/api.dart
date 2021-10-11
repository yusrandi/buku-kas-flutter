class Api {
  //* Creating instance constructor;
  static Api instance = Api();
  //* Base API URL
  static const domain = "http://192.168.1.3/irzaapi";
  static const baseURL = domain + "/public/api";
  // static const baseURL = "http://mbc.lp2muniprima.ac.id/api";
  // static const imageURL = "http://mbc.lp2muniprima.ac.id/storage/app/public/produk_photo";

  String loginURL = "$baseURL/login";
  String registerURL = "$baseURL/register";
  String categoryURL = "$baseURL/categories";
  String transactionURL = "$baseURL/transaction";
  String userURL = "$baseURL/user";
  String usercategoryURL = "$baseURL/usercategory";
}
