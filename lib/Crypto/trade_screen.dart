import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:http/http.dart' as http;

class TradeWidget extends StatefulWidget {
  final Map<String, dynamic> crypto;

  const TradeWidget({Key? key,required this.crypto}) : super(key: key);

  @override
  _TradeWidgetState createState() => _TradeWidgetState();
}

class _TradeWidgetState extends State<TradeWidget> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  bool h = false;
  bool d = true;
  bool w = false;
  bool m = false;
  bool y = false;
  bool all = false;
  bool contains = false;
  String? volume_change;
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  Map<String, dynamic>? _cryptoList;
  List<double> Lists = [];

  @override
  void initState() {
    super.initState();
    price();
  }

  price() async {
    var crypt = widget.crypto['symbol'];
    print(crypt);
    data = [];
    var response = await http.get(
      Uri.parse(
          h == true ? 'https://min-api.cryptocompare.com/data/v2/histominute?fsym=$crypt&tsym=GBP&limit=60'
              :           d == true ? 'https://min-api.cryptocompare.com/data/v2/histohour?fsym=$crypt&tsym=USD&limit=24'
              :           w == true ? 'https://min-api.cryptocompare.com/data/v2/histohour?fsym=$crypt&tsym=USD&limit=168'
              :           m == true ? 'https://min-api.cryptocompare.com/data/v2/histohour?fsym=$crypt&tsym=USD&limit=720'
              :           y == true ? 'https://min-api.cryptocompare.com/data/v2/histohour?fsym=$crypt&tsym=USD&limit=1000'
              :          all == true ? 'https://min-api.cryptocompare.com/data/v2/histohour?fsym=$crypt&tsym=USD&limit=1500'
              : ""
      ),
    );
    setState(() {
      h == true ? volume_change = widget.crypto['quote']['USD']['percent_change_1h'].toStringAsFixed(2)
          : d == true ? volume_change = widget.crypto['quote']['USD']['percent_change_24h'].toStringAsFixed(2)
          : w == true ? volume_change = widget.crypto['quote']['USD']['percent_change_7d'].toStringAsFixed(2)
          : m == true ? volume_change = widget.crypto['quote']['USD']['percent_change_30d'].toStringAsFixed(2)
          : volume_change = widget.crypto['quote']['USD']['percent_change_90d'].toStringAsFixed(2);

      if (response.statusCode == 200) {
        setState(() {
          _cryptoList =
              jsonDecode(response.body);
        });
        print(_cryptoList!['Data']);
        Lists.clear();
        for(int i = 0; i< _cryptoList!['Data']['Data'].length; i++){
          setState(() {
            Lists.add(double.parse(_cryptoList!['Data']['Data'][i]['high'].toString()));
          });
        }
        setState(() {
          data = Lists;
        });
        print(_cryptoList!['Data']['Data']);
      }
      else{
        print(response.body);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.crypto['name']),
              ),
              body: volume_change != null ? SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    color: Colors.white54,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text("\$${widget.crypto['quote']['USD']['price'].toStringAsFixed(2)}", style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold)),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                220, 250, 231, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0)
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                volume_change?.contains("-") == false
                                                    ? Image.asset(
                                                    "assets/images/Polygon 1.png")
                                                    : Image.asset("assets/images/down-filled-triangular-arrow.png",
                                                  color: Colors.red.shade700,height: 12,),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(left: 4.0),
                                                  child: Text("${volume_change?.substring(1)}%",
                                                    style: TextStyle(
                                                        color: volume_change?.contains("-") == false
                                                            ? Colors.green : Colors.red,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w600),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Container(
                                          height: 25,
                                          width: 70,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                220, 250, 231, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0)
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                volume_change?.contains("-") == false
                                                    ? Image.asset(
                                                    "assets/images/Polygon 1.png")
                                                    : Image.asset("assets/images/down-filled-triangular-arrow.png", color: Colors.red.shade700,height: 12,),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(left: 4.0),
                                                  child: Text(d == true ? "30 Days"
                                                      : h == true ? "1 Hour"
                                                      : w == true ? "1 Week"
                                                      : m == true ? "1 Month"
                                                      : y == true ? "1 Year"
                                                      : "All",
                                                    style: TextStyle(
                                                        color: volume_change!.contains("-")
                                                            ? Colors.red : Colors.green,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .w600),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0),
                                child: data != null ? Sparkline(
                                  data: data,
                                  lineWidth: 2,
                                  // fillMode: FillMode.below,
                                  // fillColor: Colors.red[200],
                                  // useCubicSmoothing: true,
                                  cubicSmoothingFactor: 0.2,
                                  lineColor: Colors.deepPurple,
                                ) : const LoaderOverlay(
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = true;
                                          d = false;
                                          w = false;
                                          m = false;
                                          y = false;
                                          all = false;
                                        });
                                        // OHLCData().then((value) {
                                        //   setState(() {});
                                        // });
                                        price();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: h == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("1H",
                                                style: TextStyle(
                                                    color: h == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = false;
                                          d = true;
                                          w = false;
                                          m = false;
                                          y = false;
                                          all = false;
                                        });
                                        price();
                                        // OHLCData();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: d == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("1D",
                                                style: TextStyle(
                                                    color: d == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = false;
                                          d = false;
                                          w = true;
                                          m = false;
                                          y = false;
                                          all = false;
                                        });
                                        price();
                                        // OHLCData();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: w == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("1W",
                                                style: TextStyle(
                                                    color: w == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = false;
                                          d = false;
                                          w = false;
                                          m = true;
                                          y = false;
                                          all = false;
                                        });
                                        price();
                                        // OHLCData();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: m == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("1M",
                                                style: TextStyle(
                                                    color: m == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = false;
                                          d = false;
                                          w = false;
                                          m = false;
                                          y = true;
                                          all = false;
                                        });
                                        price();
                                        // OHLCData();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: y == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("1Y",
                                                style: TextStyle(
                                                    color: y == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          h = false;
                                          d = false;
                                          w = false;
                                          m = false;
                                          y = false;
                                          all = true;
                                        });
                                        price();
                                        // OHLCData();
                                      },
                                      child: Container(
                                          height: 25, width: 40,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: all == false ? [
                                                Colors.white,
                                                Colors.white,
                                              ] : [
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                                Color.fromRGBO(
                                                    206, 224, 254, 1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  4.0),
                                              child: Text("All",
                                                style: TextStyle(
                                                    color: all == false ? Colors
                                                        .grey : Colors.blue
                                                        .shade800,
                                                    fontSize: 12),),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : const Center(child: CircularProgressIndicator()),
            ),
          );
        }
    );
  }
}