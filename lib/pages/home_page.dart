import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Allow scrolling if needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
            children: [
              const SizedBox(height: 10),

              /// **Service Section**
              _ServiceTitle("The Services", ""),
              const SizedBox(height: 10),

              /// **Services Grid**
              Row(
                children: [
                  Expanded(child: _buildServiceTile('Repairs', Icons.build)),
                  Expanded(
                    child: _buildServiceTile(
                      'Cleaning',
                      Icons.cleaning_services,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildServiceTile(
                      'Electrical',
                      Icons.electrical_services,
                    ),
                  ),
                  Expanded(
                    child: _buildServiceTile('Plumbing', Icons.plumbing),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// **Other Service Titles**
              _ServiceTitle("The Repairs", "See All"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  children: [
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _ServiceTitle("Cleaning", "See All"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  children: [
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _ServiceTitle("The Electrical", "See All"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  children: [
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _ServiceTitle("The Plumbing", "See All"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  children: [
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                    SizedBox(width: 10),
                    _ServiceBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ServiceBox() {
    return Container(
      width: 270,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("The Name", style: const TextStyle(fontSize: 15)),
              Text("The Work", style: const TextStyle(fontSize: 15)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Call",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **Service Title Widget**
  Widget _ServiceTitle(String title, String seeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            print("$title See All tapped");
          },
          child: Text(
            seeAll,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(2, 173, 103, 1.0),
            ),
          ),
        ),
      ],
    );
  }

  /// **Service Tile Widget**
  Widget _buildServiceTile(String title, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          print('$title tapped');
        },
      ),
    );
  }
}
