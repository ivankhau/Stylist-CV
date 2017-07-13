'use strict'

import React, {Component} from 'react';
import { View, Text, StyleSheet, ListView, AppRegistry, TouchableHighlight, Modal, Image, TouchableOpacity, Dimensions } from 'react-native';

import { Actions } from 'react-native-router-flux';

//import * as firebase from 'firebase';
const ActivityListItem = require('./ActivityListItem');
const firebase = require('firebase');

const screenWidth = Dimensions.get('window').width;
const screenHeight = Dimensions.get('window').height;

//import ImageZoom from '../modules/ImageZoom';

class ActivityView extends Component {

  state = {
    dataSource: new ListView.DataSource({
    rowHasChanged: (row1, row2) => row1 !== row2,
    }),
  };

  itemsRef = this.getRef().child('ac');

  getRef() {
    return firebase.database().ref();
  }

  listenForItems(itemsRef) {
    itemsRef.on('value', (snap) => {
      // get children as an array
      var items = [];
      snap.forEach((child) => {
        items.push({
          URLSmall: child.val().us,
          URLLarge: child.val().ul,
          text: child.val().te,
          name: child.val().fn,
          gender: child.val().ge,
          date: child.val().da,
          _key: child.key
        });
      });

      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(items)
      });
      console.log({items});
    });
  }

  componentDidMount() {
    this.listenForItems(this.itemsRef);
  }

  render() {
  return (
        <View style={styles.container}>
        <ListView
          contentContainerStyle={styles.listview}
          dataSource={this.state.dataSource}
          renderRow={this._renderItem.bind(this)}
          enableEmptySections={true}
          />
        </View>
      );
  }

  _renderItem(item) {

    const onPress = () => {
      return (
        console.log('poop'),
        //this.showLargeImage({item:item})
        //Actions.largeImageView({itemObject:item})
        this.showLargeImage(item:item)
      )
    };

    return (
      <ActivityListItem item={item} onPress={onPress} />
    );
  }

  showLargeImage(item) {

    Actions.largeImageView({itemObject:item})

  }

};

const styles = StyleSheet.create({
  container: {
    marginTop: 55,
    marginBottom: 50,
    backgroundColor: 'white',
    flex: 1,

  },
  listview: {
    justifyContent: 'center',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },

});

module.exports = ActivityView;
