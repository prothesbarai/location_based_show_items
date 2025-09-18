// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddToCartModelAdapter extends TypeAdapter<AddToCartModel> {
  @override
  final int typeId = 0;

  @override
  AddToCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddToCartModel(
      productId: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AddToCartModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddToCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
