class ListingInput {
  final String? vin;
  final Uri? listingUrl;
  final int year;
  final String make;
  final String model;
  final String? trim;
  final int odometerKm;
  final int askingPriceCad;

  const ListingInput({
    this.vin,
    this.listingUrl,
    required this.year,
    required this.make,
    required this.model,
    this.trim,
    required this.odometerKm,
    required this.askingPriceCad,
  });
}
