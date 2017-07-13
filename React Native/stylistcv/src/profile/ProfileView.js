import React, {Component} from 'react';
import { View, Text, StyleSheet, TextInput, AsyncStorage, } from 'react-native';

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
    //defaultExpires: 1000 * 3600 * 24,

    // cache data in the memory. default is true.
    enableCache: true,

    // if data was not found in storage or expired,
    // the corresponding sync method will be invoked and return
    // the latest data.
    sync : {
        // we'll talk about the details later.
    }
})


const firebase = require('firebase');

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginBottom: 50,
    marginTop: 50,
    backgroundColor: 'white',
    paddingLeft: 10,
    paddingRight: 10
  },

});

class ProfileView extends Component{

  //global.storage = storage;

  state = {
    email: '',
    password: '',
  };

  loginEmail = () => {
    const { email, password } = this.state;
    console.log(email, password);
    this.setState({
      loaded: false
    });

    firebase.auth().signInWithEmailAndPassword(this.state.email, this.state.password).then(function(firebaseUser) {
        //this.props.navigator.immediatelyResetRouteStack([{name:'tweets'}]);
        console.log('success');

        console.log(firebase.auth().currentUser);

      }.bind(this))
      .catch(function(error) {
        return console.log('failure');//this.setState({errorMessage: error.message});
      }.bind(this));
    //Actions.main();
  };

  checkAuth = () => {
    console.log(firebase.auth().currentUser);
  };

  editObject = () => {
    storage.save({
    key: 'loginState',   // Note: Do not use underscore("_") in key!
    rawData: {
        from: 'some other site',
        userid: 'some userid8===D',
        token: 'some token'
    },

    // if not specified, the defaultExpires will be applied instead.
    // if set to null, then it will never expire.
    expires: 1000 * 3600
});

  };

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
  };

  firebaseFetch = () => {

    firebase.database().ref().child('st').child(firebase.auth().currentUser.uid).once('value', (snap) => {
      console.log(snap.val());
    })

  }

  render() {
    const { email, password } = this.state;
  return (
        <View style={styles.container}>
          <TextInput
           placeholder={'Email'}
           onChangeText={email => this.setState({email})}
           value={email}
          />
          <TextInput
           placeholder={'Password'}
           onChangeText={password => this.setState({password})}
           value={password}
          />
          <Button activeOpacity={0.5} style={{backgroundColor: 'black', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.loginEmail}>
            SIGN IN
          </Button>

          <Button activeOpacity={0.5} style={{backgroundColor: 'black', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.checkAuth}>
            CHECK AUTH
          </Button>

          <Button activeOpacity={0.5} style={{backgroundColor: 'blue', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.editObject}>
            Edit Object
          </Button>

          <Button activeOpacity={0.5} style={{backgroundColor: 'blue', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.printObject}>
            Print Object
          </Button>

          <Button activeOpacity={0.5} style={{backgroundColor: 'red', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} marginTop={10} onPress={this.firebaseFetch}>
            Query Firebase Object
          </Button>


        </View>
      );
  }
}

export default ProfileView;
