abstract interface class LifeCostEstimator {
  Future<({double hours, double days})> estimate(int pesos);
}
