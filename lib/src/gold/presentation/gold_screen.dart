import 'package:flutter/material.dart';
import 'package:gold_stream_app/src/gold/presentation/widgets/gold_header.dart';
import 'package:intl/intl.dart';
import 'package:gold_stream_app/src/gold/data/fake_gold_api.dart';
import 'dart:async';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  late StreamSubscription<double> _subscription;
  double? _goldPrice;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _subscription = getGoldPriceStream().listen(
      (price) {
        setState(() {
          _goldPrice = price;
          _loading = false;
          _error = null;
        });
      },
      onError: (err) {
        setState(() {
          _error = err.toString();
          _loading = false;
        });
      },
    );

    // Teste im initState:
    getGoldPriceStream().listen((price) {
      debugPrint('Goldpreis: $price');
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_loading) {
      content = CircularProgressIndicator();
    } else if (_error != null) {
      content = Text('Error: $_error');
    } else if (_goldPrice == null) {
      content = Text('Kein Kurs verfügbar');
    } else {
      content = Text(
        NumberFormat.simpleCurrency(locale: 'de_DE').format(_goldPrice),
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoldHeader(),
              SizedBox(height: 20),
              Text(
                'Live Kurs:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
