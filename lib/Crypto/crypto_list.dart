import 'dart:convert';
import 'package:crypto_graphs/Crypto/trade_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String, dynamic>? _cryptoList;

  Future getCryptoPrices() async {
    print('getting crypto prices'); //print
    var response = await http.get(
        Uri.parse('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'),

        headers: {
          'X-CMC_PRO_API_KEY': 'a841ba56-d037-43d2-8068-6eeefa90e659',
        });

    if (response.statusCode == 200) {
      setState(() {
        _cryptoList =
            jsonDecode(response.body);
      });
      print(_cryptoList!['data']); //prints the list
    }
  }

  @override
  void initState() {
    super.initState();
    getCryptoPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _cryptoList != null ? Row(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cryptoList!['data'].length,
                // physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context,
                    int index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TradeWidget(
                                    crypto: _cryptoList!['data'][index],
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              24),
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                10.0),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets
                                    //       .symmetric(
                                    //       horizontal: 8),
                                    //   child: Image.asset(
                                    //     index == 0 ? "assets/new_images/bitcoin.png"
                                    //         : "assets/new_images/crypto/ethereum.png",
                                    //     height: 30,
                                    //     width: 30,),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets
                                          .only(top: 6,
                                          bottom: 10,
                                          left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text("${_cryptoList!['data'][index]['name']}",
                                            style: TextStyle(
                                                color: Colors
                                                    .grey,
                                                fontSize: 14),),
                                          Text("${_cryptoList!['data'][index]['symbol']}/USD",
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold,
                                                fontSize: 14),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets
                                      .only(top: 10.0,right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("\$${_cryptoList!['data'][index]['quote']['USD']['price'].toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight
                                                .w800),),
                                      Row(
                                        children: [
                                          Icon(_cryptoList!['data'][index]['quote']['USD']['percent_change_24h'].toString().contains("-")
                                              ? Icons
                                              .arrow_drop_down : Icons.arrow_drop_up,
                                            size: 20,
                                            color: _cryptoList!['data'][index]['quote']['USD']['percent_change_24h'].toString().contains("-")
                                                ? Colors.red : Colors.green,),
                                          Text("${_cryptoList!['data'][index]['quote']['USD']['percent_change_24h'].toStringAsFixed(2)}%",
                                            style: TextStyle(
                                                color: _cryptoList!['data'][index]['quote']['USD']['percent_change_24h'].toString().contains("-")
                                                    ? Colors.red : Colors.green.shade700,
                                                fontWeight: FontWeight
                                                    .w700,
                                                fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}