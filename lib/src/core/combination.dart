class Combination<T> {
  final T left;
  final T right;

  Combination(this.left, this.right);
  @override
  bool operator ==(Object? other) {
    if (other is! Combination) return false;
    if (left == other.left) return right == other.right;
    if (left == other.right) return right == other.left;
    return false;
  }

  bool contains(T other) {
    return left == other || right == other;
  }

  @override
  int get hashCode => (left.hashCode + right.hashCode).hashCode;
}
