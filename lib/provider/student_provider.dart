import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lmsgit/contants/gtec_token.dart';
import 'package:lmsgit/models/student_model.dart';
import 'package:lmsgit/screens/student/student_home_screen.dart';
import 'package:lmsgit/screens/student/studentlogin.dart';
import 'package:lmsgit/services/studentwebservice.dart';

import '../screens/student/student_dashboard_screen.dart';

class StudentAuthProvider with ChangeNotifier {
  void setSelectedCourseId(int courseId, int batchId) {
  _courseId = courseId;
  _batchId = batchId;
  
  // Fetch all necessary data
  StudentfetchModulesForSelectedCourse();
  StudentfetchliveForSelectedCourse();
  StudentfetchLessonsAndAssignmentsquiz();
  
  notifyListeners();
}
  void setSelectedModuleId(int moduleId) {
    _moduleId = moduleId;
    notifyListeners();
  }

 void clearModuleData() {
  _modules = [];
  notifyListeners();
}

void clearLessonAndAssignmentData() {
  _lessons = [];
  _assignments = [];
  _quiz = [];
 _live = [];
  notifyListeners();
}


  int? get selectedCourseId => _courseId;

  String? _token;
  int? _moduleId;
  int? _courseId;
  int? _batchId; // New variable to store batchId

  int? _userId;
  UserProfileResponse? _userProfile;

  int? get userId => _userId;
  UserProfileResponse? get userProfile => _userProfile;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  List<StudentModuleModel> _modules = [];
  List<StudentModuleModel> get modules => _modules;
  List<StudentModel> _studentCourses = [];
  List<StudentLessonModel> _lessons = [];
  List<StudentLessonModel> get lessons => _lessons;
  List<StudentAssignmentModel> _assignments = [];
  List<StudentAssignmentModel> get assignments => _assignments;
  List<StudentLiveModel> _live = [];
  List<StudentLiveModel> get live => _live;

  List<StudentQuizmodel> _quiz = [];
  List<StudentQuizmodel> get quiz => _quiz;


  
  List<notoficationlivemodel> _notification = [];
  List<notoficationlivemodel> get notification => _notification;

  String? get token => _token;
  int? get courseId => _courseId;
  List<StudentModel> get studentCourses => _studentCourses;

  int? get batchId => _batchId;

  final StudentAPI _apiService = StudentAPI();

