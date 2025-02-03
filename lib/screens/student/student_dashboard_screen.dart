// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:gtec/models/student_model.dart';
// import 'package:gtec/provider/student_provider.dart';
// import 'package:gtec/screens/student/studentlogin.dart';
// import 'package:gtec/screens/student/widgets/assignmentscreen.dart';
// import 'package:gtec/screens/student/widgets/studentprofile.dart';
// import 'package:gtec/screens/student/widgets/user_quiz.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class StudentLMSHomePage extends StatefulWidget {
//   const StudentLMSHomePage({super.key});

//   @override
//   State<StudentLMSHomePage> createState() => _StudentLMSHomePageState();
// }

// class _StudentLMSHomePageState extends State<StudentLMSHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               height: 35,
//               width: 75,
//               decoration: BoxDecoration(
//                 image: const DecorationImage(
//                   image: AssetImage('assets/golblack.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               height: 35,
//               width: 35,
//               decoration: BoxDecoration(
//                 image: const DecorationImage(
//                   image: AssetImage('assets/gtecwhite.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Consumer<StudentAuthProvider>(
//             builder: (context, studentProvider, child) {
//               final hasNewNotifications =
//                   studentProvider.notification.isNotEmpty;

//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: hasNewNotifications
//                       ? Colors.blue.shade50
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Stack(
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.notifications_outlined,
//                         color: Color(0xFF0098DA),
//                         size: 24,
//                       ),
//                       onPressed: () => _showNotificationPopup(
//                           context, studentProvider.notification),
//                       tooltip: 'Notifications',
//                     ),
//                     if (hasNewNotifications)
//                       Positioned(
//                         right: 8,
//                         top: 8,
//                         child: Container(
//                           width: 10,
//                           height: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.red.withOpacity(0.3),
//                                 blurRadius: 4,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             child: PopupMenuButton<String>(
//               offset: const Offset(0, 45),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade400, Colors.blue.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.person_outline,
//                     color: Colors.white, size: 22),
//               ),
//               color: Colors.white,
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               onSelected: (String value) async {
//                 if (value == 'Profile') {
//                   showDialog(
//                     context: context,
//                     builder: (context) => Dialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: StudentProfileScreen(),
//                     ),
//                   );
//                 } else if (value == 'Logout') {
//                   await Provider.of<StudentAuthProvider>(context, listen: false)
//                       .Studentlogout();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const UserLoginScreen()),
//                   );
//                 }
//               },
//               itemBuilder: (BuildContext context) => [
//                 PopupMenuItem<String>(
//                   value: 'Profile',
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.person,
//                             color: Colors.blue.shade400, size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Profile',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'Logout',
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.logout_rounded,
//                             color: Colors.red.shade400, size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         'Logout',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade50,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: const SplitView(),
//       ),
//     );
//   }

//   void _showNotificationPopup(
//       BuildContext context, List<dynamic> notifications) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.notifications_outlined,
//                         color: Colors.blue.shade600,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       "Notifications",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   constraints: BoxConstraints(
//                     maxHeight: MediaQuery.of(context).size.height * 0.6,
//                   ),
//                   child: notifications.isEmpty
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.notifications_off_outlined,
//                               size: 48,
//                               color: Colors.grey.shade400,
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               "No new notifications",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey.shade600,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         )
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: notifications.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.grey.shade200,
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.shade100,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Icon(
//                                       Icons.circle_notifications,
//                                       color: Colors.blue.shade700,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           notifications[index]['title'] ??
//                                               "No Title",
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           notifications[index]['message'] ??
//                                               "No Message",
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       "Close",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class SplitView extends StatefulWidget {
//   const SplitView({super.key});

//   @override
//   State<SplitView> createState() => _SplitViewState();
// }

// class _SplitViewState extends State<SplitView>
//     with SingleTickerProviderStateMixin {
//   StudentModel? selectedCourse;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 768;

//     Widget buildCoursesList() {
//       return FadeTransition(
//         opacity: _animation,
//         child: SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(-0.2, 0),
//             end: Offset.zero,
//           ).animate(_animation),
//           child: Container(
//             width: 300,
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.shade100.withOpacity(0.5),
//                   blurRadius: 20,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: CoursesList(
//               onCourseSelected: (course) {
//                 setState(() {
//                   selectedCourse = course;
//                 });
//                 if (isMobile) {
//                   Navigator.of(context).pop();
//                 }
//               },
//               selectedCourse: selectedCourse,
//             ),
//           ),
//         ),
//       );
//     }

//     Widget buildMainContent() {
//       return Expanded(
//         child: FadeTransition(
//           opacity: _animation,
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0.2, 0),
//               end: Offset.zero,
//             ).animate(_animation),
//             child: Column(
//               children: [
//                 if (selectedCourse != null)
//                   Container(
//                     margin: const EdgeInsets.fromLTRB(0, 16, 16, 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.shade100.withOpacity(0.5),
//                           blurRadius: 20,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: LiveSessionsList(course: selectedCourse!),
//                   ),
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(0, 8, 16, 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.shade100.withOpacity(0.5),
//                           blurRadius: 20,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: selectedCourse == null
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(20),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue.shade50,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     Icons.school_outlined,
//                                     size: 48,
//                                     color: Colors.blue.shade400,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 Text(
//                                   'Select a course to view modules',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.grey.shade600,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 if (isMobile) ...[
//                                   const SizedBox(height: 16),
//                                   ElevatedButton.icon(
//                                     onPressed: () {
//                                       _scaffoldKey.currentState?.openDrawer();
//                                     },
//                                     icon: const Icon(Icons.menu),
//                                     label: const Text('View Courses'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 24,
//                                         vertical: 12,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           )
//                         : ModulesList(course: selectedCourse!),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     if (isMobile) {
//       return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text(
//             selectedCourse?.courseName ?? 'Select a Course',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black87,
//           actions: [
//             if (selectedCourse != null)
//               IconButton(
//                 icon: const Icon(Icons.refresh),
//                 onPressed: () {
//                   // Refresh functionality
//                 },
//               ),
//           ],
//         ),
//         drawer: Drawer(
//           child: Column(
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.blue.shade100, Colors.blue.shade50],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.school,
//                         size: 48,
//                         color: Colors.blue,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'Your Courses',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: buildCoursesList(),
//               ),
//             ],
//           ),
//         ),
//         body: buildMainContent(),
//       );
//     }

//     return Scaffold(
//       body: Row(
//         children: [
//           buildCoursesList(),
//           buildMainContent(),
//         ],
//       ),
//     );
//   }
// }

// class LiveSessionsList extends StatefulWidget {
//   final StudentModel course;
//   const LiveSessionsList({Key? key, required this.course}) : super(key: key);

//   @override
//   State<LiveSessionsList> createState() => _LiveSessionsListState();
// }

// class _LiveSessionsListState extends State<LiveSessionsList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<StudentAuthProvider>(context, listen: false)
//           .StudentfetchliveForSelectedCourse(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Consumer<StudentAuthProvider>(
//           builder: (context, provider, child) {
//             final liveSessions = provider.live;
//             if (liveSessions.isEmpty) {
//               return _noLiveSessionsWidget();
//             }

//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // _headerWidget(context),
//                   // const SizedBox(height: 16),
//                   _liveSessionsList(context, liveSessions),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _noLiveSessionsWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.event_busy, 
//             size: 50, 
//             color: Colors.orange.shade400
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'No live sessions scheduled',
//             style: TextStyle(
//               fontSize: 16, 
//               color: Colors.grey.shade600
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _headerWidget(BuildContext context) {
//   Widget _liveSessionsList(BuildContext context, List liveSessions) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SizedBox(
//       height: 120, // Fixed height for the list container
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: liveSessions.length,
//         itemBuilder: (context, index) {
//           final live = liveSessions[index];
//           return _liveSessionCard(context, live);
//         },
//       ),
//     );
//   }

//   Widget _liveSessionCard(BuildContext context, dynamic live) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       width: min(screenWidth * 0.8, 400), // Responsive width with maximum limit
//       margin: const EdgeInsets.only(right: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade50, Colors.white],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.blue.shade100, width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade100.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           _liveIndicator(),
//           Expanded(child: _sessionDetails(context, live)),
//           _joinButton(context, live),
//         ],
//       ),
//     );
//   }

//   Widget _liveIndicator() {
//     return Container(
//       width: 12,
//       height: 12,
//       margin: const EdgeInsets.only(right: 12),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.red.withOpacity(0.3),
//             blurRadius: 4,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sessionDetails(BuildContext context, dynamic live) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           live.message,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: min(screenWidth * 0.04, 16),
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             Icon(
//               Icons.access_time,
//               size: min(screenWidth * 0.045, 18),
//               color: Colors.blue.shade600,
//             ),
//             const SizedBox(width: 6),
//             Text(
//               live.liveStartTime.toString(),
//               style: TextStyle(
//                 color: Colors.blue.shade600,
//                 fontSize: min(screenWidth * 0.035, 14),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _joinButton(BuildContext context, dynamic live) {
//     return SizedBox(
//       width: 80,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           if (live.liveLink.isNotEmpty) {
//             launchUrl(Uri.parse(live.liveLink));
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('No live link available'),
//                 backgroundColor: Colors.blue.shade600,
//               ),
//             );
//           }
//         },
//         icon: const Icon(Icons.play_circle_outline, size: 18),
//         label: const Text(
//           'Join',
//           style: TextStyle(fontSize: 14),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue.shade600,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(
//             vertical: 8,
//             horizontal: 12,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CoursesList extends StatefulWidget {
//   final Function(StudentModel) onCourseSelected;
//   final StudentModel? selectedCourse;

//   const CoursesList({
//     super.key,
//     required this.onCourseSelected,
//     required this.selectedCourse,
//   });

//   @override
//   State<CoursesList> createState() => _CoursesListState();
// }

// class _CoursesListState extends State<CoursesList> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<StudentAuthProvider>(context, listen: false)
//           .StudentLoadCourses(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         return Consumer<StudentAuthProvider>(
//           builder: (context, provider, child) {
//             if (provider.studentCourses.isEmpty) {
//               return const Center(child: Text('No courses available.'));
//             }
//             return ListView.builder(
//               itemCount: provider.studentCourses.length,
//               itemBuilder: (context, index) {
//                 final course = provider.studentCourses[index];
//                 final isSelected = widget.selectedCourse?.courseId == course.courseId;

//                 return GestureDetector(
//                   onTap: () async {
//                     try {
//                       // Clear all previous data
//                       provider.clearModuleData();
//                       provider.clearLessonAndAssignmentData();

//                       // Set the new course and batch IDs
//                       provider.setSelectedCourseId(
//                           course.courseId, course.batchId);

//                       // Notify parent about course selection
//                       widget.onCourseSelected(course);

//                       // Pre-fetch modules for the new course
//                       await provider.StudentfetchModulesForSelectedCourse();
//                       await provider.StudentfetchLessonsAndAssignmentsquiz();
//                     } catch (e) {
//                       print('Error switching course: $e');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'Error loading course content. Please try again.'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },
//                   child: Container(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.blue.shade50 : Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: isSelected ? Colors.blue : Colors.grey.shade300,
//                         width: isSelected ? 2 : 1,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           course.courseName,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: isSelected ? Colors.blue : Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           course.courseDescription,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ModulesList extends StatefulWidget {
//   final StudentModel course;

//   const ModulesList({super.key, required this.course});

//   @override
//   State<ModulesList> createState() => _ModulesListState();
// }

// class _ModulesListState extends State<ModulesList> {
//   @override
//   void initState() {
//     super.initState();
//     // Clear previous module data when a new ModulesList is created
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<StudentAuthProvider>(context, listen: false);
//       provider.clearModuleData();
//       provider.clearLessonAndAssignmentData();
//       provider.setSelectedCourseId(
//           widget.course.courseId, widget.course.batchId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<StudentAuthProvider>(context, listen: false)
//           .StudentfetchModulesForSelectedCourse(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         return Consumer<StudentAuthProvider>(
//           builder: (context, provider, child) {
//             if (provider.modules.isEmpty) {
//               return const Center(child: Text('No modules available'));
//             }
//             return ListView.builder(
//               itemCount: provider.modules.length,
//               itemBuilder: (context, index) {
//                 final module = provider.modules[index];
//                 return ModuleExpansionTile(
//                   key: ValueKey('${widget.course.courseId}-${module.moduleId}'),
//                   module: module,
//                   courseId: widget.course.courseId,
//                   batchId: widget.course.batchId,
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ModuleExpansionTile extends StatefulWidget {
//   final StudentModuleModel module;
//   final int courseId;
//   final int batchId;

//   const ModuleExpansionTile({
//     super.key,
//     required this.module,
//     required this.courseId,
//     required this.batchId,
//   });

//   @override
//   State<ModuleExpansionTile> createState() => _ModuleExpansionTileState();
// }

// class _ModuleExpansionTileState extends State<ModuleExpansionTile> {
//   bool isExpanded = false;
//   bool isLoading = false;
//   List<StudentLessonModel> lessons = [];
//   List<StudentAssignmentModel> assignments = [];
//   List<StudentQuizmodel> quizzes = [];
//   String? errorMessage;

//   Future<void> loadModuleContent() async {
//     if (isLoading) return;

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final provider = Provider.of<StudentAuthProvider>(context, listen: false);

//       // Set the module ID
//       provider.setSelectedModuleId(widget.module.moduleId);

//       // Show loading state immediately
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       // Fetch content in parallel
//       await Future.wait([
//         _fetchLessonsAndAssignments(provider),
//         _fetchQuizzes(provider),
//       ]);

//       if (mounted) {
//         setState(() {
//           lessons = provider.lessons;
//           assignments = provider.assignments;
//           quizzes = provider.quiz;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error in loadModuleContent: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Failed to load content. Please check your connection and try again.';
//         });
//       }
//     }
//   }

//   Future<void> _fetchLessonsAndAssignments(StudentAuthProvider provider) async {
//     try {
//       await provider.StudentfetchLessonsAndAssignmentsquiz();
//     } catch (e) {
//       print('Error fetching lessons and assignments: $e');
//       // We'll handle the error in the parent method
//       rethrow;
//     }
//   }

//   Future<void> _fetchQuizzes(StudentAuthProvider provider) async {
//     try {
//       await provider.StudentfetchliveForSelectedCourse();
//     } catch (e) {
//       print('Error fetching quizzes: $e');
//       // We'll handle the error in the parent method
//       rethrow;
//     }
//   }
//   Widget _buildSectionHeader(String title, int count, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.blue.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blue[700], size: 24),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.blue[900],
//             ),
//           ),
//           const Spacer(),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.blue.withOpacity(0.3)),
//             ),
//             child: Text(
//               count.toString(),
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue[700],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContentItem({
//     required String title,
//     required String content,
//     required IconData icon,
//     required String buttonText,
//     required VoidCallback onPressed,
//     required Color accentColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE0E0E0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: accentColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: accentColor, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: onPressed,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: accentColor,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   buttonText,
//                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//           if (content.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Text(
//               content,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//                 height: 1.5,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFEEEEEE)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Module Header
//           InkWell(
//             onTap: () {
//               setState(() {
//                 isExpanded = !isExpanded;
//                 if (isExpanded &&
//                     lessons.isEmpty &&
//                     assignments.isEmpty &&
//                     quizzes.isEmpty) {
//                   loadModuleContent();
//                 }
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [Colors.blue[700]!, Colors.blue[500]!],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         (lessons.length + assignments.length + quizzes.length)
//                             .toString(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.module.title ?? 'No title available',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${lessons.length} Lessons • ${assignments.length} Assignments • ${quizzes.length} Quizzes',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     isExpanded
//                         ? Icons.keyboard_arrow_up
//                         : Icons.keyboard_arrow_down,
//                     color: Colors.grey[600],
//                     size: 28,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (isExpanded) ...[
//             const Divider(height: 1),
//             if (isLoading)
//               const Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Center(child: CircularProgressIndicator()),
//               )
//             else if (errorMessage != null)
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       Text(
//                         errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                       const SizedBox(height: 12),
//                       ElevatedButton(
//                         onPressed: loadModuleContent,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             else if (lessons.isEmpty && assignments.isEmpty && quizzes.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.inbox_outlined,
//                       size: 48,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'No content available for this module yet',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     if (lessons.isNotEmpty) ...[
//                       _buildSectionHeader(
//                         'Lessons',
//                         lessons.length,
//                         Icons.book_outlined,
//                       ),
//                       const SizedBox(height: 12),
//                       ...lessons.map((lesson) => _buildContentItem(
//                             title: lesson.title,
//                             content: lesson.content,
//                             icon: Icons.play_circle_outline,
//                             buttonText: "Watch Lesson",
//                             accentColor: Colors.blue,
//                             onPressed: () async {
//                               final Uri url = Uri.parse(lesson.videoLink);
//                               if (await canLaunchUrl(url)) {
//                                 await launchUrl(url,
//                                     mode: LaunchMode.externalApplication);
//                               }
//                             },
//                           )),
//                       const SizedBox(height: 24),
//                     ],
//                     if (assignments.isNotEmpty) ...[
//                       _buildSectionHeader(
//                         'Assignments',
//                         assignments.length,
//                         Icons.assignment_outlined,
//                       ),
//                       const SizedBox(height: 12),
//                       ...assignments.map((assignment) => _buildContentItem(
//                             title: assignment.title,
//                             content: assignment.description,
//                             icon: Icons.edit_note,
//                             buttonText: "View Assignment",
//                             accentColor: Colors.orange,
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AssignmentSubmissionPage(
//                                       assignment: assignment),
//                                 ),
//                               );
//                             },
//                           )),
//                       const SizedBox(height: 24),
//                     ],
//                     if (quizzes.isNotEmpty) ...[
//                       _buildSectionHeader(
//                         'Quizzes',
//                         quizzes.length,
//                         Icons.quiz_outlined,
//                       ),
//                       const SizedBox(height: 12),
//                       ...quizzes.map((quiz) => _buildContentItem(
//                             title: quiz.name,
//                             content: quiz.description,
//                             icon: Icons.check_circle_outline,
//                             buttonText: "Start Quiz",
//                             accentColor: Colors.green,
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       QuizDetailScreen(quiz: quiz),
//                                 ),
//                               );
//                             },
//                           )),
//                     ],
//                   ],
//                 ),
//               ),
//           ],
//         ],
//       ),
//     );
//   }
// }