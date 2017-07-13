import React, { Component } from 'react';
import { View, Text, StyleSheet, Image, Dimensions, ScrollView, ListView } from 'react-native';

import { Actions, } from 'react-native-router-flux';
//const ParallaxView = require('react-native-parallax-view');

const screenWidth = Dimensions.get('window').width;

const firebase = require('firebase');

class StylistProfileView extends Component {

  state = {
    dataSource: new ListView.DataSource({
    rowHasChanged: (row1, row2) => row1 !== row2,
    }),
    verified: null,
  };

  getRef() {
    return firebase.database().ref();
  }
  
  componentWillMount() {
    /*if (this.props.useritem.ve == 0) {
      this.state.verified = 'Unverified'
    } else {
      this.state.verified = 'Verified'
    };
    Actions.refresh({title: this.props.useritem.fn + ' ' + this.props.useritem.ln})*/
  }

  componentDidMount() {
    if (this.props.useritem[1].ve == 0) {
      this.state.verified = 'Unverified'
    } else {
      this.state.verified = 'Verified'
    };
    //Actions.refresh({title: this.props.useritem.fn + ' ' + this.props.useritem.ln})
  }

  portRef = firebase.database().ref().child('po');

  render() {

    return (

    <ScrollView alignItems={'center'} backgroundColor={'rgba(227,228,232,1)'} marginTop={55} marginBottom={50}>

      <View style={styles.viewContainer} height={110}>
          <View height={100} width={100}>
          <Image style={styles.profileImage} source={{uri: this.props.useritem[1].iu}} />
          </View>
          <View height={100} marginLeft={4} marginRight={4} width={screenWidth - 90 - 45 - 20 - 10} backgroundColor={'red'} >
              <Text>{this.props.useritem[1].wn}</Text>
              <Text>{this.props.useritem[1].ao}</Text>
              <Text>{this.props.useritem[1].at}</Text>
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

      <View style={styles.viewContainer} height={90}>

      </View>

      <View style={styles.viewContainer}>

      </View>

      <View style={styles.viewContainer}>

      </View>


    </ScrollView>

  )
  }



};

const styles = StyleSheet.create({

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




});

module.exports = StylistProfileView;
