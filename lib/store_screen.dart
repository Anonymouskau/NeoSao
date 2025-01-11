import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'store_provider.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreProvider>(context, listen: false).fetchStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Stores")),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.white ),
        selectedLabelStyle: TextStyle(color: Colors.white),
      items: 
      <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.orange,

            icon: Icon(color: Colors.white,Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(color:Colors.white,Icons.menu),
            label:'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
      ]),
      body: storeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Map Section
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(16.688653, 74.272591), // Default Location
                      zoom: 12,
                    ),
                    markers: Set.from(storeProvider.markers),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),
                // Store List Section
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: storeProvider.stores.length,
                    itemBuilder: (context, index) {
                      final store = storeProvider.stores[index];
                      return Card(
                        child: ListTile(
                          title: Text(store.storeLocation),
                          subtitle: Text(store.storeAddress),
                          onTap: () {
                            storeProvider.selectStore(store, _mapController);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
