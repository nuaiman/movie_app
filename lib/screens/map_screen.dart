import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

bool _isLoading = true;
bool? _serviceEnabled;
Location location = Location();
PermissionStatus? _permissionGranted;
LocationData? _locationData;

Future<dynamic> getLocation() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled!) _serviceEnabled = await location.requestService();

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
  }
  _locationData = await location.getLocation();
  return _locationData;
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    if (_locationData == null) {
      setState(() {
        _isLoading = true;
      });
    }
    super.initState();
    getLocation().then((value) => {
          setState(() {
            _isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: getLocation,
            //   child: const Icon(Icons.location_on),
            //   backgroundColor: Colors.amber,
            // ),
            body: Center(
              child: Flexible(
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      double.parse(_locationData!.latitude.toString()),
                      double.parse(_locationData!.longitude.toString()),
                    ),
                    zoom: 9.2,
                  ),
                  layers: [
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: LatLng(
                            double.parse(_locationData!.latitude.toString()),
                            double.parse(_locationData!.longitude.toString()),
                          ),
                          builder: (ctx) => Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    TileLayerOptions(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.app',
                    ),
                  ],
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: 'OpenStreetMap contributors',
                      onSourceTapped: null,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
