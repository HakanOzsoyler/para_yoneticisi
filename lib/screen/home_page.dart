import 'package:flutter/material.dart';
import 'package:flutter_para_yoneticisi/models/spending.dart';
import 'package:flutter_para_yoneticisi/utils/database_helper.dart';

import 'add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late DatabaseHelper databaseHelper;
  late List<Spending> allSpending;
  int? incomeMoney = 0;
  int? expensesMoney = 0;
  int? balance = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    allSpending = <Spending>[];
    databaseHelper = DatabaseHelper();
    getTotal();
  }

  void getTotal() async {
    var totalincome = (await databaseHelper.getTotalIncome())[0]['TOTAL'];
    var totalexpenses = (await databaseHelper.getTotalExpenses())[0]['TOTAL'];
    setState(() {
      if (totalincome != null) {
        incomeMoney = totalincome;
        expensesMoney = totalexpenses;
        balance = totalincome - totalexpenses;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      ///yan menü elemanları

      drawer: Drawer(
        elevation: 10,
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(
                    maxRadius: 35,
                    minRadius: 30,
                  ),
                  Text('Kullanıcı adı'),
                ],
              ),
            ),
            const Divider(
              color: Color(0xff1a237e),
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('katagory'),
                    leading: Icon(Icons.animation),
                  )
                ],
              ),
            ),
            const ListTile(
              title: Text('Çıkış Yap'),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),

      ///gövde
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///draver açma ıcon push
              IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu)),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Merhaba, Kullanıcı',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center),
              ),

              ///istatistikleri gösterme

              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.elliptical(200, 10),
                            right: Radius.elliptical(200, 10)),
                        color: Colors.white12,
                      ),
                      height: MediaQuery.of(context).size.height / 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Gelir',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                incomeMoney == null
                                    ? ''
                                    : incomeMoney!.toString(),
                              )
                            ],
                          ),
                          const VerticalDivider(
                            color: Color(0xff1a237e),
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Gider',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(expensesMoney == null
                                  ? ''
                                  : expensesMoney!.toString())
                            ],
                          ),
                          const VerticalDivider(
                            color: Color(0xff1a237e),
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Bilanço',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(balance == null ? '' : balance!.toString())
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddPage()));
                        },
                        child: Container(
                            width: 100,
                            height: 40,
                            decoration: const BoxDecoration(
                                color: Color(0xff1a237e),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.elliptical(200, 30),
                                    right: Radius.elliptical(200, 30))),
                            child: const Icon(Icons.add)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              ///liste elemanları
              FutureBuilder(
                  future: databaseHelper.spendingList(),
                  builder: (context, AsyncSnapshot<List<Spending>> snapshot) {
                    if (snapshot.hasData) {
                      allSpending = snapshot.data!;
                      return snapshot.data!.isEmpty
                          ? const Center(
                              child: Text(
                              'Bir veri ekleyin',
                              style: TextStyle(fontSize: 24),
                            ))
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: allSpending.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.elliptical(10, 100),
                                              topRight:
                                                  Radius.elliptical(10, 100))),
                                      color: Colors.white12,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 5),
                                      elevation: 5,
                                      child: ExpansionTile(
                                        title: Text(
                                            allSpending[index].categoryName!),
                                        leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white24,
                                            ),
                                            child: Image.asset(
                                                'assets/icon/${allSpending[index].categoryIconName}.png')),
                                        subtitle: Text(
                                          allSpending[index].incomeMoney == 0
                                              ? '-${allSpending[index].expensesMoney.toString()}'
                                              : '+${allSpending[index].incomeMoney.toString()}',
                                          style: TextStyle(
                                              color: allSpending[index]
                                                          .incomeMoney ==
                                                      0
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Eklendiği tarih',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    Text(databaseHelper
                                                        .dateFormat(DateTime
                                                            .parse(allSpending[
                                                                    index]
                                                                .spendingData!)))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Expanded(
                                                      child: Text(
                                                        'Açıklama',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(allSpending[
                                                                      index]
                                                                  .spendingName ==
                                                              ''
                                                          ? 'Yok'
                                                          : allSpending[index]
                                                              .spendingName!),
                                                    )
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    onPressed: () {
                                                      _delete(allSpending[index]
                                                          .spendingID!);
                                                    },
                                                    child: const Text('Sil')),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            );
                    } else {
                      return const Text('');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _delete(int spendingID) {
    databaseHelper.spendingDelete(spendingID).then((value) {
      if (spendingID != 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Kayıt Silindi'),
          duration: Duration(seconds: 2),
        ));
        setState(() {});
      }
    });
  }
  //pasta grafik
/*


List<GDPData> getChartData() {
  final List<GDPData> chartData = [
    GDPData('ulaşım', 5),
    GDPData('yemek', 100),
    GDPData('fatura', 150),
    GDPData('market', 500),
    GDPData('tadilat', 2265),
    GDPData('kira', 6546),
  ];
  return chartData;
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}*/
}
