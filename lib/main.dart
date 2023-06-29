import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olahraga/cubit/data_cubit.dart';
import 'package:olahraga/cubit/data_state.dart';
import 'package:olahraga/helper/dio_helper.dart';
import 'package:olahraga/ui/add_edit_data.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListDataPage(),
    );
  }
}

class ListDataPage extends StatefulWidget {
  const ListDataPage({Key? key}) : super(key: key);

  @override
  _ListDataPageState createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  late DataCubit? dataCubit;

  @override
  void initState() {
    dataCubit = DataCubit(DioHelper());
    dataCubit?.getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: const Text('Flutter CRUD Cubit'),
      ),
      body: BlocProvider<DataCubit>(
        create: (_) => dataCubit!,
        child: BlocListener<DataCubit, DataState>(
          listener: (_, state) {
            if (state is FailureAllLoadingDataState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is FailureDeleteDataState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            } else if (state is SuccessAllLoadingDataState) {
              if (state.message.isNotEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message))
                );
              }
            }
          },
          child: BlocBuilder<DataCubit, DataState>(
            builder: (_, state) {
              if (state is LoadingDataState) {
                return Center(
                  child: Platform.isIOS 
                  ? const CupertinoActivityIndicator() 
                  : const CircularProgressIndicator(),
                );
              } else if (state is FailureAllLoadingDataState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is SuccessAllLoadingDataState) {
                var listDatas = state.listDatas;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listDatas.length,
                  itemBuilder: (_, index) {
                    var modelData = listDatas[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modelData.nama_cabang,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              modelData.deskripsi,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              modelData.sejarah,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red
                                  ),
                                  onPressed: () async {
                                    var dialogConfirmDelete = Platform.isIOS ? await showCupertinoDialog<bool>(
                                      context: context,
                                      builder: (_) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Warning'),
                                          content: Text(
                                            'Are you sure want to delete ${modelData.nama_cabang}\'s data?'
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              isDefaultAction: true,
                                              child: const Text('Delete'),
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    )
                                    : await showDialog<bool>(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: const Text('Warning'),
                                          content: Text(
                                            'Are you sure want to delete ${modelData.nama_cabang}\'s data?'
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    );
                                    if (dialogConfirmDelete != null && dialogConfirmDelete) {
                                      dataCubit?.deleteData(modelData.id!);
                                    }
                                  }, child: const Text('DELETE'),
                                ),
                                TextButton(
                                  child: const Text('EDIT'),
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditData(
                                          modelData: modelData,
                                        )
                                      )
                                    );
                                    if (result != null) {
                                      dataCubit?.getAllData();
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditData(),
            ),
          );
          if (result != null) {
            dataCubit?.getAllData();
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a blue toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
