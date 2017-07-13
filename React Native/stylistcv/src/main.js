  'use strict';

import React, { Component } from 'react';
import {
  View,
  AsyncStorage,
} from 'react-native';
//import * as firebase from 'firebase';

import {
  Scene, Router,
} from 'react-native-router-flux';

import Storage from 'react-native-storage';
import MainView from './MainView';
import LocationPromptView from './components/LocationPromptView';

const storage = new Storage({
    size: 1000,
    storageBackend: AsyncStorage,
    defaultExpires: null,
    enableCache: true,
    sync: {
    }
});
const firebase = require('firebase');

const firebaseConfig = {
  apiKey: 'AIzaSyDZrf_Arq7G69XITSYoZGyFhZZ9IlWdp-w',
  authDomain: 'hair-cv.firebaseapp.com',
  databaseURL: 'https://hair-cv.firebaseio.com',
  storageBucket: 'hair-cv.appspot.com',
};

class Main extends Component {

  state = {
      whichScreen: null,
  }

  componentWillMount() {
    firebase.initializeApp(firebaseConfig);

    storage.load({
    key: 'userState',

    autoSync: true,
    syncInBackground: true
    }).then(ret => {
    // found data go to then()

    if (ret.firstTime === 0) {
      this.setState({
        whichScreen: 0
      });
    } else {
      this.setState({
        whichScreen: 1
      });
    }

    //console.log(ret.userid);
}).catch(err => {
    // any exception including data not found
    // goes to catch()
    console.warn(err.message);
    switch (err.name) {
        case 'NotFoundError':
            // TODO;
            this.setState({
              whichScreen: 1
            });
            break;
        case 'ExpiredError':
            // TODO
            this.setState({
              whichScreen: 1
            });
            break;
    }
});
  }

  render() {
    if (this.state.whichScreen === 0) {
        return (
          <MainView />
      );
    } else if (this.state.whichScreen === 1) {
      return (
        <Router>
        <Scene key="newUserRoot">
          <Scene
          key="locationPromptView"
          hideNavBar={Boolean(true)}
          component={LocationPromptView}
          initial={Boolean(true)}
          />
          <Scene key="mainView" component={MainView} />
        </Scene>
        </Router>
      );
    } else {
      return <View />;
    }
  }
}

export default Main;
