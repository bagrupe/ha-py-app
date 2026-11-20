// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/common/theme.stories.dart' as _app_common_theme_stories;
import 'package:app/components/_stories/button.stories.dart'
    as _app_components__stories_button_stories;
import 'package:app/components/bottom_navigation_bar/bottom_navigation_bar.stories.dart'
    as _app_components_bottom_navigation_bar_bottom_navigation_bar_stories;
import 'package:app/components/common_app_bar/common_app_bar.stories.dart'
    as _app_components_common_app_bar_common_app_bar_stories;
import 'package:app/components/filter_button/filter_button.stories.dart'
    as _app_components_filter_button_filter_button_stories;
import 'package:app/components/heading/heading.stories.dart'
    as _app_components_heading_heading_stories;
import 'package:app/components/heading/heading_with_divider.stories.dart'
    as _app_components_heading_heading_with_divider_stories;
import 'package:app/components/heading/subheading.stories.dart'
    as _app_components_heading_subheading_stories;
import 'package:app/components/map/map.stories.dart'
    as _app_components_map_map_stories;
import 'package:app/components/searchbar/searchbar.stories.dart'
    as _app_components_searchbar_searchbar_stories;
import 'package:app/components/select_buttons/select_buttons.stories.dart'
    as _app_components_select_buttons_select_buttons_stories;
import 'package:app/routes/aktuelles/components/news_artikel_card/news_artikel_card.stories.dart'
    as _app_routes_aktuelles_components_news_artikel_card_news_artikel_card_stories;
import 'package:app/routes/antraege/components/antrag_card/antrag_card.stories.dart'
    as _app_routes_antraege_components_antrag_card_antrag_card_stories;
import 'package:app/routes/antraege/components/antrag_detail_status_chip/antrag_detail_status_chip.stories.dart'
    as _app_routes_antraege_components_antrag_detail_status_chip_antrag_detail_status_chip_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/checkbox_list_field/checkbox_list_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_checkbox_list_field_checkbox_list_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/date_field/date_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_date_field_date_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/image_field/image_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/location_field/location_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_location_field_location_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/signature_field/signature_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_signature_field_signature_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/text_field/text_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_text_field_text_field_stories;
import 'package:app/routes/antraege/components/schritte/formular_fields/time_field/time_field.stories.dart'
    as _app_routes_antraege_components_schritte_formular_fields_time_field_time_field_stories;
import 'package:app/routes/maengel/components/maengel_liste_item.stories.dart'
    as _app_routes_maengel_components_maengel_liste_item_stories;
import 'package:app/routes/profil/inhalte_und_benachrichtigungen/components/abfall.stories.dart'
    as _app_routes_profil_inhalte_und_benachrichtigungen_components_abfall_stories;
