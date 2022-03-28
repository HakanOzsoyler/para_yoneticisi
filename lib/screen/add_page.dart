import 'package:flutter/material.dart';
import 'package:flutter_para_yoneticisi/screen/category_add.dart';
import 'package:flutter_para_yoneticisi/utils/database_helper.dart';

import '../models/category.dart';
import '../models/spending.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPAgeState createState() => _AddPAgeState();
}

class _AddPAgeState extends State<AddPage> with SingleTickerProviderStateMixin {
  var formkey = GlobalKey<FormState>();
  late TabController _tabController;
  List<Category> allCategoryLi = [];
  late DatabaseHelper databaseHelper;
  TextEditingController c2 = TextEditingController();
  List itemsIncome = [];
  List itemsExpenses = [];
  String textGelir = 'Gelir';
  String textGider = 'Gider';
  bool? changeColor = false;
  int checkedIndex = 0;
  int? categoryID;
  String? gelentype;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    allCategoryLi = <Category>[];
    databaseHelper = DatabaseHelper();

    ///ıncome
    databaseHelper.categoryReadIncome().then((value) {
      for (Map<String, dynamic> readMap in value) {
        allCategoryLi.add(Category.fromMap(readMap));
      }
      print('db den gelen :' + allCategoryLi.toString());
    });
    databaseHelper.categoryReadIncome().then((data) {
      setState(() {
        itemsIncome = data;
      });
    });

