import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../blocs/provider.dart';
import '../widgets/refresh.dart';
import '../config/config.dart';

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

        final slider = snapshot.data['slider'];
        final images = slider.map((slide) => slide['image']);
        final titles = slider.map((slide) => slide['title']);
        print(images);

        return Refresh(
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: <Widget>[
                        Container(
                            height: 200,
                            child: Image.network(
                              '${config.baseUrl}media/${images.elementAt(index)}',
                              fit: BoxFit.fitHeight,
                            )),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(
                              titles.elementAt(index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: images.length,
                  pagination: SwiperPagination(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
