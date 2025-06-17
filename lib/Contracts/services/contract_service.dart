import 'dart:convert';
import '../../shared/services/http_client.dart';
import '../models/contract.dart';
import '../models/milestone.dart';

abstract class IContractService {
  Future<List<Contract>> fetchAll();
  Future<Contract> fetchById(String id);
  Future<Contract> create(Contract contract);
  Future<bool> signContract(String id);
}

class ContractService implements IContractService {
  static const _basePath = '/contracts';

  @override
  Future<List<Contract>> fetchAll() async {
    final res = await HttpClient.get(_basePath);
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body)['data'] as List;
      return list
          .map((e) => Contract.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Error fetching contracts: ${res.body}');
  }

  @override
  Future<Contract> fetchById(String id) async {
    final res = await HttpClient.get('$_basePath/$id');
    if (res.statusCode == 200) {
      return Contract.fromJson(
          jsonDecode(res.body)['data'] as Map<String, dynamic>);
    }
    throw Exception('Error fetching contract: ${res.body}');
  }

  @override
  Future<Contract> create(Contract contract) async {
    final res = await HttpClient.post(_basePath, contract.toJson());
    if (res.statusCode == 201) {
      return Contract.fromJson(
          jsonDecode(res.body)['data'] as Map<String, dynamic>);
    }
    throw Exception('Error creating contract: ${res.body}');
  }

  @override
  Future<bool> signContract(String id) async {
    final res = await HttpClient.post('$_basePath/$id/sign', {});
    if (res.statusCode == 200) return true;
    throw Exception('Error signing contract: ${res.body}');
  }

  /// Endpoint para obtener los hitos entregados
  Future<List<Milestone>> fetchDelivery(String id) async {
    final res = await HttpClient.get('/contracts/$id/delivery');
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body)['data'] as List;
      return list.map((e) => Milestone.fromJson(e)).toList();
    }
    throw Exception('Error fetching delivery: ${res.body}');
  }

}
