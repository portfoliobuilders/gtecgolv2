import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lmsgit/models/student_model.dart';
import 'package:lmsgit/provider/student_provider.dart';
import 'package:lmsgit/screens/student/studentlogin.dart';
import 'package:lmsgit/screens/student/widgets/assignmentscreen.dart';
import 'package:lmsgit/screens/student/widgets/user_quiz.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final provider = Provider.of<StudentAuthProvider>(context, listen: false);
    try {
      await provider.StudentLoadCourses();
      await provider.fetchUserProfileProvider(provider.userId ?? 0);
      // Auto-select the first course
      if (provider.studentCourses.isNotEmpty) {
        final firstCourse = provider.studentCourses.first;
        provider.setSelectedCourseId(firstCourse.courseId, firstCourse.batchId);
        await provider.StudentfetchModulesForSelectedCourse();
        await provider.StudentfetchliveForSelectedCourse();
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      drawer: isMobile ? const Sidebar() : null,
      appBar: const StudentDashboardAppBar(),
      body: Row(
        children: [
          if (!isMobile) const Sidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }
}

  Widget _buildMainContent() {
    return Consumer<StudentAuthProvider>(
      builder: (context, provider, _) {
        if (provider.studentCourses.isEmpty) {
          return Container(
            color: Colors.grey.shade50,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(32),
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: Colors.blue.shade200,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'No Courses Available',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You currently don\'t have any courses assigned. Please contact your administrator for more information.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container(
          color: Colors.grey.shade50,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const LiveSessionCard(),
                    SizedBox(height: 24),
                    _buildModulesSection(),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModulesSection() {
    return Consumer<StudentAuthProvider>(
      builder: (context, provider, _) {
        if (provider.modules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  'No modules available yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Modules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...provider.modules.map((module) => ModuleExpansionTile(
                  module: module,
                  courseId: provider.courseId!,
                  batchId: provider.batchId!,
                )),
          ],
        );
      },
    );
  }


class ModuleExpansionTile extends StatefulWidget {
  final StudentModuleModel module;
  final int courseId;
  final int batchId;

  const ModuleExpansionTile({
    super.key,
    required this.module,
    required this.courseId,
    required this.batchId,
  });

  @override
  State<ModuleExpansionTile> createState() => _ModuleExpansionTileState();
}

class _ModuleExpansionTileState extends State<ModuleExpansionTile> {
  bool isExpanded = false;
  bool isLoading = false;
  List<StudentLessonModel> lessons = [];
  List<StudentAssignmentModel> assignments = [];
  List<StudentQuizmodel> quizzes = [];
  String? errorMessage;

  Future<void> loadModuleContent() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final provider = Provider.of<StudentAuthProvider>(context, listen: false);
      provider.setSelectedModuleId(widget.module.moduleId);

      await Future.wait([
        _fetchLessonsAndAssignments(provider),
        // _fetchQuizzes(provider),
      ]);

      if (mounted) {
        setState(() {
          lessons = provider.lessons;
          assignments = provider.assignments;
          quizzes = provider.quiz;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in loadModuleContent: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load content. Please check your connection and try again.';
        });
      }
    }
  }

  Future<void> _fetchLessonsAndAssignments(StudentAuthProvider provider) async {
    try {
      await provider.StudentfetchLessonsAndAssignmentsquiz();
    } catch (e) {
      print('Error fetching lessons and assignments: $e');
      rethrow;
    }
  }

  // Future<void> _fetchQuizzes(StudentAuthProvider provider) async {
  //   try {
  //     await provider.StudentfetchliveForSelectedCourse();
  //   } catch (e) {
  //     print('Error fetching quizzes: $e');
  //     rethrow;
  //   }
  // }

  Widget _buildSectionHeader(String title, int count, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade800, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem({
    required String title,
    required String content,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: accentColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          if (content.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              content,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: accentColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                  if (isExpanded &&
                      lessons.isEmpty &&
                      assignments.isEmpty &&
                      quizzes.isEmpty) {
                    loadModuleContent();
                  }
                });
              },
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          (lessons.length + assignments.length + quizzes.length)
                              .toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.module.title ?? 'No title available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${lessons.length} Lessons • ${assignments.length} Assignments • ${quizzes.length} Quizzes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? Colors.blue.shade50
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: isExpanded
                            ? Colors.blue.shade700
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: loadModuleContent,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              )
            else if (lessons.isEmpty && assignments.isEmpty && quizzes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No content available for this module yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (lessons.isNotEmpty) ...[
                      _buildSectionHeader(
                          'Lessons', lessons.length, Icons.play_circle_outline),
                      const SizedBox(height: 16),
                      ...lessons.map((lesson) => _buildContentItem(
                            title: lesson.title,
                            content: lesson.content,
                            icon: Icons.play_circle_outline,
                            buttonText: "Watch Lesson",
                            accentColor: Colors.blue.shade700,
                            onPressed: () async {
                              final Uri url = Uri.parse(lesson.videoLink);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                          )),
                      const SizedBox(height: 24),
                    ],
                    if (assignments.isNotEmpty) ...[
                      _buildSectionHeader('Assignments', assignments.length,
                          Icons.assignment_outlined),
                      const SizedBox(height: 16),
                      ...assignments.map((assignment) => _buildContentItem(
                            title: assignment.title,
                            content: assignment.description,
                            icon: Icons.edit_note,
                            buttonText: "View Assignment",
                            accentColor: Colors.orange.shade700,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssignmentSubmissionPage(
                                          assignment: assignment),
                                ),
                              );
                            },
                          )),
                      const SizedBox(height: 24),
                    ],
                    if (quizzes.isNotEmpty) ...[
                      _buildSectionHeader(
                          'Quizzes', quizzes.length, Icons.quiz_outlined),
                      const SizedBox(height: 16),
                      ...quizzes.map((quiz) => _buildContentItem(
                            title: quiz.name,
                            content: quiz.description,
                            icon: Icons.check_circle_outline,
                            buttonText: "Start Quiz",
                            accentColor: Colors.green.shade700,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuizDetailScreen(quiz: quiz),
                                ),
                              );
                            },
                          )),
                    ],
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class StudentDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StudentDashboardAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showNotificationPopup(
      BuildContext context, List<dynamic> notifications) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.notification_important,
                                color: Colors.blue.shade400,
                              ),
                            ),
                            title: Text(notification.title ?? 'Notification'),
                            subtitle: Text(notification.message ?? ''),
                            trailing: Text(
                              notification.timestamp ?? '',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            height: 35,
            width: 75,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/golblack.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 35,
            width: 35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gtecwhite.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Consumer<StudentAuthProvider>(
          builder: (context, studentProvider, child) {
            final hasNewNotifications = studentProvider.notification.isNotEmpty;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: hasNewNotifications
                    ? Colors.blue.shade50
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF0098DA),
                      size: 24,
                    ),
                    onPressed: () => _showNotificationPopup(
                        context, studentProvider.notification),
                    tooltip: 'Notifications',
                  ),
                  if (hasNewNotifications)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}



