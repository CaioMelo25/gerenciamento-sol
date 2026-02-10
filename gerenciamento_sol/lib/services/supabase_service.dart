import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/opportunity_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<OpportunityModel>> fetchOpportunities() async {
    try {
      final response = await supabase
          .from('view_matriz_oportunidade')
          .select();

      final List data = response as List;
      return data.map((json) => OpportunityModel.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar oportunidades: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchCategoryTrends(int year, [int? month]) async {
    try {
      var query = supabase.from('view_tendencia_categorias').select();

      if (month != null) {
        final monthStr = month.toString().padLeft(2, '0');
        query = query.eq('mes', '$year-$monthStr');
      } else {
        query = query.like('mes', '$year-%');
      }

      final response = await query.order('mes', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar tendências por categoria: $e');
      return [];
    }
  }
}