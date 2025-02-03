class StudentModel {
  final int batchId;
  final int courseId;
  String batchName;
  final String courseName;
  final String courseDescription;

  StudentModel(
      {required this.courseDescription,
      required this.courseName,
      required this.batchName,
      required this.courseId,
      required this.batchId});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      courseName: json['courseName'],
      courseDescription: json['courseDescription'],
      courseId: json['courseId'],
      batchId: json['batchId'],
      batchName: json['batchName'],
    );
  }
}

class StudentModuleModel {
  final int moduleId;
  final String title;
  final String content;
  final bool locked;
  final int courseId;

  StudentModuleModel({
    required this.moduleId,
    required this.title,
    required this.content,
    required this.locked,
    required this.courseId,
  });

  factory StudentModuleModel.fromJson(Map<String, dynamic> json) {
    return StudentModuleModel(
      moduleId: json['moduleId'] ?? 0,
      title: json['title'] ?? 'No title',
      content: json['content'] ?? 'No content',
      locked: json['locked'] ?? false,
      courseId: json['courseId'] ?? 0,
    );
  }
}

class StudentLessonModel {
  final int lessonId;
  final int moduleId;
  final int courseId;
  final int batchId;
  final String title;
  final String content;
  final String videoLink;
  final String? pdfPath; // Mark as nullable
  final String status;

  StudentLessonModel({
    required this.lessonId,
    required this.moduleId,
    required this.courseId,
    required this.batchId,
    required this.title,
    required this.content,
    required this.videoLink,
    this.pdfPath, // Nullable
    required this.status,
  });

  factory StudentLessonModel.fromJson(Map<String, dynamic> json) {
    return StudentLessonModel(
      lessonId: json['lessonId'],
      moduleId: json['moduleId'],
      courseId: json['courseId'],
      batchId: json['batchId'],
      title: json['title'],
      content: json['content'],
      videoLink: json['videoLink'],
      pdfPath: json['pdfPath'], // Accept null values
      status: json['status'],
    );
  }
}

class StudentAssignmentModel {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String? submissionLink; // Make it nullable

  StudentAssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.submissionLink, // Nullable field
  });

  factory StudentAssignmentModel.fromJson(Map<String, dynamic> json) {
    return StudentAssignmentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
      submissionLink: json['submissionLink'] ?? "", // Provide default value
    );
  }
}

class StudentQuizmodel {
  final int quizId;
  final String name;
  final String description;
  final int courseId;
  final int moduleId;
  final int batchId;
  final String status;
  final List<Question> questions;

  StudentQuizmodel({
    required this.quizId,
    required this.name,
    required this.description,
    required this.courseId,
    required this.moduleId,
    required this.batchId,
    required this.status,
    required this.questions,
  });
  factory StudentQuizmodel.fromJson(Map<String, dynamic> json) {
    return StudentQuizmodel(
      quizId: json['quizId'] ?? 0, // Default to 0 if quizId is null
      name: json['name'] ?? '', // Default to an empty string if name is null
      description: json['description'] ??
          '', // Default to an empty string if description is null
      courseId: json['courseId'] ?? 0, // Default to 0 if courseId is null
      moduleId: json['moduleId'] ?? 0, // Default to 0 if moduleId is null
      batchId: json['batchId'] ?? 0, // Default to 0 if batchId is null
      status:
          json['status'] ?? '', // Default to an empty string if status is null
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'name': name,
      'description': description,
      'courseId': courseId,
      'moduleId': moduleId,
      'batchId': batchId,
      'status': status,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

class Question {
  final int questionId;
  final String text;
  final List<Answer> answers;

  Question({
    required this.questionId,
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      text: json['text'],
      answers: (json['answers'] as List)
          .map((answer) => Answer.fromJson(answer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'text': text,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class Answer {
  final int answerId;
  final String text;

  Answer({
    required this.answerId,
    required this.text,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerId: json['answerId'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerId': answerId,
      'text': text,
    };
  }
}

class StudentLiveModel {
  final String message;
  final String liveLink;
  final DateTime liveStartTime;

  StudentLiveModel({
    required this.message,
    required this.liveLink,
    required this.liveStartTime,
  });

  // Factory method to create a model from JSON
  factory StudentLiveModel.fromJson(Map<String, dynamic> json) {
    return StudentLiveModel(
      message: json['message'] ?? '', // Handle null or missing values
      liveLink: json['liveLink'] ?? '', // Handle null or missing values
      liveStartTime:
          DateTime.parse(json['liveStartTime']), // Parse String to DateTime
    );
  }
}

class notoficationlivemodel {
  final String message;
  final String nnotifications;
  notoficationlivemodel({
    required this.message,
    required this.nnotifications,
  });
  factory notoficationlivemodel.fromJson(Map<String, dynamic> json) {
    return notoficationlivemodel(
      message: json['message'] ?? '',
      nnotifications: json['nnotifications'] ?? '',
    );
  }
}

class UserProfileResponse {
  final String message;
  final UserProfile profile;

  UserProfileResponse({required this.message, required this.profile});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      message: json['message'],
      profile: UserProfile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'profile': profile.toJson(),
    };
  }
}

class UserProfile {
  final int userId; // Changed from id to userId to match API response
  final String name;
  final String email;
  final String role;
  final String phoneNumber;

  UserProfile({
    required this.userId, // Updated parameter name
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'], // Updated to match API response
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // Updated field name
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }
}