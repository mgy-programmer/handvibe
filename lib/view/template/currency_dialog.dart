import 'package:flutter/material.dart';
import 'package:handvibe/utility/color_bank.dart';
import 'package:handvibe/utility/screen_size_util.dart';
import 'package:handvibe/utility/text_font.dart';

class CurrencyDialog extends StatefulWidget {
  final Function(String) returnedCurrency;
  final String selectedCurrency;

  const CurrencyDialog({super.key, required this.returnedCurrency, required this.selectedCurrency});

  @override
  State<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<CurrencyDialog> {
  List<CurrencyModel> mostUsedCurrencies = [
    CurrencyModel("TRY", "Turkish Lira"),
    CurrencyModel("USD", "United States Dollar"),
    CurrencyModel("EUR", "Euro"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorBank().black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          width: ScreenSizeUtil().getCalculateWith(context, 330),
          height: ScreenSizeUtil().getCalculateHeight(context, 250),
          decoration: BoxDecoration(
            color: ColorBank().white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            itemCount: mostUsedCurrencies.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  widget.returnedCurrency(mostUsedCurrencies[index].currencyCode);
                  Navigator.pop(context);
                },
                title: Text(
                  mostUsedCurrencies[index].currencyCode,
                  style: TextFont().ralewayBoldMethod(18, ColorBank().black, context),
                ),
                subtitle: Text(
                  mostUsedCurrencies[index].currencyName,
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
                    color: widget.selectedCurrency == mostUsedCurrencies[index].currencyCode ? ColorBank().primary : ColorBank().white,
                    border: Border.all(color: ColorBank().primary),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CurrencyModel {
  late String currencyCode;
  late String currencyName;

  CurrencyModel(this.currencyCode, this.currencyName);
}
