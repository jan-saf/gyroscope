import 'Vector.dart';

class Operation {
  final Vector vector;
  final Op op;

  Operation(this.vector, this.op);

  Operation.fromJson(Map<String, dynamic> json)
      : vector = Vector.fromJson(json['vector']),
        op = json['operation'];

  Map<String, dynamic> toJson() => {
    'vector': vector.toJson(),
    'operation': op.toString().replaceFirst("Op.", ""),
  };
}

enum Op {
  SORT,
  DECIMATE,
  SHUFFLE,
  RESTORE,
  NONE
}