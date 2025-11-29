class CarbonCalculation {
  final String id;
  final DateTime timestamp;
  final double totalFootprint;
  final double transportCO2;
  final double energyCO2;
  final double dietCO2;
  final double travelCO2;
  final Map<String, double> inputs;

  CarbonCalculation({
    required this.id,
    required this.timestamp,
    required this.totalFootprint,
    required this.transportCO2,
    required this.energyCO2,
    required this.dietCO2,
    required this.travelCO2,
    required this.inputs,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'totalFootprint': totalFootprint,
      'transportCO2': transportCO2,
      'energyCO2': energyCO2,
      'dietCO2': dietCO2,
      'travelCO2': travelCO2,
      'inputs': inputs,
    };
  }

  // Create from JSON from Firestore
  factory CarbonCalculation.fromJson(Map<String, dynamic> json) {
    return CarbonCalculation(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalFootprint: (json['totalFootprint'] as num).toDouble(),
      transportCO2: (json['transportCO2'] as num).toDouble(),
      energyCO2: (json['energyCO2'] as num).toDouble(),
      dietCO2: (json['dietCO2'] as num).toDouble(),
      travelCO2: (json['travelCO2'] as num).toDouble(),
      inputs: Map<String, double>.from(
        (json['inputs'] as Map).map(
          (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
        ),
      ),
    );
  }

  // Check if footprint is below average (Kenya average: 12,000 kg/year)
  bool get isBelowAverage => totalFootprint < 12000;

  // Get breakdown percentages
  Map<String, double> get breakdownPercentages {
    if (totalFootprint == 0) {
      return {
        'transport': 0,
        'energy': 0,
        'diet': 0,
        'travel': 0,
      };
    }
    return {
      'transport': (transportCO2 / totalFootprint * 100),
      'energy': (energyCO2 / totalFootprint * 100),
      'diet': (dietCO2 / totalFootprint * 100),
      'travel': (travelCO2 / totalFootprint * 100),
    };
  }

  // Get the largest contributor
  String get largestContributor {
    final breakdown = {
      'Transport': transportCO2,
      'Energy': energyCO2,
      'Diet': dietCO2,
      'Travel': travelCO2,
    };
    
    return breakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
