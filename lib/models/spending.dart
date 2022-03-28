class Spending {
  int? spendingID;
  int? categoryID;
  String? categoryName;
  String? categoryIconName;
  String? spendingName;
  int? incomeMoney;
  int? expensesMoney;
  String? spendingData;

  Spending(this.categoryID, this.spendingName, this.incomeMoney,
      this.expensesMoney, this.spendingData);

  Spending.withID(this.spendingID, this.categoryID, this.spendingName,
      this.incomeMoney, this.expensesMoney, this.spendingData);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['spendingID'] = spendingID;
    map['categoryID'] = categoryID;
    map['spendingName'] = spendingName;
    map['incomeMoney'] = incomeMoney;
    map['expensesMoney'] = expensesMoney;
    map['spendingData'] = spendingData;
    return map;
  }

  Spending.fromMap(Map<String, dynamic> map) {
    spendingID = map['spendingID'];
    categoryID = map['categoryID'];
    categoryName = map['categoryName'];
    categoryIconName = map['categoryIconName'];
    spendingName = map['spendingName'];
    incomeMoney = map['incomeMoney'];
    expensesMoney = map['expensesMoney'];
    spendingData = map['spendingData'];
  }

  @override
  String toString() {
    return 'Spending{spendingID: $spendingID, categoryID: $categoryID, spendingName: $spendingName, incomeMoney: $incomeMoney, expensesMoney: $expensesMoney, spendingData: $spendingData}';
  }
}
