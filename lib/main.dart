import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo,
      ),
      brightness: Brightness.dark,
      primarySwatch: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _formKey = GlobalKey<FormState>();

  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimumPadding = 5.0;

  var _currentItemSelected = '';

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2.0),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter principal amount.';
                    }
                    return null;
                  },
                  style: textStyle,
                  controller: principalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Principal Amount',
                      hintText: 'Enter Principal e.g. 12000',
                      labelStyle: textStyle,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  style: textStyle,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please enter interest rate.';
                    }
                    return null;
                  },
                  controller: interestRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Interest Rate',
                      hintText: 'In percent',
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15.0,
                      ),
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: textStyle,
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Please enter term.';
                          }
                          return null;
                        },
                        controller: termController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: 'Term in years',
                            labelStyle: textStyle,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              )
                            ),
                            errorStyle: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          'Calculate',
                          style: textStyle,
                          textScaleFactor: 1.25,
                        ),
                        onPressed: () {
                          setState(() {
                            if(_formKey.currentState?.validate() != null) {
                              this.displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Reset',
                          style: textStyle,
                          textScaleFactor: 1.25,
                        ),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = const AssetImage('images/img.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10.0),
    );
  }

  void _onDropDownItemSelected(var newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double interestRate = double.parse(interestRateController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable =
        principal + (principal * interestRate * term) / 100;

    String result =
        'After ${term.toInt()} years, your investment will be worth $totalAmountPayable $_currentItemSelected';

    return result;
  }

  void _reset() {
    principalController.text = '';
    interestRateController.text = '';
    termController.text = '';
    displayResult = '';

    _currentItemSelected = _currencies[0];
  }
}
