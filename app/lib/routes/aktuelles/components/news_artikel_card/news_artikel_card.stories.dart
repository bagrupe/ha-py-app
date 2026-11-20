import 'package:app/routes/aktuelles/components/news_artikel_card/news_artikel_card.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'News Artikel Card', type: NewsArtikelCard)
Widget newsArtikelCard(BuildContext context) => const SizedBox(
  height: 240,
  child: NewsArtikelCard(
    quelle: 'Hameln-Pyrmont',
    title: 'Löwe im Zoo entlaufen',
    imageUrl:
        'https://images.pexels.com/photos/774731/pexels-photo-774731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  ),
);
