import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';
import 'package:handvibe/utility/useful_methods.dart';
import 'package:handvibe/view/atom/close_button.dart';

class CountryDialog extends StatefulWidget {
  final Function(String) returnedCountry;
  final String selectedCountry;

  const CountryDialog({super.key, required this.returnedCountry, required this.selectedCountry});

  @override
  State<CountryDialog> createState() => _CountryDialogState();
}

class _CountryDialogState extends State<CountryDialog> {
  List<CountryModel> countries = [];

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    countries = await UsefulMethods().loadCountryFromJson();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: ColorBank().white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            left: ScreenSizeUtil().getCalculateWith(context, 20),
            right: ScreenSizeUtil().getCalculateWith(context, 20),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: ScreenSizeUtil().getCalculateHeight(context, 5),
                  right: ScreenSizeUtil().getCalculateWith(context, 5),
                ),
                alignment: Alignment.centerRight,
                child: BtnClose(),
              ),
              SizedBox(
                height: ScreenSizeUtil().getCalculateHeight(context, 650),
                child: countries.isNotEmpty
                    ? ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              widget.returnedCountry(countries[index].countryName);
                              Navigator.pop(context);
                            },
                            title: Text(
                              countries[index].countryName,
                              style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
                            ),
                            subtitle: Text(
                              countries[index].countryCode,
                              style: TextFont().ralewayBoldMethod(14, ColorBank().hinTextColor, context),
                            ),
                            trailing: Container(
                              width: ScreenSizeUtil().getCalculateWith(context, 10),
                              height: ScreenSizeUtil().getCalculateWith(context, 10),
                              padding: EdgeInsets.all(
                                ScreenSizeUtil().getCalculateWith(context, 5),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color: widget.selectedCountry == countries[index].countryName ? ColorBank().primary : ColorBank().white,
                                border: Border.all(color: ColorBank().primary),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryModel {
  late int id;
  late String countryName;
  late String countryCode;

  CountryModel(this.id, this.countryName, this.countryCode);

  CountryModel.fromJson(Map json) {
    id = json["id"];
    countryName = json["country_name"];
    countryCode = json["country_code"];
  }
}
