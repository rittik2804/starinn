import 'package:flutter/material.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/screens/discovery/discovery.dart';
import 'package:listar_flutter_pro/utils/translate.dart';

import '../blocs/app_bloc.dart';
import '../models/model_webview.dart';

class DrawerWidget extends StatefulWidget {
  // @override
  // State<DrawerWidget> createState() => _DrawerWidgetState();
  @override
  _DrawerWidgetState createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    List<MenuModel> items = [
      MenuModel(
          onTap: () async {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Discovery();
              },
            )
                // arguments: route,
                );
          },
          title: "Properties",
          imageIcon: "assets/images/property.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.category,
            );
          },
          title: "Cities",
          imageIcon: "assets/images/city.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('payment'),
                  url: "https://rzp.io/l/Of0wJQI5",
                ));
          },
          title: "Payments",
          imageIcon: "assets/images/payment.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('Contact Us'),
                  url: "https://cloud.starinnsuitesandretreat.com/forms/ticket",
                ));
          },
          title: "Contact Us",
          imageIcon: "assets/images/contactus.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('Login'),
                  url: "https://cloud.starinnsuitesandretreat.com/",
                ));
          },
          title: "Login",
          imageIcon: "assets/images/login.png")
    ];

    List<MenuModel> itemsAbout = [
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('About Us'),
                  url:
                      "https://cloud.starinnsuitesandretreat.com/knowledge-base/article/about-us",
                ));
          },
          title: "About Us",
          imageIcon: "assets/images/payment.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('Terms & Conditions'),
                  url:
                      "https://cloud.starinnsuitesandretreat.com/knowledge-base/article/terms-conditions",
                ));
          },
          title: "Terms & Conditions",
          imageIcon: "assets/images/contactus.png"),
      MenuModel(
          onTap: () {
            Navigator.pushNamed(context, Routes.webView,
                arguments: WebViewModel(
                  title: Translate.of(context).translate('Privacy Policy'),
                  url:
                      "https://cloud.starinnsuitesandretreat.com/knowledge-base/article/privacy-policy",
                ));
          },
          title: "Privacy Policy",
          imageIcon: "assets/images/login.png")
    ];

    return SafeArea(
        child: Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        // color: Colors.red,
        // width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                  color: Theme.of(context).disabledColor),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      Images.menuIcon,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  Image.asset(
                    Images.walkthrouLogo,
                    height: 112,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.66,
              padding: EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: items[index].onTap,
                          child: Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage(items[index].imageIcon ?? ''),
                                  size: 20,
                                  color: Color(0xFF356DB4),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  items[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF356DB4),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemsAbout.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: itemsAbout[index].onTap,
                          child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              itemsAbout[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF356DB4),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class MenuModel {
  void Function() onTap;
  String? imageIcon;
  String title;
  MenuModel({required this.onTap, required this.title, this.imageIcon});
}
