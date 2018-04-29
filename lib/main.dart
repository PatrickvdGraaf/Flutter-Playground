import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

// The extension of the StatelessWidget makes the app itself a Widget.
// Almost everything is a Widget in Flutter. (even alignment, padding and
// layout.)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new RandomWords(),
    );
  }
}

// Example of a Stateful Widget. Stateful Widgets maintain state that might
// change during the lifetime of the Widget.
// Implementing a stateful widget requires two classes;
// 1) a StatefulWidget class that create an instance of a;
// 2) State class, which persists over the lifetime of the widget.
// Here is the first part of this implementation;
class RandomWords extends StatefulWidget {
// This Widget only creates a State class.
  @override
  State<StatefulWidget> createState() => new RandomWordsState();
}

// This class maintains the state for the RandomWords widget. The class will
// save the generated word pair, which will be created infinitely when the user
// scrolls, and also favourite word pairs as the user adds or removes them from
// the list by toggling the heart icon.
class RandomWordsState extends State<RandomWords> {
// A list of WordPairs for saving suggested word pairings. The underscore
// prefix enforces privacy in the Dart language.
  final _suggestions = <WordPair>[];

//  A list of saved pairs. In this case, a Set is preferred over a List because
//  a Set does not allow duplicate entries.
  final _saved = new Set<WordPair>();

// A constant for making the text size larger.
  final _biggerFont = const TextStyle(fontSize: 18.0);

//  Generate a word pair.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.label), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

//  This method builds the ListView that displays the suggested word pairings.
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // The itemBuilder callback is called once per suggested word pairing,
        // and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing.
        // For odd rows, the function adds a Divider widget to visually
        // separate the entries. Note that the divider may be difficult
        // to see on smaller devices.
        itemBuilder: (context, i) {
          // Add a one-pixel-high divider widget before each row in theListView.
          if (i.isOdd) return new Divider();

          // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView,
          // minus the divider widgets.
          final index = i ~/ 2;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
//        Calling setState() triggers the build() method for the State object,
//      resulting in a UI update.
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

//  Opens as screen which shows all saved word pairs.
  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
//              Adds horizontal spacing between each ListTile.
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }
}
