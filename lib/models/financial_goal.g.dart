// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinancialGoalAdapter extends TypeAdapter<FinancialGoal> {
  @override
  final int typeId = 7;

  @override
  FinancialGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialGoal(
      id: fields[0] as String,
      name: fields[1] as String,
      targetAmount: fields[2] as double,
      currentAmount: fields[3] as double,
      targetDate: fields[4] as DateTime,
      createdDate: fields[5] as DateTime,
      description: fields[6] as String?,
      type: fields[7] as GoalType,
      colorValue: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FinancialGoal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.currentAmount)
      ..writeByte(4)
      ..write(obj.targetDate)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalTypeAdapter extends TypeAdapter<GoalType> {
  @override
  final int typeId = 8;

  @override
  GoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalType.savings;
      case 1:
        return GoalType.investment;
      case 2:
        return GoalType.debtPayoff;
      case 3:
        return GoalType.purchase;
      case 4:
        return GoalType.emergency;
      default:
        return GoalType.savings;
    }
  }

  @override
  void write(BinaryWriter writer, GoalType obj) {
    switch (obj) {
      case GoalType.savings:
        writer.writeByte(0);
        break;
      case GoalType.investment:
        writer.writeByte(1);
        break;
      case GoalType.debtPayoff:
        writer.writeByte(2);
        break;
      case GoalType.purchase:
        writer.writeByte(3);
        break;
      case GoalType.emergency:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// Commit 45: 2025-02-15T00:22:41
// Commit 47: 2025-02-15T14:19:14
// Commit 75: 2025-02-23T20:10:12
// Commit 108: 2025-03-05T13:47:54
// Commit 195: 2025-03-31T06:31:08
// Commit 41: 2025-02-13T19:18:23
// Commit 8: 2025-02-04T02:26:26
// Commit 70: 2025-02-22T09:00:45
// Commit 81: 2025-02-25T14:52:34
// Commit 186: 2025-03-28T14:04:25
// Commit 10: 2025-02-04T15:59:51
// Commit 16: 2025-02-06T11:04:48
// Commit 40: 2025-02-13T12:59:38
// Commit 52: 2025-02-17T01:42:41
// Commit 58: 2025-02-18T20:30:42
// Commit 59: 2025-02-19T03:25:48
// Commit 61: 2025-02-19T17:38:17
// Commit 63: 2025-02-20T07:46:09
// Commit 71: 2025-02-22T15:52:31
// Commit 82: 2025-02-25T22:06:36
// Commit 89: 2025-02-27T23:58:58
// Commit 93: 2025-03-01T03:23:04
// Commit 101: 2025-03-03T12:45:29
// Commit 104: 2025-03-04T09:54:04
// Commit 105: 2025-03-04T17:02:32
// Commit 110: 2025-03-06T04:36:51
// Commit 139: 2025-03-14T17:18:06
// Commit 154: 2025-03-19T04:10:35
// Commit 158: 2025-03-20T08:11:54
// Commit 189: 2025-03-29T11:04:54
// Commit 195: 2025-03-31T05:43:16
// Commit 10: 2025-02-04T15:51:01
// Commit 14: 2025-02-05T20:55:29
// Commit 23: 2025-02-08T11:46:23
// Commit 70: 2025-02-22T09:02:27
// Commit 81: 2025-02-25T15:06:03
// Commit 99: 2025-03-02T22:49:28
// Commit 100: 2025-03-03T05:35:30
// Commit 101: 2025-03-03T12:45:33
// Commit 103: 2025-03-04T02:45:09
// Commit 115: 2025-03-07T15:22:03
// Commit 130: 2025-03-12T01:59:16
// Commit 140: 2025-03-15T00:43:34
// Commit 143: 2025-03-15T22:12:45
// Commit 184: 2025-03-28T00:20:05
// Commit 197: 2025-03-31T19:53:20
// Commit 36: 2025-02-12T08:16:51
// Commit 73: 2025-02-23T06:24:19
// Commit 77: 2025-02-24T11:01:09
// Commit 86: 2025-02-27T02:46:27
// Commit 113: 2025-03-07T01:55:49
// Commit 138: 2025-03-14T10:43:31
// Commit 143: 2025-03-15T21:53:50
// Commit 144: 2025-03-16T05:20:09
// Commit 12: 2025-02-05T06:41:33
// Commit 37: 2025-02-12T15:48:49
// Commit 49: 2025-02-16T04:22:04
// Commit 63: 2025-02-20T07:26:23
// Commit 64: 2025-02-20T14:24:19
// Commit 71: 2025-02-22T16:26:35
// Commit 86: 2025-02-27T02:35:02
// Commit 102: 2025-03-03T20:00:42
// Commit 106: 2025-03-04T23:31:56
