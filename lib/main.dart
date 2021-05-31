import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:rxdart/src/streams/value_stream.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHour = true;
  final _scrollController = ScrollController();

  @override
  void dispose(){
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stop Watch'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot){
                final value = snapshot.data;
                final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHour);
                return Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                RaisedButton(
                  color: Colors.green,
                  child: Text('Start', style: TextStyle(color: Colors.white),),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                },),
                SizedBox(width: 10.0,),
                RaisedButton(
                  color: Colors.red,
                  child: Text('Stop', style: TextStyle(color: Colors.white),),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                },),
              ],
            ),
            RaisedButton(
                color: Colors.black,
                child: Text('Reset', style: TextStyle(color: Colors.white),),
                shape: const StadiumBorder(),
                onPressed: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                },
              ),
            RaisedButton(
              color: Colors.amber,
              child: Text('Lap', style: TextStyle(color: Colors.white),),
              shape: const StadiumBorder(),
              onPressed: () {
                _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
              },
            ),
            Container(
              height: 120,
              margin: const EdgeInsets.all(8),
              child: StreamBuilder<List<StopWatchRecord>>(
                stream: _stopWatchTimer.records,
                initialData: _stopWatchTimer.records.value,
                builder: (context, snapshot){
                  final value = snapshot.data;
                  if(value.isEmpty){
                    return Container();
                  }
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent, 
                      duration: Duration(milliseconds: 200), 
                      curve: Curves.easeOut);
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final data = value[index];
                      return Column(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '${index + 1} - ${data.displayTime}',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                        ),
                      ],
                    );
                  },itemCount: value.length,);
                },
              ),
            ),         
          ],
        ),
      ), 
    );
  }
}




