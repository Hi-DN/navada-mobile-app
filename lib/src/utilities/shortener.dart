class Shortener {
  static shortenStrTo(String? str, int wantedLength) {
    if (str!.length <= wantedLength) {
      return str;
    } else {
      return '${str.substring(0, wantedLength)}...';
    }
  }
}
