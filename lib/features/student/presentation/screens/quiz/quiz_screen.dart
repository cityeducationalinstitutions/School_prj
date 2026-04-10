import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:management/features/student/presentation/providers/student_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.watch<StudentProvider>();
    final quiz = studentProvider.activeQuiz;
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);

    if (quiz == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isFinished) {
      return _ResultView(
        score: _score,
        total: quiz.questions.length,
        onClose: () => Navigator.pop(context),
      );
    }

    final question = quiz.questions[_currentIndex];
    final progress = (_currentIndex + 1) / quiz.questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          quiz.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: schoolBlue, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: schoolBlue),
            onPressed: () => _showExitConfirmation(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation(schoolOrange),
            minHeight: 6,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUESTION ${_currentIndex + 1} OF ${quiz.questions.length}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: schoolOrange,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question.text,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: schoolBlue,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = _selectedAnswer == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => setState(() => _selectedAnswer = index),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected ? schoolBlue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? schoolBlue : Colors.grey.shade200,
                              width: 2,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: schoolBlue.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ] : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey.shade50,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white.withOpacity(0.5) : Colors.grey.shade200,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : schoolBlue,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _selectedAnswer == null ? null : _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: schoolOrange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade200,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex == quiz.questions.length - 1 ? 'FINISH QUIZ' : 'NEXT QUESTION',
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    final quiz = context.read<StudentProvider>().activeQuiz!;
    if (_selectedAnswer == quiz.questions[_currentIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentIndex < quiz.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      context.read<StudentProvider>().submitQuiz(_score);
      setState(() => _isFinished = true);
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CONTINUE')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('EXIT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onClose;

  const _ResultView({required this.score, required this.total, required this.onClose});

  @override
  Widget build(BuildContext context) {
    const Color schoolBlue = Color(0xFF131742);
    const Color schoolOrange = Color(0xFFE28743);
    final percentage = (score / total) * 100;

    return Scaffold(
      backgroundColor: schoolBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: schoolOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events_rounded, color: schoolOrange, size: 64),
              ),
              const SizedBox(height: 32),
              Text(
                'Congratulations!',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You completed the quiz with a score of',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                '$score / $total',
                style: GoogleFonts.outfit(
                  color: schoolOrange,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(0)}% Accuracy',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: schoolBlue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('BACK TO DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
