'use strict';

import React, { Component } from 'react';
import { Actions } from 'react-native-router-flux';

import {
  View, Text, StyleSheet, Image, TouchableOpacity, Dimensions
} from 'react-native';

const screenWidth = Dimensions.get('window').width;
const screenHeight = Dimensions.get('window').height;

class LargeImageView extends Component {

  render() {
    return (

      <TouchableOpacity
      onPress={() => {
      //this.setModalVisible(!this.state.modalVisible)
      Actions.pop();
      }}
      >
         <View style={styles.Container}>

         <View style={styles.NameTextContainer}>
         <Text style={styles.NameText}>
         {this.props.itemObject.name ? this.props.itemObject.name : ''}
         </Text>
         <Text style={styles.NameText}>{this.props.itemObject.date}</Text>
         </View>

          <Image style={styles.Image} source={{ uri: this.props.itemObject.URLLarge }} />

          <View style={styles.TextContainer}>
          <Text style={styles.Text}>{this.props.itemObject.text}</Text>
          </View>

          <TouchableOpacity
          onPress={() => {

          }}
          >
          <View style={styles.LikeButton} />

          </TouchableOpacity>

         </View>
      </TouchableOpacity>

    );
  }
}

const styles = StyleSheet.create({
  Container: {
    backgroundColor: 'white',
    height: screenHeight,
    width: screenWidth,
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  Image: {
    width: screenWidth - 20,
    height: screenWidth - 20,
    backgroundColor: 'snow',
    alignItems: 'center',
    justifyContent: 'center'
  },
  TextContainer: {
    width: screenWidth - 20,
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',

  },
  Text: {
    color: 'black',
  },
  NameTextContainer: {
    width: screenWidth - 20,
    height: 50,
    alignItems: 'flex-end',
    justifyContent: 'center',
  },
  NameText: {
    color: 'black',
  },
  LikeButton: {
    height: 50,
    width: 50,
    backgroundColor: 'white'
  },

});


module.exports = LargeImageView;
