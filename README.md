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

