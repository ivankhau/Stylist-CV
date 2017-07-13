'use strict'

import React, {Component} from 'react';
import { View, Text, Image, StyleSheet, Dimensions, AsyncStorage } from 'react-native';

import { Actions, } from 'react-native-router-flux';

import Button from 'apsl-react-native-button';

const screenWidth = Dimensions.get('window').width;

import Storage from 'react-native-storage';

var storage = new Storage({
    size: 1000,
    storageBackend: AsyncStorage,
    enableCache: true,
    sync : {
    }
})



class LocationPromptView extends Component {

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.toplogotext}>STYLIST</Text>
        <Text style={styles.bottomlogotext}>CV</Text>
        <View height={15} />

        <Image style={styles.imageSize} source={require('../img/locationPromptSplash.png')} />
        <View height={15} />

        <Text style={styles.messagetext}>Stylist CV uses your location to find nearby hairstylists.</Text>

        <View height={15} />
        <Button activeOpacity={0.5} style={{backgroundColor: 'black', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white'}} onPress={this.buttonTapped}>
          I UNDERSTAND
        </Button>
      </View>
    )
  }

  buttonTapped() {
    storage.save({
    key: 'userState',
    rawData: {
        firstTime: 0,
    },
    expires: null
    });
    Actions.mainView();
  }

};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'white',
    padding: 10,
  },
  toplogotext: {
    //fontFamily: 'avenirnextregular',
    fontSize: 28,
  },
  bottomlogotext: {
    //fontFamily: 'georgiaitalic',
    fontSize:28,
  },
  messagetext: {
    //fontFamily: 'avenirnextregular',
    fontSize: 16,
    textAlign: 'center',

  },

  imageSize: {
    width: screenWidth * 0.60,
    height: screenWidth * 0.30,
    borderRadius: (screenWidth* 0.30) / 2,
    borderWidth: 2,
    borderColor: 'rgba(182,197,217,1)',
  },



});

module.exports = LocationPromptView;
