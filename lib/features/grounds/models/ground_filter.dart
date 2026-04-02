enum GroundFilter {
  all('All', 'all'),
  mainGround('Main Ground', 'main'),
  minorGround('Minor Ground', 'minor');

  final String label;
  final String value;
  const GroundFilter(this.label, this.value);
}
