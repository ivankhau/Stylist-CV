//'use strict';

import React, { Component } from 'react';
import { View, ListView } from 'react-native';
import { Actions } from 'react-native-router-flux';

import { connect } from 'react-redux';

import { locationFetch } from '../../actions';

//const SearchItem = require('./SearchItem');
import SearchItem from './SearchItem';


const firebase = require('firebase');

const GeoFire = require('geofire');

class SearchMain extends Component {

  state = {
    dataSource: new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2,
    }),
    items: []
  };

  queryItems(latitude, longitude) {
    // Query Users Within Location
    const firebaseRef = firebase.database().ref().child('lo');
    const geoFire = new GeoFire(firebaseRef);
    const geoQuery = geoFire.query({
      center: [latitude, longitude],
      radius: 40.2335
    });

    //40.2335

    geoQuery.on('key_entered', (key, location) => {
      //console.log(key + " entered the query. Hi " + key + "!");
      //var items = [];
      firebase.database().ref().child('st').child(key).once('value', (snap) => {
        const tooobject = [String(snap.key)];
        tooobject.push(snap.val());

        this.state.items.push(tooobject);

        console.log(this.state.items);

        this.setState({
          dataSource: this.state.dataSource.cloneWithRows(this.state.items)
        });
      });
    });
  }

  componentWillMount() {
    this.props.locationFetch();

    /*navigator.geolocation.getCurrentPosition(
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
  }

  render() {
  return (
        <View style={styles.container}>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderItem.bind(this)}
          enableEmptySections={Boolean(true)}
          style={styles.listview}
        />
        </View>
      );
  }

  _renderItem(item) {
    const onPress = () => {
      console.log(item);
      //Actions.stylistProfileView({ useritem: item, title: (item[1].fn + ' ' + item[1].ln) });
    };

    return (
      <SearchItem item={item} onPress={onPress} />
    );
  }

}

const styles = {
  container: {
    marginTop: 60,
    marginBottom: 50,
    backgroundColor: 'white',
    flex: 1,
  },
  listview: {
    flex: 1,
  },
};

const mapStateToProps = state => {
  const search = '';

  return { search };
};

export default connect(mapStateToProps, { locationFetch })(SearchMain);
