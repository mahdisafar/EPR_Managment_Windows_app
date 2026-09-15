enum TransactionType {
  income,
  expense,
  debit,
  credit,
}

enum ReferenceType {
  general,
  customer,
  shipment,
  inventory,
  customerPayment,
}

enum ShipmentStatus {
  registered,
  readyForShipping,
  departedOrigin,
  inTransit,
  arrivedBorder,
  customs,
  cleared,
  transferToDestination,
  arrivedWarehouse,
}

enum UnitType {
  kg,
  ser,
  carton,
  item,
  ton,
}

enum ExpenseType {
  customsDuty,
  tax,
  clearanceFee,
  documentFee,
  inspectionFee,
  transportFare,
  routeFee,
  loadingFee,
  unloadingFee,
  storageFee,
  borderFee,
  porterFee,
  workerFee,
  other,
}

enum CurrencyType {
  toman,
  usd,
  eur,
  pkr,
  irr,
}

enum AccountType {
  cash,
  bank,
  payableReceivable,
}

enum InvoiceType {
  purchase,
  sale,
}
