import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lmsgit/models/student_model.dart';

class StudentAPI {
  final String baseUrl = 'https://api.portfoliobuilders.in/api';

  Future<http.Response> StudentloginStudent(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> StudentlogoutStudent() async {
    final url = Uri.parse('$baseUrl/logoutUser');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<http.Response> StudentUserRegisterAPI(
    String email,
    String password,
    String name,
    String role,
    String phoneNumber,
  ) async {
    final url = Uri.parse('$baseUrl/registerUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'role': role,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return response; // Return the response object for further handling
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

  Future<List<StudentModel>> StudentfetchCourses(String token) async {
    final url = Uri.parse('$baseUrl/getStudentCourses');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> courses = responseBody['courses'];
      return courses.map((item) => StudentModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch courses: ${response.body}');
    }
  }

  Future<List<StudentModuleModel>> StudentfetchModule(
      String token, int courseId, int batchId) async {
    final url =
        Uri.parse('$baseUrl/student/getModulesByCourse/$courseId/$batchId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['modules'] == null) {
          throw Exception('No modules found.');
        }
        final List<dynamic> modules = responseBody['modules'];
        return modules
            .map((item) => StudentModuleModel.fromJson(item))
            .toList();
      } else if (response.statusCode >= 500) {
        print('Temporary server issue. Please try again later.');
        throw Exception('Server error: ${response.body}');
      } else {
        throw Exception(
            'Failed to fetch modules. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching modules for course $courseId: $e');
      // Optionally, return an empty list or cached data here to handle the error gracefully.
      throw Exception('Failed to fetch modules: $e');
    }
  }

  Future<List<StudentLessonModel>> StudentfetchLesson(
      String token, int courseId, int moduleId, int batchId) async {
    final url = Uri.parse(
        '$baseUrl/student/getLessonsForStudent/$courseId/$moduleId/$batchId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Return empty list for 404 (no content found)
    if (response.statusCode == 404) {
      return [];
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> lessons = responseBody['lessons'];
      return lessons.map((item) => StudentLessonModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch lessons: ${response.body}');
    }
  }

  Future<List<StudentAssignmentModel>> StudentfetchAssignment(
      String token, int courseId, int moduleId) async {
    final url =
        Uri.parse('$baseUrl/student/viewAssignments/$courseId/$moduleId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Return empty list for 404 (no content found)
    if (response.statusCode == 404) {
      return [];
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> assignments = responseBody['assignments'];
      return assignments
          .map((item) => StudentAssignmentModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch assignments: ${response.body}');
    }
  }

  Future<List<StudentQuizmodel>> StudentfetchuserquizAPI(
      String token, int courseId, int moduleId) async {
    final url = Uri.parse('$baseUrl/student/viewQuiz/$courseId/$moduleId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Return empty list for 404 (no content found)
    if (response.statusCode == 404) {
      return [];
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> quiz = responseBody['quizzes'];
      return quiz.map((item) => StudentQuizmodel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch quiz: ${response.body}');
    }
  }

  Future<List<StudentLiveModel>> StudentfetchusersliveAPI(
      String token, int courseId, int batchId) async {
    final url = Uri.parse('$baseUrl/student/getLiveLink/$courseId/$batchId');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Assuming the response directly returns a single live session object
        return [StudentLiveModel.fromJson(responseBody)];
      } else {
        throw Exception('Failed to fetch live session details');
      }
    } catch (e) {
      throw Exception('Error fetching live session: $e');
    }
  }

  Future<String> StudentsubmitquizuserAPI(
      int answerId, String token, int quizId, int questionId) async {
    final url = Uri.parse('$baseUrl/student/submitAnswer/$quizId/$questionId');
    final body = jsonEncode({'selectedAnswerId': answerId});

    print('API Request URL: $url');
    print('API Request Body: $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('API Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to submit quiz: ${response.reasonPhrase}');
    }
  }

  Future<String> StudentsubmitassignmentuserAPI(int assignmentId, String content,
      String submissionLink, String token) async {
    final url = Uri.parse('$baseUrl/student/submitAssignment/$assignmentId');
    final body =
        jsonEncode({'content': content, 'submissionLink': submissionLink});

    print('API Request URL: $url');
    print('API Request Body: $body');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print('API Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to submit quiz: ${response.reasonPhrase}');
    }
  }

  Future<List<notoficationlivemodel>> Studentfetchlivenotofication(
      String token) async {
    final url = Uri.parse('$baseUrl/student/getNotifications');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Assuming the response directly returns a single live session object
        return [notoficationlivemodel.fromJson(responseBody)];
      } else {
        throw Exception('Failed to fetch notification live session details');
      }
    } catch (e) {
      throw Exception('Error fetching notification live session: $e');
    }
  }

  Future<UserProfileResponse> fetchUserProfile(String token, int userId) async {
    final url = Uri.parse('$baseUrl/getProfile/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserProfileResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch user profile: ${response.body}');
      }
    } catch (e) {
      print('Error in API call: $e');
      rethrow;
    }
  }

}
