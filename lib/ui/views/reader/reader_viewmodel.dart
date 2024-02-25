import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../services/bibles_service.dart';
import '../../../services/reader_service.dart';
import '../../../services/settings_service.dart';
import '../../../services/side_navigation_service.dart';

class ReaderViewModel extends ReactiveViewModel {
  final _sideNavigationService = locator<SideNavigationService>();
  final _biblesService = locator<BiblesService>();
  final _readerService = locator<ReaderService>();
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  int get currentIndex => _sideNavigationService.currentIndex;

  String get primaryAreaBible => _biblesService.primaryAreaBible;
  String get bookCode => _biblesService.bookCode;
  int get chapter => _biblesService.chapterNumber;

  int get sectionIndex => _biblesService.chapterNumber; // TODO

  bool get showSecondaryArea => _settingsService.showSecondaryArea;

  ReaderViewModel({required this.context});

  final BuildContext context;

  late ScrollController topController;
  late ScrollController bottomController;
  late LinkedScrollControllerGroup parentController;

  final Key downListKey = UniqueKey();

  PagingController<int, Map<String, dynamic>> primaryPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> primaryPagingDownController = PagingController(
    firstPageKey: 1,
  );

  PagingController<int, Map<String, dynamic>> secondaryPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> secondaryPagingDownController = PagingController(
    firstPageKey: 1,
  );

  Future<void> initilize() async {
    parentController = LinkedScrollControllerGroup();
    topController = parentController.addAndGet();
    bottomController = parentController.addAndGet();

    await refreshReader();
  }

  Future<void> refreshReader() async {
    await _biblesService.reloadBiblesJson();

    // Primary area
    primaryPagingUpController = PagingController(
      firstPageKey: sectionIndex,
    );
    primaryPagingUpController.addPageRequestListener((pageKey) {
      fetchUpChapter(pageKey, Area.primary);
    });
    primaryPagingDownController = PagingController(
      firstPageKey: sectionIndex,
    );
    primaryPagingDownController.addPageRequestListener((pageKey) {
      fetchDownChapter(pageKey, Area.primary);
    });

    // Secondary area
    secondaryPagingUpController = PagingController(
      firstPageKey: sectionIndex,
    );
    secondaryPagingUpController.addPageRequestListener((pageKey) {
      fetchUpChapter(pageKey, Area.secondary);
    });
    secondaryPagingDownController = PagingController(
      firstPageKey: sectionIndex,
    );
    secondaryPagingDownController.addPageRequestListener((pageKey) {
      fetchDownChapter(pageKey, Area.secondary);
    });

    // Refresh for first section/chapter
    await fetchDownChapter(sectionIndex, Area.primary);
    await fetchDownChapter(sectionIndex, Area.secondary);

    //log(sectionIndex.toString());

    rebuildUi();
  }

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  Future<void> fetchUpChapter(int pageKey, Area area) async {
    pageKey -= 1;

    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = pageKey == 1;
    final int nextPageKey = pageKey;

    if (area == Area.primary) {
      if (isLastPage) {
        primaryPagingUpController.appendLastPage(newPage);
      } else {
        primaryPagingUpController.appendPage(newPage, nextPageKey);
      }
    } else if (area == Area.secondary) {
      if (isLastPage) {
        secondaryPagingUpController.appendLastPage(newPage);
      } else {
        secondaryPagingUpController.appendPage(newPage, nextPageKey);
      }
    }
    updatePagingControllers();

    log('Fetched UP for $area');
  }

  Future<void> fetchDownChapter(int pageKey, Area area) async {
    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = newPage.isEmpty;
    final int nextPageKey = pageKey + 1;

    if (area == Area.primary) {
      if (isLastPage) {
        primaryPagingDownController.appendLastPage(newPage);
      } else {
        primaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    } else if (area == Area.secondary) {
      if (isLastPage) {
        secondaryPagingDownController.appendLastPage(newPage);
      } else {
        secondaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    }
    updatePagingControllers();

    log('Fetched DOWN for $area');
  }

  void setChapter(dynamic chapter) {
    if (chapter.runtimeType == String) {
      _biblesService.setChapter(int.parse(chapter));
    } else if (chapter.runtimeType == int) {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  List<Map<String, dynamic>> getPaginatedVerses(int pageKey, Area area) {
    return _readerService.getNewPage(context, pageKey, area);
  }

  String getcurrentBookName() {
    return _biblesService.bookCodeToBook(bookCode);
  }

  String getcurrentNavigationString(String bookCode, int chapter) {
    final navStr = '${_biblesService.bookCodeToBook(bookCode)} $chapter';
    return navStr;
  }

  void onNavigationBtn() {
    _navigationService.navigateToReaderNavigationView();
  }

  void onBiblesBtn() {
    _navigationService.navigateToBiblesView();
  }

  void toggleSecondaryArea() {
    _settingsService.setShowSecondaryArea(!showSecondaryArea);
    rebuildUi();
  }

  void updatePagingControllers() {
    primaryPagingUpController.notifyListeners();
    primaryPagingDownController.notifyListeners();

    secondaryPagingUpController.notifyListeners();
    secondaryPagingDownController.notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_biblesService];
}
