# DiaryBook

This is my first web app

## Getting Started

visit this site: https://flutter-web-128a1.web.app
```shell
cd path/to/diarybook_project/folder
flutter run -d chrome --release
```

## Deploy
First, you should install `nvm` and `Node.js`
follow this site:https://firebase.google.com/docs/cli

* Setup Firebase CLI
```shell
npm -i firebase-tools
firebase login
```

* Deploy project
<div style="background-color:rgba(0, 0, 0, 0.0470588); padding:px; margin:5px">

<span style="color:#008000"># check anything is fine in realse</span>
flutter build web 
firebase init

<span style="color:#008000">## choice options:</span>
? Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. (Press \<space\> to select, \<a\> to togg
le all, \<i\> to invert selection, and \<enter\> to proceed)
 ◯ Realtime Database: Configure a security rules file for Realtime Database and (optionally) provision default instance
 ◯ Firestore: Configure security rules and indexes files for Firestore
 ◯ Functions: Configure a Cloud Functions directory and its files
❯◉ Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys
 ◯ Hosting: Set up GitHub Action deploys
 ◯ Storage: Configure a security rules file for Cloud Storage
 ◯ Emulators: Set up local emulators for Firebase products
(Move up and down to reveal more choices)

=== Project Setup
First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add, 
but for now we'll just set up a default project.

? Please select an option: <span style="color:#0066cc">Use an existing project</span>
? Select a default Firebase project for this directory: <span style="color:#0066cc">flutter-web-128a1 (flutter-web)</span>

=== Hosting Setup
Your public directory is the folder (relative to your project directory) that
will contain Hosting assets to be uploaded with firebase deploy. If you
have a build process for your assets, use your build's output directory.
? What do you want to use as your public directory? <span style="color:#0066cc">build/web</span>
? Configure as a single-page app (rewrite all urls to /index.html)? <span style="color:#0066cc">Yes</span>
? Set up automatic builds and deploys with GitHub? <span style="color:#0066cc">No</span>
? File build/web/index.html already exists. Overwrite? <span style="color:#0066cc">No</span>

firebase deploy
</div>

---
# Flutter Diving Deeper

6-4 How Flutter Rebuilds and Repaints the Screen

<img src="imgs/widget_lifecycle.jpg"/>|<img src="imgs/widgetTree&elementTree.jpg"/>
:--:|:--:
Widget LifeCycle|Tree

每當`setState()`被呼叫時(或用MediaQuery取得的螢幕大小，被彈出鍵盤改變時)，都會重新建構呼叫的Widget instance，重新執行一遍widget的lifecycle，然後Element重新指向新的instance Widget。State是獨立於Widget(單獨的Object)，所以State不會再建構一次。

6-12 Understanding the Widget Lifecycle

在建構StatefulWidget instance時，過程是widget construction-->didUpdateWidget()-->build()，只有在第一次產生State時會作`initState()`，作`setState()`並不重新建構新的State instance，直到`dispose()`呼叫刪除該State object並表示該element不存在。在`didUpdateWidget(oldWidget)`新產生的widget可以比較舊的待刪除的widget情況。※這裡容易搞混的是子類State的build()其實是widget的，並不是State在build()。例如：
```dart
class NewTransaction extends StatefulWidget{
    NewTransaction(){
        print('Constructor NewTransaction Widget');
        //叫好多次
    }
    @override
    _NewTransactionState createState(){
        print('createState NewTransaction Widget');
        return _NewTransactionState();
        //只叫一次
    }
}

class _NewTransactionState extends State<NewTransaction>{
    _NewTransaction(){
        print('Constructor NewTransaction State');
        //只會叫一次
    }
    @override
    void initState(){
        super.initState();
        print('initState()');
        //只叫一次
    }
    @override
    void didiUpdateWidget(NewTransaction oldWidget){
        print('didUpdateWidget()');
        super.didUpdateWidget(oldWidget);
        //叫好多次，除了第一次不叫
    }
    @override
    void dispose(){
        print('dispose()');
        super.dispose();
        //直到element刪除，State砍掉了，呼叫一次
    }
    @override
    Widget build(BuildContext context) {
        //最容易搞混，其實是Widget在叫，建構State沒有在用這個方法
    }
}
```

6-15~6-17 Using Keys

在ListView中的item如果是Stateful，就最好對每個item加上唯一key，這樣在對List資料作增刪item的時候，每個item element的State能夠確定找到對應的widget，不會將每個該對應的item之State裡的資料，配錯widget item。可以參考6-15影片"Problem with Lists and Stateful Widgets"發生的錯誤。
```dart
class _TransactionItemState extends State<TransactionItem>{
    /*
    State裡的成員資料，可能會配錯widget，
    如果先在TransactionItem widget的建構式加入唯一key
    就可以避免State配錯widget。
    */
    Color _bgColor;//會有配錯widget風險
    @override
    void initState(){
        super.initState();
        const avaiableColors = [
        Colors.red,
        Colors.black,
        Colors.blue,
        Colors.purple,
        ];
        _bgColor = avaiableColors[Random().nextInt(4)];
    }
    @override
    Widget build(BuildContext context){
        //....
        ListTile(
            leading:CircleAvatar(
                backgroundColor:_bgColor,
            ),
            //...
        );
    }
}
```


