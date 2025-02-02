// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 5;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
      spent: fields[3] as double,
      categoryId: fields[4] as String,
      period: fields[5] as BudgetPeriod,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
      alertEnabled: fields[8] as bool,
      alertPercentage: fields[9] as double,
      createdDate: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.spent)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.period)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.alertEnabled)
      ..writeByte(9)
      ..write(obj.alertPercentage)
      ..writeByte(10)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BudgetPeriodAdapter extends TypeAdapter<BudgetPeriod> {
  @override
  final int typeId = 6;

  @override
  BudgetPeriod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BudgetPeriod.weekly;
      case 1:
        return BudgetPeriod.monthly;
      case 2:
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.weekly;
    }
  }

  @override
  void write(BinaryWriter writer, BudgetPeriod obj) {
    switch (obj) {
      case BudgetPeriod.weekly:
        writer.writeByte(0);
        break;
      case BudgetPeriod.monthly:
        writer.writeByte(1);
        break;
      case BudgetPeriod.yearly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// Commit 10: 2025-02-04T16:34:41
// Commit 165: 2025-03-22T09:18:55
// Commit 183: 2025-03-27T17:25:12
// Commit 68: 2025-02-21T18:22:42
// Commit 171: 2025-03-24T04:22:20
// Commit 1: 2025-02-02T00:41:21
// Commit 3: 2025-02-02T14:22:03
// Commit 7: 2025-02-03T19:12:02
// Commit 36: 2025-02-12T07:50:20
// Commit 51: 2025-02-16T18:28:28
// Commit 55: 2025-02-17T22:32:29
// Commit 76: 2025-02-24T03:06:24
// Commit 82: 2025-02-25T21:44:55
// Commit 95: 2025-03-01T17:34:36
// Commit 109: 2025-03-05T21:21:56
// Commit 114: 2025-03-07T08:55:57
// Commit 125: 2025-03-10T14:45:57
// Commit 160: 2025-03-20T22:10:52
// Commit 200: 2025-04-01T17:02:05
// Commit 14: 2025-02-05T20:23:55
// Commit 29: 2025-02-10T06:45:53
// Commit 46: 2025-02-15T06:42:00
// Commit 74: 2025-02-23T12:57:22
// Commit 84: 2025-02-26T11:50:53
// Commit 106: 2025-03-04T23:28:54
// Commit 120: 2025-03-09T03:13:45
// Commit 129: 2025-03-11T18:39:38
// Commit 131: 2025-03-12T09:00:41
// Commit 137: 2025-03-14T03:15:28
// Commit 145: 2025-03-16T12:29:17
// Commit 148: 2025-03-17T09:04:53
// Commit 153: 2025-03-18T20:27:26
// Commit 187: 2025-03-28T21:47:18
// Commit 198: 2025-04-01T02:57:44
// Commit 2: 2025-02-02T07:39:07
// Commit 8: 2025-02-04T01:43:46
// Commit 55: 2025-02-17T23:11:55
// Commit 56: 2025-02-18T05:51:06
// Commit 89: 2025-02-27T23:38:15
// Commit 126: 2025-03-10T21:48:50
// Commit 127: 2025-03-11T04:27:12
// Commit 157: 2025-03-20T01:04:54
// Commit 167: 2025-03-23T00:03:24
// Commit 19: 2025-02-07T08:03:37
// Commit 20: 2025-02-07T14:49:03
// Commit 28: 2025-02-09T23:52:56
// Commit 42: 2025-02-14T03:13:10
// Commit 51: 2025-02-16T18:14:52
// Commit 55: 2025-02-17T22:21:42
// Commit 56: 2025-02-18T05:56:29
// Commit 66: 2025-02-21T04:24:33
// Commit 71: 2025-02-22T15:56:20
// Commit 74: 2025-02-23T12:54:18
// Commit 104: 2025-03-04T10:06:32
// Commit 121: 2025-03-09T10:15:41
// Commit 124: 2025-03-10T07:12:56
// Commit 130: 2025-03-12T02:00:33
// Commit 151: 2025-03-18T06:26:30
// Commit 166: 2025-03-22T16:24:47
// Commit 172: 2025-03-24T10:41:17
// Commit 186: 2025-03-28T14:40:54
// Commit 189: 2025-03-29T11:03:01
// Commit 200: 2025-04-01T17:06:08
// Commit 4: 2025-02-02T22:09:54
