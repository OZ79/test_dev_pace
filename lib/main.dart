import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Page(),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
      child: Image(
        fit: BoxFit.cover,
        image: AssetImage('assets/logo.png'),
      ),
    );
  }
}

class Page extends HookWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //const itemCount = 13;
    final itemCount = useState(0);
    final rows = itemCount.value ~/ 2 + itemCount.value % 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxHeight =
        (((screenWidth - 10) * 0.5) * 0.5) * rows + 10 * (rows - 1);
    final controller = useScrollController();

    return Stack(
      children: [
        LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Scrollbar(
            thickness: 12,
            hoverThickness: 12,
            isAlwaysShown: true,
            trackVisibility: true,
            showTrackOnHover: true,
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          child: Center(
                            child: Logo(),
                          ),
                        ),
                        if (itemCount.value == 1)
                          Container(
                            width: screenWidth / 2,
                            height: screenWidth / 4,
                            alignment: Alignment.center,
                            color: Colors.blueAccent,
                            child: const Text('Item 1'),
                          ),
                        if (itemCount.value > 1)
                          SizedBox(
                            height: boxHeight,
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: screenWidth / 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 2.0,
                                ),
                                itemCount: itemCount.value,
                                itemBuilder: (BuildContext context, int index) {
                                  final num = ++index;
                                  return Container(
                                    alignment: Alignment.center,
                                    color: Colors.blueAccent,
                                    child: Text('Item $num'),
                                  );
                                }),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        Column(
          children: [
            IconButton(
              iconSize: 35,
              icon: const Icon(Icons.add_circle_outlined),
              onPressed: () {
                itemCount.value++;
              },
            ),
            IconButton(
              iconSize: 35,
              icon: const Icon(Icons.do_disturb_on_rounded),
              onPressed: () {
                if (itemCount.value > 0) {
                  itemCount.value--;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
