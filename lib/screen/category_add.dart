import 'package:flutter/material.dart';
import 'package:flutter_para_yoneticisi/models/category.dart';

import '../utils/database_helper.dart';

class CategoryAdd extends StatefulWidget {
  String? text;
  CategoryAdd({Key? key, required this.text}) : super(key: key);
  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  late TextEditingController c1;
  DatabaseHelper? _databaseHelper;
  final _formKey = GlobalKey<FormState>();
  int checkedIndex = 0;
  String? iconName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c1 = TextEditingController();
    _databaseHelper = DatabaseHelper();
  }

  List<String> iconNameList = [
    'automobile',
    'awards',
    'baby',
    'bonus',
    'books',
    'charity',
    'clothing',
    'drinks',
    'education',
    'electronics',
    'entertainment',
    'food',
    'freelance',
    'friends',
    'gifts',
    'grants',
    'groceries',
    'health',
    'hobbies',
    'insurance',
    'interest',
    'investments',
    'laundry',
    'lottery',
    'mobile',
    'office',
    'others',
    'pets',
    'refunds',
    'rent',
    'salary',
    'sale',
    'salon',
    'shopping',
    'tax',
    'transportation',
    'travel',
    'utilities',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Kategori Ekle'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            //kategori ismi ve  ekleme
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          validator: kontrol,
                          controller: c1,
                          cursorColor: const Color(0xff1a237e),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Kategori ismi',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xff1a237e),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text('Kaydet'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _categoryAdd(
                                  Category(c1.text, widget.text, iconName));
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //text
            Center(
              child: Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(child: Text('İconlar'))),
            ),
            //iconlar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemCount: iconNameList.length,
                    itemBuilder: (context, index) {
                      bool checked = index == checkedIndex;
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              checkedIndex = index;
                              iconName = iconNameList[index];
                              print(iconName);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: checked
                                    ? const Color(0xff1a237e)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(100)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icon/${iconNameList[index]}.png',
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _categoryAdd(Category category) async {
    await _databaseHelper!.categoryCreate(category);
  }

  String? kontrol(String? value) {
    if (value == null) {
      return '';
    } else if (value.isEmpty) {
      return 'Kategori ismi boş bırakılamaz';
    } else if (value.length > 10) {
      return 'En fazla 10 karakter girilmeli';
    }
  }
}
