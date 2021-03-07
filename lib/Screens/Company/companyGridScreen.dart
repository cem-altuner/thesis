import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:redux/redux.dart';
import 'package:thesis/Classes/catalog.dart';
import 'package:thesis/Classes/company.dart';
import 'package:thesis/Redux/actions.dart';
import 'package:thesis/SharedComponents/alertDialog.dart';
import 'package:thesis/SharedComponents/waitScreen.dart';
import 'package:thesis/keys/myKeys.dart';
import 'package:thesis/model/appState.dart';
import 'package:thesis/services/dio.dart';
import 'package:thesis/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:getwidget/types/gf_loader_type.dart';

class CompanyGridScreen extends StatefulWidget {
  @override
  _CompanyGridScreenState createState() => _CompanyGridScreenState();
}

class _CompanyGridScreenState extends State<CompanyGridScreen> {
  List<Company> companyList;
  int currentIndex = 0;
  AsyncMemoizer _memorizer = AsyncMemoizer<List<bool>>();

  Widget ComCridView() {
    ColorFilter filter =
        ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        this.companyList = state.companyList;
        return Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Text(
                      "Click Over The Catalouge to discover this week's offers!",
                      textAlign: TextAlign.center,
                      style: kTextTextStyle,
                    ),
                    SizedBox(height: 80.0),
                    InkWell(
                      onTap: () {
                        try {
                          final selectedCatalogIndex = state.catalogList
                              .indexWhere((catalog) =>
                                  catalog.company ==
                                  this.companyList[currentIndex].id);
                          final selectedCatalogID =
                              state.catalogList[selectedCatalogIndex].id;
                          StoreProvider.of<AppState>(context).dispatch(
                              changeCurrentCatalog(selectedCatalogID));
                          Navigator.pushNamed(context, 'catalog');
                        } catch (e) {
                          Alert.showLogin('Catalog is none');
                        }
                      },
                      child: GFCarousel(
                        aspectRatio: 4 / 3,
                        items: companyList.map(
                          (company) {
                            return Container(
                              decoration: tileDecoration,
                              margin: EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network(
                                    company.logo
                                        .replaceAll("/api/companies", ""),
                                    fit: BoxFit.cover,
                                    width: 500.0),
                              ),
                            );
                          },
                        ).toList(),
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ))
        ]);
      },
    );
  }

  //Fetch Companies
  Future<bool> fCompanies(Store store) async {
    final response = await dio.get('companies/');
    AppState state = store.state;
    if (response.statusCode == 200) {
      List jsonResponse = response.data;
      List<Company> companyList =
          jsonResponse.map((company) => Company.fromJson(company)).toList();
      store.dispatch(changeCompanyList(companyList));
      return true;
    } else {
      return false;
    }
  }

  //Fetch Catalogs
  Future<bool> fCatalogs(Store store) async {
    final response = await dio.get('catalogs/');
    AppState state = store.state;
    if (response.statusCode == 200) {
      List jsonResponse = response.data;
      List<Catalog> catalogList =
          jsonResponse.map((company) => Catalog.fromJson(company)).toList();
      store.dispatch(changeCatalogList(catalogList));
      return true;
    } else {
      return false;
    }
  }

  //Fetch data run once
  _fetchData(Store store) {
    return this._memorizer.runOnce(() async {
      try {
        return await Future.wait([fCatalogs(store), fCompanies(store)])
            .timeout(Duration(seconds: 2), onTimeout: () {
          return [false];
        });
      } on DioError {
        Alert.showConnectionAlert();
        return [false];
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    Store store = StoreProvider.of<AppState>(context);
    return Scaffold(
        appBar: GFAppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF4527A0),
          title: Text("Companies"),
        ),
        body: FutureBuilder(
          future: this._fetchData(store),
          builder: (
            context,
            AsyncSnapshot<dynamic> snapshot,
          ) {
            if (!snapshot.hasData) {
              return Center(
                child: GFLoader(type: GFLoaderType.circle),
              );
            }

            if (snapshot.data.every((result) => result == true)) {
              return ComCridView();
            } else {
              NoomiKeys.navKey.currentState.pushNamed('home');
              return Center(
                child: GFLoader(type: GFLoaderType.circle),
              );
            }
          },
        ));
  }
}
