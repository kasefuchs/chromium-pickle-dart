<h3 align="center">Chromium Pickle Dart</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/Kasefuchs/chromium-pickle-dart.svg)](https://github.com/Kasefuchs/chromium-pickle-dart/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/Kasefuchs/chromium-pickle-dart.svg)](https://github.com/Kasefuchs/chromium-pickle-dart/pulls)
[![GitHub Stars](https://img.shields.io/github/stars/Kasefuchs/chromium-pickle-dart.svg)](https://github.com/Kasefuchs/chromium-pickle-dart/stargazers)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> This library ports Chromium's Pickle class to Dart.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Built Using](#built_using)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

> This library provides facilities for basic binary value packing and unpacking.
>
> The Pickle class supports appending primitive values (ints, strings, etc.) to a pickle instance. The Pickle instance
> grows its internal memory buffer dynamically to hold the sequence of primitive values. The internal memory buffer is
> exposed as the "data" of the Pickle. This "data" can be passed to a Pickle object to initialize it for reading.
>
> When reading from a Pickle object, it is important for the consumer to know what value types to read and in what order
> to read them as the Pickle does not keep track of the type of data written to it.
>
> The Pickle's data has a header which contains the size of the Pickle's payload.

## 🏁 Getting Started <a name = "getting_started"></a>

### Prerequisites

This library doesn't have many requirements, so here's what you need:

```
Dart SDK >=2.18.0 <3.0.0
```

### Installing

Just run it and now you're ready to rock

```
dart pub add chromium_pickle
```

## 🎈 Usage <a name="usage"></a>

Here is a basic application using pickles

```dart
import 'package:chromium_pickle/chromium_pickle.dart';

void main() {
  // Create empty pickle
  var pickle = Pickle.empty();

  // Write value to pickle
  pickle.writeInt(25565);

  // Create iterator
  var iterator = pickle.createIterator();

  // Print current pickle value
  print(iterator.readInt());

  // Print buffer content
  print(buffer.toUint8List());
}

```

## ⛏️ Built Using <a name = "built_using"></a>

- [Dart SDK](https://dart.dev/) - Programming language

## 🎉 Acknowledgements <a name = "acknowledgement"></a>

- [Original Chromium Pickle](https://chromium.googlesource.com/chromium/src/+/main/base/pickle.cc)
- [chromium-pickle-js](https://github.com/electron/node-chromium-pickle-js/)
- [AsarSharp](https://github.com/MWR1/asarsharp)
- [The Documentation Compendium](https://github.com/Kasefuchs/chromium-pickle-dart)