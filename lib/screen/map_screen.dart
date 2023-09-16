import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
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
  Widget markerIcon = SvgPicture.asset(
    Assets.icons.origin,
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
                      iconWidget: markerIcon,
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
              if (currentWidgetList.length > 1) {
                setState(() {
                  currentWidgetList.removeLast();
                });
              }
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

                markerIcon = SvgPicture.asset(
                  Assets.icons.destination,
                  height: 100,
                  width: 48,
                );
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
              onPressed: () {
                setState(() {
                  currentWidgetList.add(CurrentwidgetStates.stateSelectDriver);
                });
              },
              child: Text(
                'انتخاب مقصد',
                style: MyTextStyle.bottun,
              )),
        ));
  }

  Positioned driver() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(Dimens.large),
          child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'درخواست راننده',
                style: MyTextStyle.bottun,
              )),
        ));
  }
}
