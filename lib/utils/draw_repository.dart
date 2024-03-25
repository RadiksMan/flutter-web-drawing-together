import 'package:drawing_together/providers/auth_provider.dart';
import 'package:drawing_together/providers/database_provider.dart';

class DrawRepository {
  const DrawRepository({
    required DatabaseProvider dbProvider,
    required AuthProvider authProvider,
  })  : _dbProvider = dbProvider,
        _authProvider = authProvider;

  final DatabaseProvider _dbProvider;
  final AuthProvider _authProvider;

  Future<void> saveDrawing(Map<String, dynamic> figure) async {
    final newContentRef = _dbProvider.currentUserContent.push();
    return newContentRef.set(figure);
  }

  Future<void> clealAllContent() {
    return _dbProvider.currentUserContent.remove();
  }
}
