import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../blocs/provider.dart';
import '../widgets/refresh.dart';
import '../widgets/home_swiper.dart';
import '../models/product_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Magento Shop'),
      ),
      body: homeBody(bloc),
    );
  }

  Widget homeBody(Bloc bloc) {
    return ListView(
      children: <Widget>[
        buildSlider(bloc),
        featuredProducts(bloc),
      ],
    );
  }

  Widget productsList(Future<List<ProductModel>> productsFuture) {
    return FutureBuilder(
      future: productsFuture,
      builder: (context, AsyncSnapshot<List<ProductModel>> productsSnapshot) {
        if (!productsSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

//        List<Widget> children = [];
//        productsSnapshot.data.forEach((product) {
//          children.add();
//        });

        return Container(
          height: 185,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productsSnapshot.data.length,
            itemBuilder: (context, index) {
              final product = productsSnapshot.data[index];
              return Container(
                width: 115,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: '${config.getProductMediaUrl()}/${product.image}',
                      placeholder: CircularProgressIndicator(),
                      errorWidget: Icon(Icons.error),
                      height: 130,
                      width: 115,
                    ),
//                Image.network(
//                  '${config.getProductMediaUrl()}/${product.image}',
//                  height: 130,
//                  width: 115,
//                ),
                    Container(
                        height: 35,
                        margin: EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
              );
            },
          ),
        );


//        return Container(
//          height: 185,
//          child: ListView(
//            scrollDirection: Axis.horizontal,
//            children: children,
//          ),
//        );
      },
    );
  }

  Widget featuredProducts(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.featuredCategoires,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Widget> children = [];
        snapshot.data.forEach((title, productsFuture) {
          children.add(Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              productsList(productsFuture),
            ],
          ));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildSlider(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.homeConfig,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          print('home loading');
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final slider = snapshot.data['slider'];

        return Refresh(
          child: Column(
            children: <Widget>[
              HomeSwiper(swiperConfig: slider),
            ],
          ),
        );
      },
    );
  }
}
