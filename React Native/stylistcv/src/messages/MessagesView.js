
import React, {Component} from 'react';
import { View, Text, AsyncStorage } from 'react-native';

import Button from 'apsl-react-native-button';

import Storage from 'react-native-storage';

var storage = new Storage({
    // maximum capacity, default 1000
    size: 1000,

    // Use AsyncStorage for RN, or window.localStorage for web.
    // If not set, data would be lost after reload.
    storageBackend: AsyncStorage,

    // expire time, default 1 day(1000 * 3600 * 24 milliseconds).
    // can be null, which means never expire.
    defaultExpires: 1000 * 3600 * 24,

    // cache data in the memory. default is true.
    enableCache: true,

    // if data was not found in storage or expired,
    // the corresponding sync method will be invoked and return
    // the latest data.
    sync : {
        // we'll talk about the details later.
    }
})

class MessagesView extends Component{

  printObject = () => {

    storage.load({
    key: 'loginState',

    // autoSync(default true) means if data not found or expired,
    // then invoke the corresponding sync method
    autoSync: true,

    // syncInBackground(default true) means if data expired,
    // return the outdated data first while invoke the sync method.
    // It can be set to false to always return data provided by sync method when expired.(Of course it's slower)
    syncInBackground: true
}).then(ret => {
    // found data go to then()
    console.log(ret.userid);
}).catch(err => {
    // any exception including data not found
    // goes to catch()
    console.warn(err.message);
    switch (err.name) {
        case 'NotFoundError':
            // TODO;
            break;
        case 'ExpiredError':
            // TODO
            break;
    }
})

  }

  render() {
  return (
        <View marginTop={50} marginBottom={50}>
        <Button activeOpacity={0.5} style={{backgroundColor: 'blue', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.editObject}>
          Edit Object
        </Button>

        <Button activeOpacity={0.5} style={{backgroundColor: 'blue', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.printObject}>
          Print Object
        </Button>
        </View>
      );
  }
};

export default MessagesView
