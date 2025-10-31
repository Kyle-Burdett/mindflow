import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Resource {
  final String id;
  final String title;
  final String description;
  final String type;
  final List<String> category;
  final String url;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.url,
  });


  factory Resource.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Resource(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      type: data['type'] ?? 'article',

      category: (data['category'] is List)
          ? List<String>.from(data['category'])
          : [],
      url: data['url'] ?? '',
    );
  }
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Color backgroundColor = Color(0xFFFFF3E9);
  final Color primaryColor = const Color(0xFFDB863B);

  String activeTab = "All";

  final List<String> tabs = [
    "All",
    "Productivity",
    "Work/Life Balance",
    "Burnout",
    "Energy",
    "Stress and Anxiety",
    "Work Habits",
  ];


  final Stream<QuerySnapshot> _resourcesStream = FirebaseFirestore.instance
      .collection('resources')
      .snapshots();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {

      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Resources",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Expert advice for better wellbeing",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final tab = tabs[index];
                  final bool isActive = activeTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                    child: ElevatedButton(
                      onPressed: () => setState(() => activeTab = tab),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive ? primaryColor : Colors.white,
                        foregroundColor: isActive ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        tab,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _resourcesStream,
                builder: (context, snapshot) {

                  if (snapshot.hasError) {

                    print('❌ FIRESTORE ERROR: ${snapshot.error}');
                    return Center(child: Text('Error loading data: ${snapshot.error}'));
                  }


                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                    
                  final allResources = snapshot.data!.docs.map((doc) {

                    print('✅ FIRESTORE CONNECTED: Fetched document ID: ${doc.id}');

                    return Resource.fromFirestore(doc);
                  }).toList();

                  if (allResources.isEmpty) {
                    return const Center(child: Text('No resources found in Firestore.'));
                  }

                  // Filtering fetched resources by category selected.
                  final filteredResources = allResources
                      .where((r) => r.category.contains(activeTab))
                      .toList();


                  if (filteredResources.isEmpty && activeTab != 'All') {
                    return Center(child: Text('No ${activeTab} resources found.'));
                  }


                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filteredResources.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredResources.length) {
                        final resource = filteredResources[index];

                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    resource.type == "video"
                                        ? Icons.video_camera_back_outlined
                                        : Icons.file_copy_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resource.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        resource.description,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _launchURL(resource.url),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Check the ${resource.type}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {

                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 80, top: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: primaryColor,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Tip of the day",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "\"The best time to plant a tree was 20 years ago.\" The second best time is now. Start small wellness habits today.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

