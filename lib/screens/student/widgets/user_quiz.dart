import 'package:flutter/material.dart';
import 'package:lmsgit/models/student_model.dart';
import 'package:lmsgit/provider/student_provider.dart';
import 'package:provider/provider.dart';

class QuizDetailScreen extends StatefulWidget {
  final StudentQuizmodel quiz;

  const QuizDetailScreen({super.key, required this.quiz});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final Map<int, int> selectedAnswers = {};
  final Map<int, bool> submittingQuestions = {};
  final Map<int, bool> answeredQuestions = {};

  Future<void> submitSingleAnswer(
    BuildContext context,
    int questionId,
    int answerId,
  ) async {
    setState(() {
      submittingQuestions[questionId] = true;
    });

    try {
      final quizProvider = Provider.of<StudentAuthProvider>(context, listen: false);
      await quizProvider.StudentsubmitQuizProvider(
        answerId,
        widget.quiz.quizId,
        questionId,
      );

      if (mounted) {
        setState(() {
          answeredQuestions[questionId] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Answer submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          selectedAnswers.remove(questionId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit answer: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          submittingQuestions[questionId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.quiz.name,
          style: const TextStyle(
            color: Color(0xFF464F60),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF464F60)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Quiz Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz Details',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF464F60),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.quiz,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.quiz.questions.length} Questions',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: widget.quiz.questions.map((question) {
                bool isSubmitting = submittingQuestions[question.questionId] == true;
                bool isAnswered = answeredQuestions[question.questionId] == true;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${question.questionId}. ${question.text}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF464F60),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ...question.answers.asMap().entries.map((entry) {
                        int index = entry.key;
                        var answer = entry.value;
                        bool isSelected = selectedAnswers[question.questionId] == answer.answerId;
                        String optionLetter = String.fromCharCode(65 + index);

                        return InkWell(
                          onTap: isSubmitting || isAnswered
                              ? null
                              : () {
                                  setState(() {
                                    selectedAnswers[question.questionId] = answer.answerId;
                                  });
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.shade50 : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    optionLetter,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    answer.text,
                                    style: TextStyle(
                                      color: isSelected ? Colors.blue[700] : Colors.grey[700],
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[600],
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                      if (!isAnswered)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: selectedAnswers[question.questionId] == null || isSubmitting
                                  ? null
                                  : () => submitSingleAnswer(
                                        context,
                                        question.questionId,
                                        selectedAnswers[question.questionId]!,
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Submit Answer',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}