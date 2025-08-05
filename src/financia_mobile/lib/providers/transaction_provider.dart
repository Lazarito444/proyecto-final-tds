import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:financia_mobile/models/transaction_model.dart';
import 'package:financia_mobile/services/dashboard_service.dart';
import 'package:financia_mobile/services/transaction_service.dart';
import 'package:dio/dio.dart';


enum TransactionStatus { idle, loading, success, error }

class TransactionState {
  final TransactionStatus status;
  final String? errorMessage;

  TransactionState({required this.status, this.errorMessage});

  TransactionState copyWith({
    TransactionStatus? status,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class TransactionNotifier extends Notifier<TransactionState> {
  late final TransactionService _transactionService;

  @override
  TransactionState build() {
    _transactionService = ref.read(transactionServiceProvider);
    return TransactionState(status: TransactionStatus.idle);
  }
  
  Future<void> createTransaction(TransactionModel transaction) async {
    state = state.copyWith(status: TransactionStatus.loading);
    try {
      await _transactionService.createTransaction(transaction);      
      
      ref.invalidate(dashboardDataProvider);

      state = state.copyWith(status: TransactionStatus.success);

    } on DioException catch (e) {
      state = state.copyWith(
        status: TransactionStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: TransactionStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService();
});

final transactionProvider = NotifierProvider<TransactionNotifier, TransactionState>(() {
  return TransactionNotifier();
});