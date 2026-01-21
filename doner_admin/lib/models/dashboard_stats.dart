class DashboardStats {
  final int ordersToday;
  final int ordersTotal;
  final double revenueToday;
  final double revenueTotal;
  final int activeUsers;

  DashboardStats({
    required this.ordersToday,
    required this.ordersTotal,
    required this.revenueToday,
    required this.revenueTotal,
    required this.activeUsers,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      ordersToday: json['orders_today'] as int,
      ordersTotal: json['orders_total'] as int,
      revenueToday: (json['revenue_today'] as num).toDouble(),
      revenueTotal: (json['revenue_total'] as num).toDouble(),
      activeUsers: json['active_users'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders_today': ordersToday,
      'orders_total': ordersTotal,
      'revenue_today': revenueToday,
      'revenue_total': revenueTotal,
      'active_users': activeUsers,
    };
  }
}
