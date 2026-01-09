// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationItemAdapter extends TypeAdapter<NotificationItem> {
  @override
  final int typeId = 3;

  @override
  NotificationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationItem(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      receivedAt: fields[3] as DateTime,
      taskId: fields[4] as String,
      isRead: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.receivedAt)
      ..writeByte(4)
      ..write(obj.taskId)
      ..writeByte(5)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
