import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carriage/pages/NotificationSettings.dart';
import 'package:carriage/widgets/Buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../main_common.dart';
import '../utils/app_config.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../utils/CarriageTheme.dart';
import '../providers/DriverProvider.dart';

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DriverProvider driverProvider = Provider.of<DriverProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _picDiameter = _width * 0.27;
    double _picMarginLR = _picDiameter / 6.25;
    double _picMarginTB = _picDiameter / 4;
    double _picBtnDiameter = _picDiameter * 0.39;

    Widget sectionDivider = Container(
        height: 6,
        color: CarriageTheme.backgroundColor
    );

    if (driverProvider.hasInfo()) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: CarriageTheme.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 24,
                      top: 18,
                      bottom: 16
                  ),
                  child: Text('Your Profile',
                      style: CarriageTheme.largeTitle),
                ),
              ),
              Container(
                  color: Colors.white,
                  child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: _picMarginLR,
                                right: _picMarginLR,
                                top: _picMarginTB,
                                bottom: _picMarginTB),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsets.only(bottom: _picDiameter * 0.05),
                                  child: Container(
                                    height: _picDiameter,
                                    width: _picDiameter,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: driverProvider.driver.photoLink == null ? Image.asset(
                                          'assets/images/person.png',
                                          width: _picDiameter,
                                          height: _picDiameter,
                                        ) : Image.network(
                                          driverProvider.driver.photoLink,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }else {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        )
                                    ),
                                  ),
                                ),
                                Positioned(
                                    child: Container(
                                      height: _picBtnDiameter,
                                      width: _picBtnDiameter,
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                            backgroundColor: Colors.black,
                                            child:
                                            Icon(Icons.edit, size: _picBtnDiameter * 0.75),
                                            onPressed: () async {
                                              ImagePicker picker = ImagePicker();
                                              PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
                                              Uint8List bytes = await File(pickedFile.path).readAsBytes();
                                              String base64Image = base64Encode(bytes);
                                              await driverProvider.updateDriverPhoto(AppConfig.of(context), Provider.of<AuthProvider>(context, listen: false), base64Image);
                                            }),
                                      ),
                                    ),
                                    left: _picDiameter * 0.61,
                                    top: _picDiameter * 0.66
                                )
                              ],
                            )
                        ),
                        Expanded(
                          child: Text(
                              driverProvider.driver.firstName +
                                  " " +
                                  driverProvider.driver.lastName,
                              style: TextStyle(
                                  fontFamily: 'SFDisplay',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        )
                      ]
                  )
              ),
              sectionDivider,
              InfoGroup(
                'Account Info',
                [
                  InfoRow(
                    Icons.mail_outline,
                    driverProvider.driver.email,
                  ),
                  InfoRow(
                      Icons.phone,
                      driverProvider.driver.phoneNumber,
                      editPage: EditPhoneNumber(driverProvider.driver.phoneNumber)
                  ),
                  InfoRow(
                    Icons.person,
                    driverProvider.driver.firstName + ' ' + driverProvider.driver.lastName,
                    editPage: EditName(driverProvider.driver.firstName, driverProvider.driver.lastName),
                  ),
                ],
              ),
              sectionDivider,
              SizedBox(height: 8),
              //TODO: implement these pages
              SettingRow('Notifications', 'Set your notification preferences', NotificationSettings()),
              SettingRow('Privacy', 'Choose what data you share with us', Container()),
              SettingRow('Legal', 'Terms of Service & Privacy Policy', Container()),
              sectionDivider,
              SignOutButton()
            ],
          ),
        ),
      );
    }
    else {
      return SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: CircularProgressIndicator()
            ),
          )
      );
    }
  }
}

class ArrowButton extends StatelessWidget {
  ArrowButton(this.page);
  final Widget page;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.arrow_forward_ios, size: 16),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  InfoRow(this.icon, this.text, {this.editPage});
  final IconData icon;
  final String text;
  final Widget editPage;

  @override
  Widget build(BuildContext context) {
    double paddingTB = 16;

    return Padding(
        padding: EdgeInsets.only(top: paddingTB, bottom: paddingTB),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: 19),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(74, 74, 74, 1),
                ),
              ),
            ),
            editPage != null ? ArrowButton(editPage) : Container()
          ],
        )
    );
  }
}

class SettingRow extends StatelessWidget {
  SettingRow(this.title, this.description, this.page);
  final String title;
  final String description;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontFamily: 'SFDisplay', fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(description, style: TextStyle(fontFamily: 'SFDisplay', fontSize: 17, color: CarriageTheme.gray1)),
            ],
          ),
          Spacer(),
          ArrowButton(page)
        ],
      ),
    );
  }
}

