/// Data class used for sending of sensor data
class Vector {
  final double x;
  final double y;
  final double z;

  Vector(this.x, this.y, this.z);

  Vector.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'];

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
      };
}
