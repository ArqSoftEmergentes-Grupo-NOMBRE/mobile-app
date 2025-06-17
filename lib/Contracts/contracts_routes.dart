import 'package:flutter/material.dart';
import 'models/create_contract_args.dart';
import 'views/contract_list_screen.dart';
import 'views/contract_developer_screen.dart';
import 'views/contract_create_screen.dart';
import 'views/contract_payments_screen.dart';
import 'views/contract_review_screen.dart';
import 'views/contract_success_screen.dart';
import 'views/contract_details_screen.dart';
import 'views/contract_delivery_screen.dart';
import 'views/contract_signature_screen.dart';
import 'views/contract_status_screen.dart';

class ContractsRoutes {
  static const list      = '/contracts';
  static const developer = '/contracts/developer';
  static const create    = '/contracts/create';
  static const payments  = '/contracts/payments';
  static const review    = '/contracts/review';
  static const success   = '/contracts/success';
  static const details   = '/contracts/details';
  static const delivery  = '/contracts/delivery';
  static const signature = '/contracts/signature';
  static const status    = '/contracts/status';

  static Map<String, WidgetBuilder> getRoutes() => {
    /* DASHBOARD */
    list: (_) => const ContractListScreen(),

    /* PASO 1: Seleccionar dev */
    developer: (_) => const ContractDeveloperScreen(),

    /* PASO 2: Crear contrato */
    create: (ctx) {
      final args = ModalRoute.of(ctx)?.settings.arguments;
      if (args is Map<String, dynamic> && args['developerId'] is String) {
        return ContractCreateScreen(
          developerId: args['developerId'] as String,
        );
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },

    /* PASO 3: Definir hitos/pagos */
    payments: (ctx) {
      final args = ModalRoute.of(ctx)?.settings.arguments;
      if (args is CreateContractArgs) {
        return ContractPaymentsScreen(args: args);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },

    /* PASO 4: Revisión y firma */
    review: (ctx) {
      final data = ModalRoute.of(ctx)?.settings.arguments;
      if (data is Map<String, dynamic>) {
        return ContractReviewScreen(contractData: data);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },

    /* ÉXITO */
    success: (_) => const ContractSuccessScreen(),

    /* DETALLE EXISTENTE */
    details: (ctx) {
      final id = ModalRoute.of(ctx)?.settings.arguments;
      if (id is String) {
        return ContractDetailsScreen(contractId: id);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },

    /* PANTALLAS EXTRA */
    delivery:  (ctx) {
      final id = ModalRoute.of(ctx)?.settings.arguments;
      if (id is String) {
        return ContractDeliveryScreen(contractId: id);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },
    signature: (ctx) {
      final id = ModalRoute.of(ctx)?.settings.arguments;
      if (id is String) {
        return ContractSignatureScreen(contractId: id);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },
    status:    (ctx) {
      final id = ModalRoute.of(ctx)?.settings.arguments;
      if (id is String) {
        return ContractStatusScreen(contractId: id);
      }
      return const Scaffold(
        body: Center(child: Text('Argumentos inválidos')),
      );
    },
  };
}
