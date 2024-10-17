enum CategoryType {
  diet,
  beauty,
  child,
  study,
  book,
  food,
  medicine,
  other,
}

extension ParseToString on CategoryType {
  String toShortString() {
    String str = "";

    switch (this) {
      case CategoryType.diet:
        str = "Diet";
        break;
      case CategoryType.beauty:
        str = "Beauty";
        break;
      case CategoryType.child:
        str = "Child";
        break;
      case CategoryType.study:
        str = "Study";
        break;
      case CategoryType.medicine:
        str = "Medicine";
        break;
      case CategoryType.book:
        str = "Book";
        break;
      case CategoryType.food:
        str = "Food";
        break;
      case CategoryType.other:
        str = "Other";
        break;
    }
    return str;
  }
}

extension ParseToCategory on String {
  CategoryType toCategory() {
    CategoryType type = CategoryType.other;

    switch (this) {
      case "Diet":
        type = CategoryType.diet;
        break;
      case "Beauty":
        type = CategoryType.beauty;
        break;
      case "Child":
        type = CategoryType.child;
        break;
      case "Study":
        type = CategoryType.study;
        break;
      case "Medicine":
        type = CategoryType.medicine;
        break;
      case "Book":
        type = CategoryType.book;
        break;
      case "Food":
        type = CategoryType.food;
        break;
      case "Other":
        type = CategoryType.other;
        break;
    }
    return type;
  }
}

extension ParseImagePath on CategoryType {
  String toImagePath() {
    return "assets/images/category_${toShortString().toLowerCase()}.png";
  }
}

extension ParseToIndex on CategoryType {
  int toIndex() {
    var index = -1;

    switch (this) {
      case CategoryType.diet:
        index = 0;
        break;
      case CategoryType.beauty:
        index = 1;
        break;
      case CategoryType.child:
        index = 2;
        break;
      case CategoryType.study:
        index = 3;
        break;
      case CategoryType.medicine:
        index = 4;
        break;
      case CategoryType.book:
        index = 5;
        break;
      case CategoryType.food:
        index = 6;
        break;
      case CategoryType.other:
        index = 7;
        break;
    }
    return index;
  }
}

extension IndexToParse on int {
  CategoryType? toCategoryType() {
    CategoryType? type;
    switch (this) {
      case 0:
        type = CategoryType.diet;
        break;
      case 1:
        type = CategoryType.beauty;
        break;
      case 2:
        type = CategoryType.child;
        break;
      case 3:
        type = CategoryType.study;
        break;
      case 4:
        type = CategoryType.medicine;
        break;
      case 5:
        type = CategoryType.book;
        break;
      case 6:
        type = CategoryType.food;
        break;
      case 7:
        type = CategoryType.other;
        break;
    }
    return type;
  }
}
