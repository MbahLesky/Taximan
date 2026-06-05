class DriverDocumentRequirement {
  const DriverDocumentRequirement({required this.type, required this.label});

  final String type;
  final String label;
}

const requiredDriverDocuments = [
  DriverDocumentRequirement(type: 'national_id', label: 'National ID'),
  DriverDocumentRequirement(type: 'driver_license', label: "Driver's License"),
  DriverDocumentRequirement(type: 'insurance', label: 'Vehicle Insurance'),
  DriverDocumentRequirement(
    type: 'vehicle_registration',
    label: 'Vehicle Registration',
  ),
  DriverDocumentRequirement(type: 'road_worthiness', label: 'Road Worthiness'),
];

String driverDocumentLabel(String type) {
  return requiredDriverDocuments
      .firstWhere(
        (document) => document.type == type,
        orElse: () => DriverDocumentRequirement(type: type, label: type),
      )
      .label;
}