    ///expenses
    databaseHelper.categoryReadExpenses().then((value) {
      for (Map<String, dynamic> readMap in value) {
        allCategoryLi.add(Category.fromMap(readMap));
      }
      print('db den gelen :' + allCategoryLi.toString());
    });
    databaseHelper.categoryReadExpenses().then((data) {
      setState(() {
        itemsExpenses = data;
      });
    });
  }

  int? sayi1;
  int? sayi2;
  String gosterilecekSayi = '0';
  String islemGecmisi = '';
  String? sonuc;
  String? islem;
  //hesap makinesi tuş
  void butontutucu(String value) {
    if (value == 'C') {
      if (gosterilecekSayi != '') {
        sonuc = gosterilecekSayi.substring(0, gosterilecekSayi.length - 1);
      } else {
        islemGecmisi = '';
      }
    } else if (value == '+') {
      sayi1 = int.parse(gosterilecekSayi);
      sonuc = '';
      islem = value;
      islemGecmisi = sayi1.toString() + islem.toString();
    } else if (value == '–') {
      sayi1 = int.parse(gosterilecekSayi);
      sonuc = '';
      islem = value;
      islemGecmisi = sayi1.toString() + islem.toString();
    } else if (value == '=') {
      sayi2 = int.parse(gosterilecekSayi);
      if (islem == '+') {
        sonuc = (sayi1! + sayi2!).toString();
        islemGecmisi = sayi1.toString() + islem.toString() + sayi2.toString();
      } else if (islem == '–') {
        sonuc = (sayi1! - sayi2!).toString();
        islemGecmisi = sayi1.toString() + islem.toString() + sayi2.toString();
      }
    } else {
      sonuc = int.parse(gosterilecekSayi + value).toString();
    }
    setState(() {
      gosterilecekSayi = sonuc!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white10,
      appBar: AppBar(backgroundColor: Colors.black, bottom: tabbar()),
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ///gelir ekranı simgeleri
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, mainAxisSpacing: 10),
                    itemCount: itemsIncome.length,
                    itemBuilder: (context, index) {
                      bool checked = index == checkedIndex;
                      var category = Category.fromMap(itemsIncome[index]);
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: category.categoryName == 'Ekle'
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CategoryAdd(
                                                    text: textGelir,
                                                  )));
                                    }
                                  : () {
                                      print('indexi seç');
                                      print(category.categoryID.toString());
                                      print(category.type);
                                      print(category.categoryIconName);

                                      setState(() {
                                        checkedIndex = index;
                                        categoryID = category.categoryID;
                                        gelentype = category.type;
                                      });
                                    },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: checked
                                        ? const Color(0xff1a237e)
                                        : Colors.white10,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.asset(
                                    'assets/icon/${category.categoryIconName}.png'),
                              ),
                            ),
                            Text(category.categoryName!,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  ),

                  ///gider ekranı simgeleri
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, crossAxisSpacing: 10),
                    itemCount: itemsExpenses.length,
                    itemBuilder: (context, index) {
                      bool checked = index == checkedIndex;
                      var category = Category.fromMap(itemsExpenses[index]);
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: category.categoryName == 'Ekle'
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CategoryAdd(
                                                    text: textGider,
                                                  )));
                                    }
                                  : () {
                                      setState(() {
                                        print('indexi seç');
                                        print(category.categoryID.toString());
                                        print(category.type);
                                        checkedIndex = index;
                                        categoryID = category.categoryID;
                                        gelentype = category.type;
                                      });
                                    },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: checked
                                        ? const Color(0xff1a237e)
                                        : Colors.white10,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.asset(
                                    'assets/icon/${category.categoryIconName}.png'),
                              ),
                            ),
                            Text(category.categoryName!,
                                overflow: TextOverflow.ellipsis)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            ///alt alan hesap makinesi
            SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: TextFormField(
                                validator: kontrol,
                                controller: c2,
                              )),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  islemGecmisi,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  gosterilecekSayi,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Column(
                        children: [
                          Row(children: [
                            MyWidget(string: '1', function: butontutucu),
                            MyWidget(string: '2', function: butontutucu),
                            MyWidget(string: '3', function: butontutucu),
                            MyWidget(
                                string: '+',
                                function: butontutucu,
                                bgColor: const Color(0xff1a237e)),
                          ]),
                          Row(children: [
                            MyWidget(string: '4', function: butontutucu),
                            MyWidget(string: '5', function: butontutucu),
                            MyWidget(string: '6', function: butontutucu),
                            MyWidget(
                                string: '–',
                                function: butontutucu,
                                bgColor: const Color(0xff1a237e)),
                          ]),
                          Row(children: [
                            MyWidget(string: '7', function: butontutucu),
                            MyWidget(string: '8', function: butontutucu),
                            MyWidget(string: '9', function: butontutucu),
                            MyWidget(
                                string: '=',
                                function: butontutucu,
                                bgColor: const Color(0xff1a237e)),
                          ]),
                          Row(children: [
                            MyWidget(string: '00', function: butontutucu),
                            MyWidget(string: '0', function: butontutucu),
                            MyWidget(
                              string: 'C',
                              function: butontutucu,
                              bgColor: Colors.red,
                            ),
                            InkWell(
                              onTap: () {
                                if (formkey.currentState!.validate()) {
                                  print('kaydetmeye hazırım');
                                  if (gosterilecekSayi != '') {
                                    print(
                                        'para: ' + gosterilecekSayi.toString());
                                    print('gelen kategori IDsi: ' +
                                        categoryID.toString());
                                    print('istege bağlı not: ' + c2.text);
                                    var now = DateTime.now();
                                    print('suan: ' + now.toString());
                                    print('methot çalıştı: ' +
                                        databaseHelper.dateFormat(now));
                                    if (gelentype == 'Gelir') {
                                      databaseHelper
                                          .spendingCreate(Spending(
                                              categoryID!,
                                              c2.text,
                                              int.parse(gosterilecekSayi),
                                              0,
                                              now.toString()))
                                          .then((value) {
                                        if (value != 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Gelir eklendi'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          setState(() {});
                                        }
                                      });
                                    }
                                    if (gelentype == 'Gider') {
                                      databaseHelper
                                          .spendingCreate(Spending(
                                              categoryID!,
                                              c2.text,
                                              0,
                                              int.parse(gosterilecekSayi),
                                              now.toString()))
                                          .then((value) {
                                        if (value != 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Gider eklendi'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          setState(() {});
                                        }
                                      });
                                    }

                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  width: 75,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      '✓',
                                      style: TextStyle(
                                          fontSize: 32, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  tabbar() {
    return TabBar(
        labelColor: const Color(0xff1a237e),
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white10),
        controller: _tabController,
        tabs: [
          Tab(
            child: Text(
              textGelir,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              textGider,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ]);
  }

  String? kontrol(String? value) {
    if (value == null) {
      return '';
    } else if (value.length > 30) {
      return 'En fazla 30 karakter girilmeli';
    } else if (gosterilecekSayi == '0') {
      return 'Para 0 olamaz';
    }
  }
}

class MyWidget extends StatelessWidget {
  Color? bgColor;

  String string;
  Function? function;

  MyWidget({
    Key? key,
    required this.string,
    this.bgColor,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function!(string);
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: 75,
          height: 50,
          decoration: BoxDecoration(
              color: bgColor ?? Colors.white10,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              string,
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
