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
        str = "diet";
        break;
      case CategoryType.beauty:
        str = "beauty";
        break;
      case CategoryType.child:
        str = "child";
        break;
      case CategoryType.study:
        str = "study";
        break;
      case CategoryType.medicine:
        str = "medicine";
        break;
      case CategoryType.book:
        str = "book";
        break;
      case CategoryType.food:
        str = "food";
        break;
      case CategoryType.other:
        str = "other";
        break;
    }
    return str;
  }
}

extension ParseToCategory on String {
  CategoryType toCategory() {
    CategoryType type = CategoryType.other;

    switch (this) {
      case "diet":
        type = CategoryType.diet;
        break;
      case "beauty":
        type = CategoryType.beauty;
        break;
      case "child":
        type = CategoryType.child;
        break;
      case "study":
        type = CategoryType.study;
        break;
      case "medicine":
        type = CategoryType.medicine;
        break;
      case "book":
        type = CategoryType.book;
        break;
      case "food":
        type = CategoryType.food;
        break;
      case "other":
        type = CategoryType.other;
        break;
    }
    return type;
  }
}

extension ParseImagePath on CategoryType {
  String toImagePath() {
    return "assets/images/category_${toShortString()}.png";
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
