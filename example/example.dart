import 'package:chromium_pickle/chromium_pickle.dart';

void main() {
  // Create empty pickle
  var pickle = Pickle.empty();

  // Write value to pickle
  pickle.writeInt(1024);

  // Create iterator
  var iterator = pickle.createIterator();

  // Read value
  print(iterator.readInt());

  // Dump pickle to Uint8List
  var pickleData = pickle.toUint8List();

  // Create new pickle from Uint8List
  var newIterator = Pickle.fromUint8List(pickleData).createIterator();

  // There is it again!
  print(newIterator.readInt());
}
