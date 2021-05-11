class SelectSize {
  String size;

  List<void Function()> listeners = [];

  void addListener(void Function() f) => listeners.add(f);

  void doSelect(String size) {
    this.size = size;
    listeners.forEach((listener) => listener()); // triggers listeners
  }
}