import 'package:app/routes/termine/components/termin_card/termin_card.stories.dart'
    as _app_routes_termine_components_termin_card_termin_card_stories;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'components',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'bottom_navigation_bar',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'app_bottom_navigation_bar',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'AppBottomNavigationBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'BottomNavigation',
                    builder:
                        _app_components_bottom_navigation_bar_bottom_navigation_bar_stories
                            .bottomNavigation,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'common_app_bar',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'CommonAppBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Common App Bar',
                builder: _app_components_common_app_bar_common_app_bar_stories
                    .commonAppBar,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'filter_button',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FilterButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Filter',
                builder: _app_components_filter_button_filter_button_stories
                    .filterButton,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'heading',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'Heading',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Theme',
                builder: _app_common_theme_stories.heading,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Titel',
                builder: _app_components_heading_heading_stories.heading,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'HeadingWithDivider',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Titel',
                builder: _app_components_heading_heading_with_divider_stories
                    .headingWithDivider,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'TitelInPrimaryColor',
                builder: _app_components_heading_heading_with_divider_stories
                    .headingWithDividerInPrimary,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SubHeading',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Background & Icon Button',
                builder: _app_components_heading_subheading_stories
                    .subheadingWithButton,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Titel',
                builder: _app_components_heading_subheading_stories.subheading,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'map',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'KommunalAppMap',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Map',
                builder: _app_components_map_map_stories.baseMap,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'searchbar',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'Searchbar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Searchbar',
                builder: _app_components_searchbar_searchbar_stories.searchbar,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'select_buttons',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'SelectButtons',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'ToggleButtons',
                builder: _app_components_select_buttons_select_buttons_stories
                    .toggleButtons,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'material',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'OutlinedButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'OutlinedButton',
            builder: _app_components__stories_button_stories.outlinedButton,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'routes',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'aktuelles',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'components',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'news_artikel_card',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'NewsArtikelCard',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'News Artikel Card',
                        builder:
                            _app_routes_aktuelles_components_news_artikel_card_news_artikel_card_stories
                                .newsArtikelCard,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'antraege',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'components',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'antrag_card',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'AntragCard',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Antrag in Bearbeitung',
                        builder:
                            _app_routes_antraege_components_antrag_card_antrag_card_stories
                                .antragInBearbeitung,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'antrag_detail_status_chip',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'AntragDetailStatusChip',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Antrag Detail Status Chip',
                        builder:
                            _app_routes_antraege_components_antrag_detail_status_chip_antrag_detail_status_chip_stories
                                .antragDetailStatusChip,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'schritte',
                children: [
                  _widgetbook.WidgetbookFolder(
                    name: 'formular_fields',
                    children: [
                      _widgetbook.WidgetbookFolder(
                        name: 'checkbox_list_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularCheckboxListField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'Checkbox Field',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_checkbox_list_field_checkbox_list_field_stories
                                        .checkboxField,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'date_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularDateField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'DateField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_date_field_date_field_stories
                                        .dateField,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'image_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularUploadField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'DefaultImageField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories
                                        .defaultImageField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'DokumentField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories
                                        .documentField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'FotoField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories
                                        .fotoField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'MultiImageField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories
                                        .multiImageField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'UnterschriftField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_image_field_image_field_stories
                                        .unterschriftField,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'location_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularLocationField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'LocationField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_location_field_location_field_stories
                                        .locationField,
                              ),
                            ],
                          ),
                          _widgetbook.WidgetbookComponent(
                            name: 'SelectionMap',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'SelectionMap',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_location_field_location_field_stories
                                        .selectionMap,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'signature_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularSignatureField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'SigningField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_signature_field_signature_field_stories
                                        .signingField,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'text_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularTextField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'MultilineField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_text_field_text_field_stories
                                        .multilineTextField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'SelectField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_text_field_text_field_stories
                                        .selectTextField,
                              ),
                              _widgetbook.WidgetbookUseCase(
                                name: 'TextField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_text_field_text_field_stories
                                        .textField,
                              ),
                            ],
                          ),
                        ],
                      ),
                      _widgetbook.WidgetbookFolder(
                        name: 'time_field',
                        children: [
                          _widgetbook.WidgetbookComponent(
                            name: 'FormularTimeField',
                            useCases: [
                              _widgetbook.WidgetbookUseCase(
                                name: 'TimeField',
                                builder:
                                    _app_routes_antraege_components_schritte_formular_fields_time_field_time_field_stories
                                        .timeField,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'maengel',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'components',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'MaengelListeItem',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'MängelListeItem',
                    builder:
                        _app_routes_maengel_components_maengel_liste_item_stories
                            .maengelListeItem,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'profil',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'inhalte_und_benachrichtigungen',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'components',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'AbfallBenachrichtigungen',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'AbfallBenachrichtigungen',
                        builder:
                            _app_routes_profil_inhalte_und_benachrichtigungen_components_abfall_stories
                                .abfallBenachrichtigungen,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'termine',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'components',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'termin_card',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'TerminCard',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'MissingImage',
                        builder:
                            _app_routes_termine_components_termin_card_termin_card_stories
                                .terminCardMissingImage,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'MultipleTermine',
                        builder:
                            _app_routes_termine_components_termin_card_termin_card_stories
                                .terminCardMultipleTermine,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'WithImage',
                        builder:
                            _app_routes_termine_components_termin_card_termin_card_stories
                                .terminCardWithImage,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
