class PageProvider {
  int? _currPage = 0;
  int? get currPage => _currPage;

  bool _last = false;
  bool get last => _last;

  void setCurrPage(int currPage) {
    _currPage = currPage;
  }

  void setLast(bool last) {
    _last = last;
  }

  void refresh(Function refreshData) {
    _currPage = 0;
    refreshData();
  }
}
