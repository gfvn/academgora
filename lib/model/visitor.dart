class Visitor {
  String name;
  int age;

  Visitor(this.name, this.age);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Visitor &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}