  Future<void> StudentLogin(
      String email, String password, BuildContext context) async {
    try {
      final response = await _apiService.StudentloginStudent(email, password);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];
                  _userId = responseData['userId'];


        // Extract courses and batchId
        if (responseData['courses'] != null &&
            responseData['courses'].isNotEmpty) {
          final firstCourse = responseData['courses'].first;
          _courseId = firstCourse['courseId'];
          _batchId = firstCourse['batchId']; // Store batchId
          print('Selected Course ID: $_courseId');
          print('Selected Batch ID: $_batchId');
          _userId = responseData['userId'];
        }

        // Save the token
        await saveToken(_token!);

        print('Login Successful! Token: $_token');
        print('selected user id: $_userId');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDashboard()),
        );

        notifyListeners();
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Login failed.';
        print('Login failed: $errorMessage');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        throw Exception(errorMessage);
      }
    } catch (error) {
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please check your details.')),
      );
      throw Exception('An error occurred. Please check your details.');
    }
  }

  Future<void> Studentlogout() async {
    try {
      await clearToken();
      _token = null;
      _courseId = null;
      _batchId = null;
      notifyListeners();
      await _apiService.StudentlogoutStudent();
    } catch (error) {
      print('Error during logout: $error');
      rethrow;
    }
  }

  Future<void> Userregisterprovider(String email, String password, String name,
      String role, String phoneNumber) async {
    try {
      await _apiService.StudentUserRegisterAPI(
          email, password, name, role, phoneNumber);
    } catch (e) {
      print('Error creating register: $e');
      throw Exception('Failed to create register');
    }
  }

  Future<void> StudentcheckAuth(BuildContext context) async {
    _token = await getToken();

    // Check if the token exists (indicating the user is logged in)
    if (_token != null) {
      // Navigate to StudentLMSHomePage if the user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentDashboard()),
      );
    } else {
      // Navigate to UserLogin page if the user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserLoginScreen()),
      );
    }
    notifyListeners();
  }

  Future<void> StudentLoadCourses() async {
    if (_token == null) {
      throw Exception('Token is null. Please authenticate first.');
    }

    try {
      _studentCourses = await _apiService.StudentfetchCourses(_token!);

      if (_studentCourses.isNotEmpty) {
        _courseId = _studentCourses.first.courseId;
        print('Selected Course ID: $_courseId');
      } else {
        _courseId = null;
        print('No courses found');
      }

      notifyListeners();
    } catch (error) {
      print('Failed to fetch courses: $error');
      throw Exception('Failed to fetch courses');
    }
  }

  Future<void> StudentfetchModulesForSelectedCourse() async {
    if (_token == null) {
      throw Exception('Token is null. Please authenticate first.');
    }
    if (_courseId == null) {
      throw Exception('Course ID is null. Please select a course first.');
    }
    try {
      _modules = await _apiService.StudentfetchModule(_token!, _courseId!, _batchId!);
      print('Modules for Course ID $_courseId fetched successfully: $_modules');
      notifyListeners();
    } catch (error) {
      print('Failed to fetch modules for course $_courseId: $error');
      throw Exception('Failed to fetch modules');
    }
  }

  Future<void> StudentfetchliveForSelectedCourse() async {
    if (_token == null) {
      throw Exception('Token is null. Please authenticate first.');
    }
    if (_courseId == null || _batchId == null) {
      throw Exception('Course ID is null. Please select a course first.');
    }
    try {
      _live =
          await _apiService.StudentfetchusersliveAPI(_token!, _courseId!, _batchId!);
      print('live for Course ID $_courseId fetched successfully: $_batchId');
      notifyListeners();
    } catch (error) {
      print('Failed to fetch live for course $_courseId: $error');
      throw Exception('Failed to fetch modules');
    }
  }

 Future<void> StudentfetchLessonsAndAssignmentsquiz() async {
  if (_token == null || _courseId == null || _moduleId == null) {
    throw Exception('Token, Course ID, or Module ID is null. Ensure all fields are set.');
  }

  try {
    final lessonsFuture = _apiService.StudentfetchLesson(_token!, _courseId!, _moduleId!, _batchId!);
    final assignmentsFuture = _apiService.StudentfetchAssignment(_token!, _courseId!, _moduleId!);
    final quizFuture = _apiService.StudentfetchuserquizAPI(_token!, _courseId!, _moduleId!);

    // Fetch lessons and assignments independently
    final lessonsResponse = await lessonsFuture.catchError((error) {
      print('Error fetching lessons: $error');
      return <StudentLessonModel>[]; // Return an empty list if lessons fetch fails.
    });

    final assignmentsResponse = await assignmentsFuture.catchError((error) {
      print('Error fetching assignments: $error');
      return <StudentAssignmentModel>[]; // Return an empty list if assignments fetch fails.
    });

    final quizResponse = await quizFuture.catchError((error) {
      print('Error fetching quiz: $error');
      return <StudentQuizmodel>[]; // Return an empty list if quiz fetch fails.
    });

    // Log the responses for debugging
    print('Lessons fetched: $lessonsResponse');
    print('Assignments fetched: $assignmentsResponse');
    print('Quizzes fetched: $quizResponse');

    // Update internal state with fetched data
    _lessons = lessonsResponse;
    _assignments = assignmentsResponse;
    _quiz = quizResponse;

    // Notify listeners to update the UI
    notifyListeners();
  } catch (error) {
    print('Error fetching lessons and assignments: $error');
    throw Exception('Failed to fetch lessons and assignments: $error');
  }
}

  Future<void> StudentsubmitQuizProvider(
      int answerId, int quizId, int questionId) async {
    if (_token == null) throw Exception('Token is missing');
    try {
      await _apiService.StudentsubmitquizuserAPI(
        answerId, // Ensure this is passed correctly
        _token!,
        quizId,
        questionId,
      );
    } catch (e) {
      print('Error submitting quiz: $e');
      throw Exception('Failed to submit quiz');
    }
  }

  Future<void> StudentsubmitAssignmentProvider(
      int assignmentId, String content, String submissionLink) async {
    final token = _token; // Get the token from the provider
    if (token == null) {
      throw Exception('Token is missing');
    }

    try {
      await _apiService.StudentsubmitassignmentuserAPI(
          assignmentId, content, submissionLink, token);
    } catch (e) {
      print('Error submitting assignment: $e');
      throw Exception('Failed to submit assignment');
    }
  }

  Future<void> fetchlive() async{
    if (_token == null) {
      throw Exception('Token is null. Please authenticate first.');
    }
    try {
      _notification = await _apiService.Studentfetchlivenotofication(_token!);
      print('live for Course ID $_courseId fetched successfully: $_live');
      notifyListeners();
    } catch (error) {
      print('Failed to fetch live for course $_courseId: $error');
      throw Exception('Failed to fetch live');
    }
  }

  Future<void> fetchUserProfileProvider(int userId) async {
    if (_token == null) return;
    
    try {
      final response = await _apiService.fetchUserProfile(_token!, userId);
      _userProfile = response;
      notifyListeners();
    } catch (e) {
      print('Error fetching user profile: $e');
      _userProfile = null;
      notifyListeners();
    }
  }
}
