import 'package:flutter/material.dart';
import 'package:magento_flutter/screens/home.dart';
import 'blocs/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Magento Shop',
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = Provider.of(context);
          bloc.fetchHomeConfig();

          return Home();
        },
      );
    }
  }
}
