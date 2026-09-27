cat > /tmp/test.dart << 'EOF'
/// A widget that displays a plate number.
///
/// This is a very long explanatory comment that describes in great
/// detail exactly what this class does, which is honestly pretty
/// obvious just from reading the class name and the constructor below.
class PlateWidget {
  // The width of the plate in pixels
  final double width;

  final double height;

  // Constructor
  PlateWidget(this.width, this.height);

  /// Returns true if the plate is valid.
  /// Checks width and height are both positive.
  bool isValid() {
    return width > 0 && height > 0;
  }
}
EOF

python3 extract_comments.py /tmp/test.dart

