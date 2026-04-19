import 'package:transactions/data/repositories/analysis/analysis_repository.dart';
import 'package:transactions/data/services/api/api_service.dart';
import 'package:transactions/utils/result.dart';

class AnalysisRepositoryRemote implements AnalysisRepository {
  AnalysisRepositoryRemote({required this.apiService});

  final ApiService apiService;

  Future<Result<double>> getSum(DateTime? dateFrom, DateTime? dateTo){
    apiService.get(endpoint)
  }
  
}
