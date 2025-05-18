import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speakup/common/widgets/appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('marker_1'),
        position: LatLng(51.1684126,71.4377708),
    ),
      Marker(
        markerId: const MarkerId('marker_2'),
        position: LatLng(51.110174,71.4405484),
    ),
      Marker(
        markerId: const MarkerId('marker_3'),
        position: LatLng(51.1458321,71.391254),
    ),
      Marker(
        markerId: const MarkerId('marker_4'),
        position: LatLng(51.1404791,71.4816291),
    ),
      Marker(
        markerId: const MarkerId('marker_5'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_6'),
        position: LatLng(51.1584428,71.4392943),
      ),
      Marker(
        markerId: const MarkerId('marker_7'),
        position: LatLng(51.1645947,71.4210839),
      ),
      Marker(
        markerId: const MarkerId('marker_8'),
        position: LatLng(51.1141434,71.419799),
      ),
      Marker(
        markerId: const MarkerId('marker_9'),
        position: LatLng(51.0968369,71.4283003),
      ),
      Marker(
        markerId: const MarkerId('marker_10'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_11'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_12'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_13'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_14'),
        position: LatLng(51.1318099,71.4431659),
      ),
      Marker(
        markerId: const MarkerId('marker_15'),
        position: LatLng(43.2279509,76.9298164),
      ),
      Marker(
        markerId: const MarkerId('marker_16'),
        position: LatLng(43.2483956,76.9242436),
      ),
      Marker(
        markerId: const MarkerId('marker_17'),
        position: LatLng(43.2588596,76.9215298),
      ),
      Marker(
        markerId: const MarkerId('marker_18'),
        position: LatLng(43.2647393,76.9418947),
      ),
      Marker(
        markerId: const MarkerId('marker_19'),
        position: LatLng(43.1954553,76.9166263),
      ),
      Marker(
        markerId: const MarkerId('marker_20'),
        position: LatLng(43.2607363,76.9382604),
      ),
      Marker(
        markerId: const MarkerId('marker_21'),
        position: LatLng(43.2631766,76.9407591),
      ),
      Marker(
        markerId: const MarkerId('marker_22'),
        position: LatLng(43.2647393,76.9418947),
      ),
      Marker(
        markerId: const MarkerId('marker_23'),
        position: LatLng(43.2625185,76.917988),
      ),
      Marker(
        markerId: const MarkerId('marker_24'),
        position: LatLng(43.259426,76.923469),
      ),
      Marker(
        markerId: const MarkerId('marker_25'),
        position: LatLng(43.2531557,76.9462131),
      ),
      Marker(
        markerId: const MarkerId('marker_26'),
        position: LatLng(43.2441716,76.9029286),
      ),
      Marker(
        markerId: const MarkerId('marker_27'),
        position: LatLng(43.257839,76.936721),
      ),
      Marker(
        markerId: const MarkerId('marker_28'),
        position: LatLng(43.2491872,76.9153096),
      ),



  };
  String dropdownValue = 'Алматы';

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

  }

  void _onDropDownChanged(String? city) {
    setState(() {
      dropdownValue = city!;
      LatLng target;
      if (city == 'Алматы') {
        target = LatLng(43.270447, 76.887133);
      } else {
        target = LatLng(51.140712, 71.427101);
      }
      mapController.moveCamera(CameraUpdate.newLatLng(target));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SAppBar(
        page: "Map",
        title: "Логопедические  центры",
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(43.270447, 76.887133),
              zoom: 12.0,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 50.0,
            left: 15.0,
            child: Text(widget.text),
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: DropdownButton<String>(
              value: dropdownValue,
              onChanged: _onDropDownChanged,
              items: <String>['Алматы', 'Астана']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}