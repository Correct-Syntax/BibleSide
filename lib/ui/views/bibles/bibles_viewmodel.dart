import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/bibles_service.dart';
import '../../../services/side_navigation_service.dart';

class BiblesViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _sideNavigationService = locator<SideNavigationService>();
  final _biblesService = locator<BiblesService>();

  int get currentIndex => _sideNavigationService.currentIndex;

  String get primaryAreaBible => _biblesService.primaryAreaBible;
  String get secondaryAreaBible => _biblesService.secondaryAreaBible;

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  void setPrimaryAreaBible(String bibleCode) {
    _biblesService.setPrimaryAreaBible(bibleCode);
    rebuildUi();
  }

  void setSecondaryAreaBible(String bibleCode) {
    _biblesService.setSecondaryAreaBible(bibleCode);
    rebuildUi();
  }

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.navigateToReaderView();
  }
}
