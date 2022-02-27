abstract class OrdersState {}

class OrderLoading extends OrdersState {}

class OrderIdle extends OrdersState {}

class OrderCreated extends OrdersState {}

class OrderCreateError extends OrdersState {}
