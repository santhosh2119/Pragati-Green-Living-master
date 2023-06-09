// ignore_for_file: library_private_types_in_public_api
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'Contact Us',
        onPressed: () async {
          String url = 'tel:+919000450500';

          try {
            // ignore: deprecated_member_use
            await canLaunch(url)
                ?
                // ignore: deprecated_member_use
                await launch(url)
                : throw 'Error';
          } catch (e) {
            setState(() {});
          }
        },
        backgroundColor: ConstantColors.primary,
        child: const Icon(
          CupertinoIcons.phone_solid,
          color: Colors.white,
        ),
      ),
      body: Column(children: <Widget>[
        Material(
            elevation: 2,
            color: Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0, left: 16, top: 16),
                    child: Text(
                      'Our Address',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 16, bottom: 16),
                    child:
                        Text(Constant.contactUsAddress.replaceAll(r'\n', '\n')),
                  ),
                  InkWell(
                    onTap: () async {
                      // iOS: Will open mail app if single mail app found.
                      var result = await OpenMailApp.openMailApp();

                      // If no mail apps found, show error
                      if (!result.didOpen && !result.canOpen) {
                        showNoMailAppsDialog(context);

                        // iOS: if multiple mail apps found, show dialog to select.
                        // There is no native intent/default app system in iOS so
                        // you have to do it yourself.
                      } else if (!result.didOpen && result.canOpen) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return MailAppPickerDialog(
                              mailApps: result.options,
                            );
                          },
                        );
                      }
                    },
                    child: ListTile(
                      title: const Text(
                        'Email Us',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(Constant.contactUsEmail),
                      trailing: const Icon(
                        CupertinoIcons.chevron_forward,
                        color: Colors.black54,
                      ),
                    ),
                  )
                ]))
      ]),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
