import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:snap_example/constant/dimens.dart';
import 'package:snap_example/constant/text_style.dart';
import 'package:snap_example/gen/assets.gen.dart';
import '../widget/widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CurrentwidgetStates {
  CurrentwidgetStates._();

  static const stateSelectOrgin = 0;
  static const stateSelectDestination = 1;
  static const stateSelectDriver = 2;
}

class _MyHomePageState extends State<MyHomePage> {
  List currentWidgetList = [CurrentwidgetStates.stateSelectOrgin];
  List<GeoPoint> geoPoint = [];
  String distance = 'در حال محاسبه....';
  String desAddress = 'در حال محاسبه....';
  String orgAddress = 'در حال محاسبه....';
  Widget markerIcon = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 48,
  ); 
   Widget markerOrgin = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 48,
  );
  Widget markerdes = SvgPicture.asset(
    Assets.icons.destination,
    height: 100,
    width: 48,
  );

  MapController mapController = MapController(
      initPosition:
          GeoPoint(latitude: 35.7367516373, longitude: 51.2911096718));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox.expand(
            child: OSMFlutter(
           
                mapIsLoading:
                    SpinKitCircle(color: Color.fromARGB(255, 2, 207, 36)),
                controller: mapController,
                osmOption: OSMOption(
                    isPicker: true,
                    markerOption: MarkerOption(
                        advancedPickerMarker: MarkerIcon(
                      iconWidget: markerOrgin,
                    )),
                    zoomOption: ZoomOption(
                        stepZoom: 1,
                        maxZoomLevel: 18,
                        minZoomLevel: 8,
                        initZoom: 15))),
          ),
          currentWidget(),
          MyBackButton(
            onPressed: () {
             
                switch (currentWidgetList.last) {
                  case CurrentwidgetStates.stateSelectOrgin:
                    break; 
                     case CurrentwidgetStates.stateSelectDestination:
                     geoPoint.removeLast();
                     markerIcon=markerOrgin;
                    break; 
                     case CurrentwidgetStates.stateSelectDriver:
                     mapController.advancedPositionPicker();
                     mapController.removeMarker(geoPoint.last);
                      geoPoint.removeLast();
                        markerIcon=markerdes;
                    break;
                 
                }

setState(() {
  currentWidgetList.removeLast();
});




            },
          ),
        ],
      )),
    );
  }

  Widget currentWidget() {
    Widget widget = origin();

    switch (currentWidgetList.last) {
      case CurrentwidgetStates.stateSelectOrgin:
        widget = origin();
        break;

      case CurrentwidgetStates.stateSelectDestination:
        widget = distination();
        break;

      case CurrentwidgetStates.stateSelectDriver:
        widget = driver();
        break;
    }

    return widget;
  }

  Positioned origin() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () async {
                GeoPoint originGeopoint = await mapController
                    .getCurrentPositionAdvancedPositionPicker();
                geoPoint.add(originGeopoint);

                markerIcon = markerdes;
                setState(() {
                  currentWidgetList
                      .add(CurrentwidgetStates.stateSelectDestination);
                });
                mapController.init();
              },
              child: Text(
                'انتخاب مبدا',
                style: MyTextStyle.bottun,
              )),
        ));
  }

  Positioned distination() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () async {
                await mapController
                    .getCurrentPositionAdvancedPositionPicker()
                    .then((value) {
                  geoPoint.add(value);
                });

                mapController.cancelAdvancedPositionPicker();

                await mapController.addMarker(geoPoint.first,
                    markerIcon: MarkerIcon(
                      iconWidget: markerOrgin,
                    ));

                await mapController.addMarker(geoPoint.last,
                    markerIcon: MarkerIcon(
                      iconWidget: markerdes,
                    ));

                setState(() {
                  currentWidgetList.add(CurrentwidgetStates.stateSelectDriver);
                });

                await distance2point(geoPoint.first, geoPoint.last)
                    .then((value) {
                  setState(() {
                    if (value <= 1000) {
                      distance = ' متر فاصله مبدا تا مقصد  ${value.toInt()}';
                    } else {
                      distance =
                          ' کیلومتر فاصله مبدا تا مقصد  ${value ~/ 1000}';
                    }
                  });
                });
                getAddress();
              },
              child: Text(
                'انتخاب مقصد',
                style: MyTextStyle.bottun,
              )),
        ));
  }

  Positioned driver() {
    mapController.zoomOut();
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: Column(
            children: [
              Container(
                height: 58,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.medium),
                    color: Colors.white),
                child: Text(orgAddress),
              ),
              SizedBox(
                height: Dimens.small,
              ),
              Container(
                height: 58,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.medium),
                    color: Colors.white),
                child: Text(desAddress),
              ),
              SizedBox(
                height: Dimens.small,
              ),
              Container(
                height: 58,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.medium),
                    color: Colors.white),
                child: Text(distance),
              ),
              SizedBox(
                height: Dimens.small,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'درخواست راننده',
                      style: MyTextStyle.bottun,
                    )),
              ),
            ],
          ),
        ));
  }

  getAddress() async {
    try {
      await placemarkFromCoordinates(
              geoPoint.last.latitude, geoPoint.last.longitude,
              localeIdentifier: 'fa')
          .then((List<Placemark> plist) {
        setState(() {
          desAddress =
              '${plist.first.locality}  ${plist.first.thoroughfare} ${plist[2].name}';
        });
      });  
       await placemarkFromCoordinates(
              geoPoint.first.latitude, geoPoint.first.longitude,
              localeIdentifier: 'fa')
          .then((List<Placemark> plist) {
        setState(() {
          orgAddress =
              '${plist.first.locality}  ${plist.first.thoroughfare} ${plist[2].name}';
        });
      });
    } catch (e) {
      orgAddress='ادرس یافت نشد';
      desAddress='ادرس یافت نشد';
    }
  }
}