class InfoGroup extends StatelessWidget {
  InfoGroup(this.title, this.rows);
  final String title;
  final List<InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: TextStyle(fontFamily: 'SFDisplay', fontSize: 20, fontWeight: FontWeight.bold)),
                ListView.separated(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rows.length,
                    itemBuilder: (BuildContext context, int index) {
                      return rows[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Container(
                            height: 1,
                            color: Color.fromRGBO(151, 151, 151, 1),
                          )
                      );
                    })
              ],
            )));
  }
}

class EditName extends StatefulWidget {
  EditName(this.initialFirstName, this.initialLastName);
  final String initialFirstName;
  final String initialLastName;
  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  bool requestedUpdate = false;

  @override
  void initState() {
    super.initState();
    firstNameCtrl.text = widget.initialFirstName;
    lastNameCtrl.text = widget.initialLastName;
  }

  @override
  Widget build(BuildContext context) {
    DriverProvider userInfoProvider = Provider.of<DriverProvider>(context);
    FocusScopeNode focus = FocusScope.of(context);

    return Scaffold(
        body: LoadingOverlay(
          isLoading: requestedUpdate,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileBackButton(),
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                      Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  autofocus: true,
                                  controller: firstNameCtrl,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) { focus.nextFocus(); },
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(color: CarriageTheme.gray2),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                    suffixIcon: IconButton(
                                      onPressed: firstNameCtrl.clear,
                                      icon: Icon(Icons.cancel_outlined, size: 16, color: Colors.black),
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please enter your first name.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: lastNameCtrl,
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(color: CarriageTheme.gray2),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                    suffixIcon: IconButton(
                                      onPressed: lastNameCtrl.clear,
                                      icon: Icon(Icons.cancel_outlined, size: 16, color: Colors.black),
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please enter your last name.';
                                    }
                                    return null;
                                  },
                                )
                              ]
                          )
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        child: CButton(
                          text: 'Update Name',
                          hasShadow: true,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() {
                                requestedUpdate = true;
                              });
                              await userInfoProvider.updateName(AppConfig.of(context), Provider.of<AuthProvider>(context, listen: false), firstNameCtrl.text, lastNameCtrl.text);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ]
                )
            ),
          ),
        )
    );
  }
}

class EditPhoneNumber extends StatefulWidget {
  EditPhoneNumber(this.initialPhoneNumber);
  final String initialPhoneNumber;
  @override
  _EditPhoneNumberState createState() => _EditPhoneNumberState();
}

class _EditPhoneNumberState extends State<EditPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberCtrl = TextEditingController();
  bool requestedUpdate = false;

  @override
  void initState() {
    super.initState();
    phoneNumberCtrl.text = widget.initialPhoneNumber;
  }
  @override
  Widget build(BuildContext context) {
    DriverProvider driverProvider = Provider.of<DriverProvider>(context);

    return Scaffold(
        body: LoadingOverlay(
          isLoading: requestedUpdate,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileBackButton(),
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                      Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            autofocus: true,
                            controller: phoneNumberCtrl,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: CarriageTheme.gray2),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                              suffixIcon: IconButton(
                                onPressed: phoneNumberCtrl.clear,
                                icon: Icon(Icons.cancel_outlined, size: 16, color: Colors.black),
                              ),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please enter your phone number.';
                              }
                              else if (input.length != 10) {
                                return 'Phone number should be 10 digits.';
                              }
                              else if (int.tryParse(input) == null) {
                                return 'Phone number should be all numbers.';
                              }
                              return null;
                            },
                          )
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        child: CButton(
                          text: 'Update Phone Number',
                          hasShadow: true,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() {
                                requestedUpdate = true;
                              });
                              await driverProvider.updatePhoneNumber(AppConfig.of(context), Provider.of<AuthProvider>(context, listen: false), phoneNumberCtrl.text);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      )
                    ]
                )
            ),
          ),
        )
    );
  }
}

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: GestureDetector(
            child: Row(
              children: [
                Icon(Icons.exit_to_app),
                SizedBox(width: 12),
                Text(
                    'Sign out',
                    style: TextStyle(
                        fontFamily: 'SFDisplay',
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    )
                ),
              ],
            ),
            onTap: () {
              authProvider.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomeOrLogin()));
            },
          ),
        ),
      ],
    );
  }
}

class ProfileBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: 24, height: 24,
          child: Icon(Icons.arrow_back_ios, size: 16)
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}