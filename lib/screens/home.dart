import 'package:flutter/material.dart';
import '../blocs/provider.dart';
import '../widgets/refresh.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Magento Shop'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.homeConfig,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          print('loading');
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        print(snapshot.data);

        return Refresh(
          child: ListView(
            children: <Widget>[
              Text('done'),
            ],
          ),
        );
      },
    );
  }
}
