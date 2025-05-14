# Methods.dart

```dart
class Methods extends ChangeNotifier {
  final CollectionReference habitsdb =
      FirebaseFirestore.instance.collection('habitsdb');
  final CollectionReference valuesdb =
      FirebaseFirestore.instance.collection('valuesdb');
```

These are used to create collection in Firestore database.

## Using Map in dart

a `Map` in Dart (and many other programming languages) is a collection where you store data as pairs of **keys** and **values**. You use a unique key to look up its corresponding value. 

```dart
Future<void> loadCategoryValues() async{
    DocumentSnapshot vDoc = await valuesdb.doc(categoryValuesDocId).get();
    DocumentSnapshot lDoc = await valuesdb.doc(categoryLevelDocId).get();

    Map lData = lDoc.data() as Map;
    Map vData = vDoc.data() as Map;

    // Update the local categoryValues map with values from Firestore
        // We need to convert from the string keys to HCategory enum keys
        categoryValues[HCategory.int] = vData['int'] ?? 0;
        categoryValues[HCategory.effiecient] = vData['effiecient'] ?? 0;
        categoryValues[HCategory.strength] = vData['strength'] ?? 0;
        categoryValues[HCategory.adaptation] = vData['adaptation'] ?? 0;
        categoryValues[HCategory.productive] = vData['productive'] ?? 0;
        //updateing level values
        categoryLevels[HCategory.int] = lData['int'] ?? 0;
        categoryLevels[HCategory.effiecient] = lData['effiecient'] ?? 0;
        categoryLevels[HCategory.strength] = lData['strength'] ?? 0;
        categoryLevels[HCategory.adaptation] = lData['adaptation'] ?? 0;
        categoryLevels[HCategory.productive] = lData['productive'] ?? 0;
        notifyListeners();
  } 
```

so usually **DocumentSnapshot** Data need to be set `as Map` like this

```dart
 Map lData = lDoc.data() as Map;
 Map vData = vDoc.data() as Map;
```

So the **DocumentSnapshot** data is already key value pairs but to tell dart to treat it as such we need to set it `as Map`

This is how it looks inside of the data:

```json
{
  "int": 1,
  "effiecient": 0,
  "strength": 2,
  "adaptation": 0,
  "productive": 1
}
```

## Using .map() in dart

**Note: Map and .map() two are completely different concepts. Map creates key value pair and** `.map()` **function iterates through the list**

```dart
items: HCategory.values.map((category) => 
DropdownMenuItem(value: category, child: Text(category.name))).toList(),
```

so here it’s iterating Hcategory one by one to the DropdownMenuItem. that is 

`[HCategory.int, HCategory.effiecient, HCategory.strength, ...]`

Here also same thing happening

```dart
// Update to return level values instead of raw counters
  List<RadarEntry> getRadarEntries() {
    final categories = [
      HCategory.productive,
      HCategory.int,
      HCategory.strength,
      HCategory.adaptation,
      HCategory.effiecient,
    ];
    // Return level values for the radar chart
    return categories
        .map((category) =>
            RadarEntry(value: categoryLevels[category]?.toDouble() ?? 0))
        .toList();
  }
```

Here it also iterates categories values to be specific.

```dart
return categories.map((category) =>
            RadarEntry(value: categoryLevels[category]?.toDouble() ?? 0)).toList();
```

And it’ll kind of look like this:

```dart
[
RadarEntry(value: 0),  // productive
RadarEntry(value: 0),  // int
RadarEntry(value: 2),  // strength
RadarEntry(value: 1),  // adaptation
RadarEntry(value: 0)   // effiecient
]
```

## `.set` and `.add` in Firebase

### `.add`  Used to **create a new document** with an **auto-generated ID** inside a collection:

```dart
habitsdb.add({
      'habitname': name,
      'category': category.name,
    });
```

### `.set` Used to **create or overwrite** a document at a **specific path (ID):**

```dart
Future<void> saveCategoryValues() async {
    await valuesdb.doc(categoryValuesDocId).set({
      'int': categoryValues[HCategory.int],
      'effiecient': categoryValues[HCategory.effiecient],
      'strength': categoryValues[HCategory.strength],
      'adaptation': categoryValues[HCategory.adaptation],
      'productive': categoryValues[HCategory.productive],
    });
```

## To delete in Firebase database

`await FirebaseFirestore.instance.collection('users').doc('alice123').delete();`

So here `docID` is a unique identifier called a document ID, the `docID` in this code comes from `homescreen.dart`, but we need that to delete the specific item.

```dart
final CollectionReference habitsdb = FirebaseFirestore.instance.collection('habitsdb');

habitsdb.doc(docID).delete();
```

## Stream, snapshot, StreamBuilder

**Stream:** Stream is just like how it name suggests, it streams stuff, in this case it streams data, like how stream of water comes out of the pipe

**Snapshot:** Snapshot is the state of the data which is latest of the Stream

Each snapshot contains:

- The actual data (documents)
- Metadata (information about the data)
- State information (loading, error, success)

**StreamBuilder:** StreamBuilder is a widget that is specifically for using streams in flutter

- StreamBuilder Subscribes when the widget is created
- Updating when new data arrives
- Unsubscribing when the widget is disposed (preventing memory leaks)

```dart
Stream gethabitStream() {
    final habitStream =
        habitsdb.orderBy('category', descending: true).snapshots();
    return habitStream;
  }

```

So here we are creating a firebase stream, which then used in the `homescreen.dart` using StreamBuilder. The `.snapshots()` method creates the pipe from the Firebase collection.

```
StreamBuilder(
                  stream: method.gethabitStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List habitList = snapshot.data.docs;
                      return ListView.builder(...
```
