import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Color backgroundColor = const Color(0xFFFFDBBB);
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

  final List<Map<String, dynamic>> resources = [
    {
      "id": "1",
      "title": "Time-block your deep work",
      "description":
      "Schedule 2-3 hour blocks for focused work when your energy is highest, typically in the morning.",
      "type": "article",
      "category": ["All", "Productivity", "Work Habits", "Energy"],
      "url":
      "https://www.calnewport.com/blog/2013/12/21/deep-habits-the-importance-of-planning-every-minute-of-your-work-day/",
    },
    {
      "id": "2",
      "title": "The Pomodoro Technique Explained",
      "description":
      "Learn how to use 25-minute focused work sessions followed by short breaks to maximize productivity.",
      "type": "video",
      "category": ["All", "Productivity", "Work Habits"],
      "url": "https://www.youtube.com/watch?v=aQ_xKuXo0D0",
    },
    {
      "id": "3",
      "title": "Eat That Frog: Stop Procrastinating",
      "description":
      "Tackle your biggest, most important task first thing in the morning for maximum impact.",
      "type": "article",
      "category": ["All", "Productivity", "Work Habits"],
      "url": "https://todoist.com/productivity-methods/eat-the-frog",
    },
    {
      "id": "4",
      "title": "Setting Boundaries at Work",
      "description":
      "Learn how to establish healthy boundaries between work and personal life for better well-being.",
      "type": "article",
      "category": ["All", "Work/Life Balance"],
      "url": "https://www.mindtools.com/ahlcf5r/setting-boundaries-at-work",
    },
    {
      "id": "5",
      "title": "Desk Stretches Every Hour",
      "description":
      "Simple neck rolls, shoulder shrugs, and wrist stretches can prevent tension and improve circulation.",
      "type": "video",
      "category": ["All", "Work/Life Balance", "Burnout", "Work Habits"],
      "url": "https://www.youtube.com/watch?v=RqcOCBb4arc",
    },

    {
      "id": "6",
      "title": "The 4 A's of Stress Management",
      "description":
      "Learn to **Avoid** unnecessary stress, **Alter** the situation, **Adapt** to the stressor, and **Accept** the things you can't change.",
      "type": "article",
      "category": ["All", "Stress and Anxiety", "Burnout"],
      "url": "https://www.helpguide.org/mental-health/stress/stress-management",
    },
    {
      "id": "7",
      "title": "How to Deal with Burnout: Emotional Exhaustion",
      "description":
      "A video explaining the signs of burnout and strategies to manage this type of emotional exhaustion at work.",
      "type": "video",
      "category": ["All", "Burnout", "Stress and Anxiety"],
      "url": "https://www.youtube.com/watch?v=YyjBKqsJqAo",
    },
    {
      "id": "8",
      "title": "Digital Detox: Setting Digital Boundaries",
      "description":
      "Tips on how to disconnect from work-related apps and emails after hours to protect your personal time and mental health.",
      "type": "article",
      "category": ["All", "Work/Life Balance", "Work Habits"],
      "url":
      "https://www.microsoft.com/en-us/microsoft-365-life-hacks/organization/setting-boundaries-and-work-life-balance",
    },
    {
      "id": "9",
      "title": "Fuel Your Focus: Nutrition for Sustained Energy",
      "description":
      "Discover the best foods, including protein and fiber, and hydration habits to maintain consistent energy and avoid the midday crash.",
      "type": "article",
      "category": ["All", "Energy", "Productivity"],
      "url":
      "https://ipspowerfulpeople.com/effective-approaches-for-maintaining-energy-throughout-the-workday-for-our-professionals/",
    },
    {
      "id": "10",
      "title": "Movement & Light: Simple Energy Boosts",
      "description":
      "Incorporate short exercise breaks, seek natural light, and practice breathing techniques to boost your physical and mental energy.",
      "type": "article",
      "category": ["All", "Energy", "Work Habits"],
      "url": "https://humanic.dk/en/7-tips-for-more-energy-in-the-workday/",
    },
    {
      "id": "11",
      "title": "The Art of Time Management: Prioritize Your Tasks",
      "description":
      "A guide on prioritizing tasks, setting realistic goals, and using time management techniques like time-blocking to boost your output.",
      "type": "article",
      "category": ["All", "Productivity", "Work Habits"],
      "url": "https://www.personatalent.com/productivity/how-to-maximize-energy-at-work/",
    },
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResources = resources
        .where((r) => (r["category"] as List).contains(activeTab))
        .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(

                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),

                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Resources Heading
                      Text(
                        "Resources",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Subtitle
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
                    padding: const EdgeInsets.only(right: 8.0),
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
              child: ListView.builder(
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
                                resource["type"] == "video"
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
                                    resource["title"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    resource["description"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _launchURL(resource["url"]),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Check the ${resource["type"]}",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}