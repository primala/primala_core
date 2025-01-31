mixin OpacityUtils {
  double interpolate({
    required double currentValue,
    required double targetValue,
    required double maxOutput,
    required double minOutput,
  }) {
    double distance = (currentValue - targetValue).abs();
    if (distance >= 1.0) {
      return minOutput;
    }
    double lerpValue = 1 - distance;
    return minOutput + (maxOutput - minOutput) * lerpValue;
  }

  double contentLerp(double input) {
    double normalizedInput = input % 1.0;

    if (normalizedInput <= 0.5) {
      return 1.0 - (normalizedInput * 2);
    } else {
      return (normalizedInput - 0.5) * 2;
    }
  }
}
