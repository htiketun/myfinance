// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 3;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: fields[2] as int,
      iconCodePoint: fields[3] as int,
      type: fields[5] as CategoryTransactionType,
      isDefault: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.iconCodePoint)
      ..writeByte(4)
      ..write(obj.isDefault)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryTransactionTypeAdapter
    extends TypeAdapter<CategoryTransactionType> {
  @override
  final int typeId = 4;

  @override
  CategoryTransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CategoryTransactionType.income;
      case 1:
        return CategoryTransactionType.expense;
      case 2:
        return CategoryTransactionType.both;
      default:
        return CategoryTransactionType.income;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryTransactionType obj) {
    switch (obj) {
      case CategoryTransactionType.income:
        writer.writeByte(0);
        break;
      case CategoryTransactionType.expense:
        writer.writeByte(1);
        break;
      case CategoryTransactionType.both:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// Commit 64: 2025-02-20T14:21:28
// Commit 65: 2025-02-20T22:01:11
// Commit 101: 2025-03-03T12:21:59
// Commit 106: 2025-03-04T23:53:02
// Commit 181: 2025-03-27T03:14:04
// Commit 47: 2025-02-15T14:21:45
// Commit 133: 2025-03-12T23:15:54
// Commit 19: 2025-02-07T07:33:36
// Commit 20: 2025-02-07T14:53:19
// Commit 24: 2025-02-08T19:50:15
// Commit 25: 2025-02-09T02:03:35
// Commit 40: 2025-02-13T12:54:02
// Commit 75: 2025-02-23T20:00:54
// Commit 136: 2025-03-13T20:06:16
// Commit 142: 2025-03-15T14:54:45
// Commit 144: 2025-03-16T05:08:24
// Commit 149: 2025-03-17T16:07:15
// Commit 152: 2025-03-18T13:43:43
// Commit 157: 2025-03-20T00:54:47
// Commit 166: 2025-03-22T16:58:56
// Commit 178: 2025-03-26T05:40:56
// Commit 184: 2025-03-28T00:15:52
// Commit 188: 2025-03-29T04:03:36
// Commit 1: 2025-02-02T00:23:35
// Commit 23: 2025-02-08T12:28:02
// Commit 24: 2025-02-08T19:06:21
// Commit 42: 2025-02-14T02:58:25
// Commit 51: 2025-02-16T18:23:39
// Commit 69: 2025-02-22T01:56:49
// Commit 85: 2025-02-26T19:04:09
// Commit 97: 2025-03-02T08:24:32
// Commit 109: 2025-03-05T21:01:00
// Commit 121: 2025-03-09T10:00:41
// Commit 123: 2025-03-10T00:14:50
// Commit 144: 2025-03-16T04:31:40
// Commit 146: 2025-03-16T18:55:12
// Commit 149: 2025-03-17T16:47:48
// Commit 170: 2025-03-23T21:05:30
// Commit 181: 2025-03-27T03:05:21
// Commit 182: 2025-03-27T10:01:12
// Commit 5: 2025-02-03T04:49:55
// Commit 34: 2025-02-11T18:30:04
// Commit 50: 2025-02-16T11:17:59
// Commit 60: 2025-02-19T10:10:42
// Commit 67: 2025-02-21T11:55:23
// Commit 118: 2025-03-08T12:50:50
// Commit 124: 2025-03-10T07:28:58
// Commit 146: 2025-03-16T18:51:00
// Commit 163: 2025-03-21T19:26:13
// Commit 170: 2025-03-23T21:20:38
// Commit 179: 2025-03-26T12:44:22
// Commit 187: 2025-03-28T21:04:57
// Commit 192: 2025-03-30T08:58:50
// Commit 194: 2025-03-30T22:51:25
// Commit 5: 2025-02-03T05:02:15
// Commit 12: 2025-02-05T06:12:37
// Commit 29: 2025-02-10T06:58:15
// Commit 75: 2025-02-23T20:45:05
// Commit 91: 2025-02-28T13:36:44
// Commit 93: 2025-03-01T04:01:46
// Commit 99: 2025-03-02T22:10:18
// Commit 174: 2025-03-25T01:16:57
// Commit 180: 2025-03-26T20:03:31
// Commit 197: 2025-03-31T19:55:11
// Commit 199: 2025-04-01T09:57:49
// Commit 13: 2025-02-05T13:50:13
// Commit 43: 2025-02-14T09:44:28
// Commit 74: 2025-02-23T13:19:14
// Commit 77: 2025-02-24T10:51:41
// Commit 93: 2025-03-01T04:02:03
// Commit 97: 2025-03-02T08:02:36
// Commit 110: 2025-03-06T03:53:47
// Commit 126: 2025-03-10T21:49:04
// Commit 156: 2025-03-19T17:46:17
