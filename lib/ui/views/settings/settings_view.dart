import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../../common/themes.dart';
import '../../common/ui_helpers.dart';
import 'settings_viewmodel.dart';
import 'widgets/settings_text_preview/settings_text_preview.dart';
import 'widgets/settings_theme_item/settings_theme_item.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.appColors.background,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          title: isPortrait
              ? null
              : Text(
                  'Settings',
                  style: TextStyle(
                    color: context.theme.appColors.primary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        backgroundColor: context.theme.appColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPortrait)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SettingsTextPreview(),
                    ],
                  ),
                  Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                  // Text scaling
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Text scaling',
                                style: TextStyle(
                                  color: context.theme.appColors.primary,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                '${viewModel.textScaling.toStringAsFixed(1)}x',
                                style: TextStyle(
                                  color: context.theme.appColors.secondary,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIcons.magnifyingGlassMinus(PhosphorIconsStyle.regular),
                                color: context.theme.appColors.primary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    thumbColor: context.theme.appColors.sliderAccent,
                                    activeTrackColor: context.theme.appColors.sliderAccent,
                                    inactiveTrackColor: context.theme.appColors.divider,
                                    overlayColor: Colors.transparent,
                                  ),
                                  child: Slider(
                                    value: viewModel.textScaling,
                                    min: 1.0,
                                    max: 2.0,
                                    onChanged: viewModel.changeTextScaling,
                                  ),
                                ),
                              ),
                              PhosphorIcon(
                                PhosphorIcons.magnifyingGlassPlus(PhosphorIconsStyle.regular),
                                color: context.theme.appColors.primary,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                  // // Show special markings
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Show OET-LV special markings',
                  //         style: TextStyle(
                  //           color: context.theme.appColors.primary,
                  //           fontSize: 16.0,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       Switch(
                  //         activeColor: context.theme.appColors.background,
                  //         activeTrackColor: context.theme.appColors.switchBackground,
                  //         inactiveThumbColor: context.theme.appColors.primary,
                  //         inactiveTrackColor: context.theme.appColors.background,
                  //         trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                  //           if (states.contains(MaterialState.selected)) {
                  //             return context.theme.appColors.switchBackground;
                  //           }
                  //           return context.theme.appColors.primary;
                  //         }),
                  //         value: viewModel.showMarks,
                  //         onChanged: viewModel.changeShowMarks,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   height: 0,
                  //   color: context.theme.appColors.divider,
                  // ),
                  // // Show chapters and verses
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'Show chapters and verses',
                  //         style: TextStyle(
                  //           color: context.theme.appColors.primary,
                  //           fontSize: 16.0,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       Switch(
                  //         activeColor: context.theme.appColors.background,
                  //         activeTrackColor: context.theme.appColors.switchBackground,
                  //         inactiveThumbColor: context.theme.appColors.primary,
                  //         inactiveTrackColor: context.theme.appColors.background,
                  //         trackOutlineColor: MaterialStateProperty.resolveWith((states) {
                  //           if (states.contains(MaterialState.selected)) {
                  //             return context.theme.appColors.switchBackground;
                  //           }
                  //           return context.theme.appColors.primary;
                  //         }),
                  //         value: viewModel.showChaptersAndVerses,
                  //         onChanged: viewModel.changeShowChaptersAndVerses,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                  // INTERFACE
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 6.0, left: 12.0),
                    child: Text(
                      'INTERFACE',
                      style: TextStyle(
                        color: context.theme.appColors.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 12.0),
                    child: Text(
                      'Theme',
                      style: TextStyle(
                        color: context.theme.appColors.primary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SettingsThemeItem(
                          isSelected: !viewModel.isDarkTheme,
                          theme: ThemeMode.light,
                          onTap: () {
                            var themeManger = getThemeManager(context);
                            viewModel.setIsDarkTheme(false);
                            themeManger.setThemeMode(ThemeMode.light);
                          },
                        ),
                        const SizedBox(width: 7.0),
                        SettingsThemeItem(
                          isSelected: viewModel.isDarkTheme,
                          theme: ThemeMode.dark,
                          onTap: () {
                            var themeManger = getThemeManager(context);
                            viewModel.setIsDarkTheme(true);
                            themeManger.setThemeMode(ThemeMode.dark);
                          },
                        ),
                      ],
                    ),
                  ),

                  // ABOUT
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 6.0, left: 12.0),
                    child: Text(
                      'ABOUT',
                      style: TextStyle(
                        color: context.theme.appColors.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                  // App version
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icon.png',
                          width: 36.0,
                          height: 36.0,
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bibleside',
                              style: TextStyle(
                                color: context.theme.appColors.primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              viewModel.isBusy ? '' : viewModel.data!,
                              style: TextStyle(
                                color: context.theme.appColors.secondary,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}
