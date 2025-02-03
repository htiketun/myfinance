// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      type: fields[4] as TransactionType,
      date: fields[5] as DateTime,
      description: fields[6] as String?,
      currency: fields[7] as String?,
      isRecurring: fields[8] as bool,
      recurringType: fields[9] as RecurringType?,
      nextRecurringDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.isRecurring)
      ..writeByte(9)
      ..write(obj.recurringType)
      ..writeByte(10)
      ..write(obj.nextRecurringDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurringTypeAdapter extends TypeAdapter<RecurringType> {
  @override
  final int typeId = 2;

  @override
  RecurringType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurringType.daily;
      case 1:
        return RecurringType.weekly;
      case 2:
        return RecurringType.monthly;
      case 3:
        return RecurringType.yearly;
      default:
        return RecurringType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurringType obj) {
    switch (obj) {
      case RecurringType.daily:
        writer.writeByte(0);
        break;
      case RecurringType.weekly:
        writer.writeByte(1);
        break;
      case RecurringType.monthly:
        writer.writeByte(2);
        break;
      case RecurringType.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
// Commit 55: 2025-02-17T22:23:15
// Commit 73: 2025-02-23T06:22:25
// Commit 120: 2025-03-09T03:17:03
// Commit 131: 2025-03-12T09:08:01
// Commit 142: 2025-03-15T14:50:50
// Commit 172: 2025-03-24T11:40:35
// Commit 5: 2025-02-03T04:37:00
// Commit 140: 2025-03-15T00:59:24
// Commit 21: 2025-02-07T21:43:47
// Commit 26: 2025-02-09T09:00:26
// Commit 38: 2025-02-12T22:24:24
// Commit 50: 2025-02-16T11:00:08
// Commit 57: 2025-02-18T12:46:31
// Commit 110: 2025-03-06T03:58:32
// Commit 121: 2025-03-09T09:56:12
// Commit 123: 2025-03-09T23:54:24
// Commit 124: 2025-03-10T07:42:14
// Commit 155: 2025-03-19T10:24:48
// Commit 12: 2025-02-05T06:36:23
// Commit 26: 2025-02-09T09:46:58
// Commit 36: 2025-02-12T08:01:32
// Commit 54: 2025-02-17T15:23:35
// Commit 79: 2025-02-25T01:08:16
// Commit 150: 2025-03-17T23:45:32
// Commit 25: 2025-02-09T02:11:58
// Commit 41: 2025-02-13T19:46:23
// Commit 72: 2025-02-22T23:28:21
// Commit 175: 2025-03-25T08:53:26
// Commit 180: 2025-03-26T20:03:05
// Commit 196: 2025-03-31T12:56:07
// Commit 4: 2025-02-02T22:02:43
// Commit 44: 2025-02-14T17:14:04
// Commit 54: 2025-02-17T15:58:35
// Commit 85: 2025-02-26T18:56:11
// Commit 101: 2025-03-03T12:32:27
// Commit 102: 2025-03-03T19:57:12
// Commit 128: 2025-03-11T11:30:28
// Commit 141: 2025-03-15T07:34:00
// Commit 157: 2025-03-20T00:43:04
// Commit 162: 2025-03-21T12:11:29
// Commit 168: 2025-03-23T07:16:15
// Commit 173: 2025-03-24T18:43:00
// Commit 6: 2025-02-03T11:40:25
