'use strict';

import React, { Component } from 'react';
import { View, StyleSheet, ListView } from 'react-native';
import { Actions } from 'react-native-router-flux';

const ActivityListItem = require('./ActivityListItem');
const firebase = require('firebase');

class ActivityView extends Component {

  state = {
    dataSource: new ListView.DataSource({
    rowHasChanged: (row1, row2) => row1 !== row2,
    }),
    items: [],
  };

  componentDidMount() {
    this.listenForItems(this.itemsRef);
  }

  getRef() {
    return firebase.database().ref();
  }

  listenForItems(itemsRef) {
    itemsRef.on('value', (snap) => {
      // get children as an array
      //var items = [];
      snap.forEach((child) => {
        this.state.items.push({
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
        dataSource: this.state.dataSource.cloneWithRows(this.state.items)
      });
    });
  }

  itemsRef = this.getRef().child('ac');

  showLargeImage(item) {
    Actions.largeImageView({ itemObject: item });
  }

  _renderItem(item) {
    const onPress = () => {
      return (
        this.showLargeImage(item:item)
      );
    };

    return (
      <ActivityListItem item={item} onPress={onPress} />
    );
  }

  render() {
  return (
        <View style={styles.container}>
        <ListView
          contentContainerStyle={styles.listview}
          dataSource={this.state.dataSource}
          renderRow={this._renderItem.bind(this)}
          enableEmptySections={Boolean(true)}
        />
        </View>
      );
  }
}

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