class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Define breakpoints
    const mobileBreakpoint = 600;
    const tabletBreakpoint = 1024;
    
    // Calculate sidebar width based on screen size
    double sidebarWidth;
    if (screenWidth < mobileBreakpoint) {
      sidebarWidth = screenWidth * 0.85; // 85% of screen width for mobile
    } else if (screenWidth < tabletBreakpoint) {
      sidebarWidth = 320; // Fixed width for tablet
    } else {
      sidebarWidth = 280; // Original width for desktop
    }

    // For mobile, we'll return a Drawer instead of a Container
    if (screenWidth < mobileBreakpoint) {
      return Drawer(
        child: _buildSidebarContent(context),
      );
    }

    // For tablet and desktop
    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return Column(
      children: [
        _buildProfileSection(context),
        const Divider(height: 1),
        _buildCoursesList(context),
        const Divider(height: 1),
        _buildFooterSection(context),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Consumer<StudentAuthProvider>(
      builder: (context, provider, _) {
        final userProfile = provider.userProfile?.profile;
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        if (userProfile == null) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }

        return InkWell(
          onTap: () => _showProfilePopup(context),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isMobile ? 20 : 24,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    userProfile.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 16 : 18,
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isMobile ? 1 : 2),
                      Text(
                        userProfile.email,
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 13,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: isMobile ? 16 : 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoursesList(BuildContext context) {
    return Expanded(
      child: Consumer<StudentAuthProvider>(
        builder: (context, provider, _) {
          if (provider.studentCourses.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.studentCourses.length,
            itemBuilder: (context, index) {
              final course = provider.studentCourses[index];
              final isSelected = provider.selectedCourseId == course.courseId;

              return _CourseListItem(
                course: course,
                isSelected: isSelected,
                onTap: () {
                  _handleCourseSelection(context, provider, course);
                  // Close drawer if on mobile
                  if (MediaQuery.of(context).size.width < 600) {
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: isMobile ? 36 : 48,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'No courses available',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isMobile ? 13 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            'Your enrolled courses will appear here',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: isMobile ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        children: [
          // _FooterButton(
          //   icon: Icons.headset_mic_outlined,
          //   label: 'Contact Support',
          //   onTap: () {
          //     // Implement support functionality
          //   },
          // ),
          SizedBox(height: isMobile ? 6 : 8),
          _FooterButton(
            icon: Icons.logout_outlined,
            label: 'Logout',
            onTap: () => _handleLogout(context),
            color: Colors.red.shade700,
          ),
        ],
      ),
    );
  }

  void _handleCourseSelection(
    BuildContext context,
    StudentAuthProvider provider,
    StudentModel course,
  ) {
    provider.setSelectedCourseId(course.courseId, course.batchId);
    provider.clearModuleData();
    provider.clearLessonAndAssignmentData();
    provider.StudentfetchModulesForSelectedCourse();
    provider.StudentfetchliveForSelectedCourse();
  }

  void _handleLogout(BuildContext context) {
    Provider.of<StudentAuthProvider>(context, listen: false).Studentlogout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    );
  }

  void _showProfilePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const StudentProfilePopup(),
    );
  }
}
class _CourseListItem extends StatelessWidget {
  final StudentModel course;
  final bool isSelected;
  final VoidCallback onTap;

  const _CourseListItem({
    Key? key,
    required this.course,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book_outlined,
                  size: 20,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                      ),
                    ),
                    if (course.courseDescription != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        course.courseDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _FooterButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color ?? Colors.grey.shade700,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentProfilePopup extends StatelessWidget {
  const StudentProfilePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Consumer<StudentAuthProvider>(
        builder: (context, provider, _) {
          if (provider.userProfile == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final profile = provider.userProfile!.profile;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        profile.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileInfo(
                Icons.email_outlined,
                'Email',
                profile.email,
                context,
              ),
              _buildProfileInfo(
                Icons.phone_outlined,
                'Phone',
                profile.phoneNumber,
                context,
              ),
              _buildProfileInfo(
                Icons.work_outline,
                'Role',
                profile.role,
                context,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveSessionCard extends StatefulWidget {
  const LiveSessionCard({super.key});

  @override
  State<LiveSessionCard> createState() => _LiveSessionCardState();
}

class _LiveSessionCardState extends State<LiveSessionCard> {
  @override
  void initState() {
    super.initState();
    // Fetch live session data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAuthProvider>().StudentfetchliveForSelectedCourse();
    });
  }

  void _joinLiveClass(String liveLink) async {
    if (liveLink.isNotEmpty) {
      final Uri url = Uri.parse(liveLink);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Live Sessions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Consumer<StudentAuthProvider>(
            builder: (context, provider, child) {
              if (provider.live == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (provider.live!.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.live_tv_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Live Sessions Available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for upcoming live sessions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final liveSession = provider.live!.first;
              final formattedTime = DateFormat('MMM d, yyyy - h:mm a')
                  .format(liveSession.liveStartTime);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    liveSession.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'LIVE',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                liveSession.message,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _joinLiveClass(liveSession.liveLink),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Join Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
