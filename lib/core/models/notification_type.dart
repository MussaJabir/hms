enum NotificationType {
  rentDue('rent_due', 'Rent Due', 'Rent payment reminder'),
  rentOverdue('rent_overdue', 'Rent Overdue', 'Overdue rent alert'),
  meterReading(
    'meter_reading',
    'Meter Reading',
    'Weekly meter reading reminder',
  ),
  electricityHigh(
    'electricity_high',
    'High Consumption',
    'Electricity consumption alert',
  ),
  waterBillDue(
    'water_bill_due',
    'Water Bill Due',
    'Water bill payment reminder',
  ),
  lowStock('low_stock', 'Low Stock', 'Inventory low stock alert'),
  gasRefill('gas_refill', 'Gas Refill', 'Gas cylinder refill reminder'),
  schoolFeeDue(
    'school_fee_due',
    'School Fee Due',
    'School fee payment reminder',
  ),
  budgetWarning('budget_warning', 'Budget Warning', 'Budget limit approaching'),
  budgetExceeded('budget_exceeded', 'Budget Exceeded', 'Budget limit exceeded');

  final String id;
  final String title;
  final String channelDescription;

  const NotificationType(this.id, this.title, this.channelDescription);
}
