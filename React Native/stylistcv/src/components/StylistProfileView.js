import React, { Component } from 'react';
import { View, Text, Image, Dimensions, ScrollView, ListView } from 'react-native';

const screenWidth = Dimensions.get('window').width;
const firebase = require('firebase');

const ActivityListItem = require('../activity/ActivityListItem');

class StylistProfileView extends Component {

  state = {
    dataSource: new ListView.DataSource({
    rowHasChanged: (row1, row2) => row1 !== row2,
    }),
    verified: null,
    portItems: [],
    revItems: [],
  };

  componentWillMount() {
    const { useritem } = this.props;

    if (useritem[1].ve === 0 || useritem[1].ve === null) {
      this.state.verified = 'Unverified';
    } else {
      this.state.verified = 'Verified';
    }

    this.listenForPort(this.portRef);
  }

  componentDidMount() {

  }

  getPortRef() {
    return firebase.database().ref();
  }

  listenForPort(portRef) {
    portRef.child(this.props.useritem[0]).once('value', (snap) => {
      //console.log(snap.val());
      //snap.val().map(snapval);
      this.setState({ portItems: snap.val() });
      console.log(this.state.portItems);
    });
  }

  portRef = this.getPortRef().child('po');

  _renderItem(item) {
    return (
      <ActivityListItem item={item} />
    );
  }

  render() {
    const { useritem } = this.props;

    return (

    <ScrollView
    alignItems={'center'}
    backgroundColor={'rgba(227,228,232,1)'}
    marginTop={55}
    marginBottom={50}
    >

      <View style={styles.viewContainer} height={110}>
          <View height={100} width={100}>
          <Image style={styles.profileImage} source={{ uri: useritem[1].iu }} />
          </View>
          <View
          height={100}
          marginLeft={4}
          marginRight={4}
          width={screenWidth - 90 - 45 - 20 - 10}
          backgroundColor={'red'}
          >
              <Text>{useritem[1].wn}</Text>
              <Text>{useritem[1].ao}</Text>
              <Text>{useritem[1].at}</Text>
              <Text>{this.state.verified}</Text>
              <Text>Rating</Text>
          </View>
          <View height={100} width={45} backgroundColor={'cyan'} >
              <Text>9 mi</Text>
              <Text>$</Text>
              <Text>DB</Text>
          </View>
      </View>


      <View style={styles.viewContainer} height={71}>
        <Text> ABOUT </Text>
      </View>

      <View style={styles.viewContainer} height={33}>
        <Text> WRITE A REVIEW </Text>
      </View>

      <View style={styles.viewContainer} height={33}>
        <Text> VIEW ALL </Text>
      </View>

      <View style={styles.viewContainer} height={90} />
        <ListView
        contentContainerStyle={styles.listview}
        dataSource={this.state.dataSource}
        renderRow={this._renderItem.bind(this)}
        enableEmptySections={Boolean(true)}
        horizontal={Boolean(true)}
        vertical={Boolean(false)}
        />
      <View style={styles.viewContainer} />

      <View style={styles.viewContainer} />

    </ScrollView>

  );
  }
}

const styles = {
  listview: {
    justifyContent: 'center',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },
  viewContainer: {
    padding: 5,
    marginTop: 5,
    backgroundColor: 'white',
    borderColor: 'rgba(217,217,219,1)',
    borderWidth: 1,
    flex: 1,
    flexDirection: 'row',
    width: screenWidth - 10,
  },
  header: {
    marginTop: 80,
  },
  container: {
    flex: 1,
    marginBottom: 50,
  },
  tempText: {
    height: 300,
  },
  profileImage: {
    height: 100,
    width: 100,
  },
};

module.exports = StylistProfileView;
