'use strict';

import React, { Component } from 'react';
import { View, StyleSheet, ListView } from 'react-native';

import { Actions, } from 'react-native-router-flux';

//import * as firebase from 'firebase';
const SearchListItem = require('./SearchListItem');
const firebase = require('firebase');

const GeoFire = require('geofire');


//const firebaseApp = firebase.initializeApp(firebaseConfig);

class SearchView extends Component {

  state = {
    dataSource: new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2,
    }),
    items: []
  };

  queryItems(latitude, longitude) {
    // Query Users Within Location
    var firebaseRef = firebase.database().ref().child('lo');
    var geoFire = new GeoFire(firebaseRef);
    var geoQuery = geoFire.query({
      center: [latitude, longitude],
      radius: 40.2335
    });

    geoQuery.on('key_entered', (key, location) => {
      //console.log(key + " entered the query. Hi " + key + "!");
      //var items = [];
      firebase.database().ref().child('st').child(key).once('value', (snap) => {
        //items.push(snap.val());
        //console.log(items);

        //console.log(snap.key);

        //var testobject = snap.val();
        //testobject.push('testy');
        //console.log(testobject);

        var tooobject = [String(snap.key)];
        tooobject.push(snap.val());
        console.log(tooobject);

        //this.state.items.push(snap.val());

        this.state.items.push(tooobject);



        this.setState({
          dataSource: this.state.dataSource.cloneWithRows(this.state.items)
        });
      });
    });
  }

  componentDidMount() {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        var initialPosition = JSON.stringify(position);
        //this.setState({initialPosition});
        console.log(initialPosition);
        //console.log(position.coords);
        this.queryItems(position.coords.latitude, position.coords.longitude)
      },
      (error) => alert(error),
      { enableHighAccuracy: true, timeout: 20000, maximumAge: 1000 }
    );
    /*this.watchID = navigator.geolocation.watchPosition((position) => {
      var lastPosition = JSON.stringify(position);
      this.setState({lastPosition});
    });*/

    //this.queryItems();
  }

  render() {
  return (
        <View style={styles.container}>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderItem.bind(this)}
          enableEmptySections={true}
          style={styles.listview}
        />
        </View>
      );
  }

  _renderItem(item) {

    const onPress = () => {
      console.log(item);
      Actions.stylistProfileView({ useritem: item, title: (item[1].fn + ' ' + item[1].ln) });
    };

    return (
      <SearchListItem item={item} onPress={onPress} />
    );
  }

}

const styles = StyleSheet.create({
  container: {
    marginTop: 50,
    marginBottom: 50,
    backgroundColor: 'white',
    flex: 1,
  },
  listview: {
    flex: 1,


  },
});

module.exports = SearchView;
