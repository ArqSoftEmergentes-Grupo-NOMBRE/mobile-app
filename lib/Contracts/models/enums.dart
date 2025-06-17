enum ContractStatus { pending, active, completed, cancelled }

extension ContractStatusX on ContractStatus {
  /// Nombre legible en UI
  String get displayName {
    switch (this) {
      case ContractStatus.pending:
        return 'Pendiente';
      case ContractStatus.active:
        return 'Activo';
      case ContractStatus.completed:
        return 'Completado';
      case ContractStatus.cancelled:
        return 'Cancelado';
    }
  }

  /// Valor que envía el backend
  String get backendValue => name.toLowerCase();

  /// Parsea del backend a enum
  static ContractStatus fromString(String v) {
    switch (v.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return ContractStatus.pending;
      case 'active':
      case 'activo':
        return ContractStatus.active;
      case 'completed':
      case 'completado':
        return ContractStatus.completed;
      case 'cancelled':
      case 'cancelado':
        return ContractStatus.cancelled;
      default:
        return ContractStatus.pending;
    }
  }
}
