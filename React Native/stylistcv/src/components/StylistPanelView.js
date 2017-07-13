'use strict'

import React, {Component} from 'react';
import { View, Text, StyleSheet, TextInput, AsyncStorage, ScrollView, Dimensions, } from 'react-native';

import Button from 'apsl-react-native-button';
import Storage from 'react-native-storage';

const screenWidth = Dimensions.get('window').width;

class StylistPanelView extends Component {

render() {
  return (
    <View style={styles.container}>


    </View>
  )
}


}

const styles = StyleSheet.create({

  container: {
    flex: 1,
    marginBottom: 50,
    marginTop: 50,
    backgroundColor: 'rgba(227,228,232,1)',
    paddingLeft: 5,
    paddingRight: 5,

  }


})


module.exports = StylistPanelView;
