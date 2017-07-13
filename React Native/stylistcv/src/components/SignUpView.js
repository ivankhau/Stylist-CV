import React, { Component } from 'react';
import { View, Text, StyleSheet, TextInput, AsyncStorage, ScrollView, Dimensions, } from 'react-native';

import Button from 'apsl-react-native-button';
import Storage from 'react-native-storage';

const screenWidth = Dimensions.get('window').width;

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
    sync: {
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

class SignUpView extends Component {

  //global.storage = storage;

  state = {
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    license: '',
    location: null,
  };

  render() {
    const { firstName, lastName, email, password, license, location, } = this.state;
  return (
        <ScrollView style={styles.container}>
          <View flexDirection={'row'}>
            <View width={(screenWidth / 2) - 10}>
              <TextInput
               placeholder={'First Name'}
               onChangeText={firstName => this.setState({firstName})}
               value={firstName}


              />
              </View>
              <View width={screenWidth/2 - 10}>
              <TextInput
               placeholder={'Last Name'}
               onChangeText={lastName => this.setState({lastName})}
               value={lastName}


              />
              </View>
          </View>
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
          <TextInput
           placeholder={'License Number'}
           onChangeText={license => this.setState({license})}
           value={license}
          />
          <TextInput
           placeholder={'Location'}
           onChangeText={location => this.setState({location})}
           value={location}
          />
          <Button
          activeOpacity={0.5}
          style={{ backgroundColor: 'black', borderWidth: 0, borderRadius: 0 }}
          textStyle={{ fontSize: 14, color: 'white', //fontFamily: 'avenirnextdemi' }}
          marginTop={10}
          >
            SIGN UP
          </Button>


        </ScrollView>
      );
  }
};

module.exports = SignUpView;
