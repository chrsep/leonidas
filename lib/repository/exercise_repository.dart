import 'package:leonidas/database/exercise_dao.dart';

class ExerciseRepository {
  ExerciseRepository(this.exerciseDao);

  final ExerciseDao exerciseDao;
}