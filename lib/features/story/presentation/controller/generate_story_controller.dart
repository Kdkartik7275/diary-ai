import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/diary/domain/usecases/get_diaries_by_range.dart';
import 'package:lifeline/features/story/domain/usecases/generate_story_from_diaries.dart';

class GenerateStoryController extends GetxController {
  final GenerateStoryFromDiaries generateStoryFromDiariesUseCase;
  final GetDiariesByRange getDiariesByRangeUseCase;

  GenerateStoryController({
    required this.generateStoryFromDiariesUseCase,
    required this.getDiariesByRangeUseCase,
  });

  final mainCharacter = ''.obs;
  final selectedTone = ''.obs;
  final selectedGenre = ''.obs;

  void setCharacter(String value) {
    mainCharacter.value = value;
  }

  void setTone(String tone) {
    selectedTone.value = tone;
  }

  void setGenre(String genre) {
    selectedGenre.value = genre;
  }

  Future<void> generateStory(DateTime startDate, DateTime endDate) async {
    final diariesResult = await getDiariesByRangeUseCase.call(
      GetDiariesByRangeParams(
        userId: sl<FirebaseAuth>().currentUser!.uid,
        startDate: startDate,
        endDate: endDate,
      ),
    );

    debugPrint(
      'Diaries fetched: ${diariesResult.fold((l) => 'Error: $l', (r) => r.length)}',
    );
    // final result = await generateStoryFromDiariesUseCase.call({
    //   'diaries': [],
    //   'genre': selectedGenre.value,
    //   'tone': selectedTone.value,
    //   'characterName': mainCharacter.value,
    // });
  }
}
