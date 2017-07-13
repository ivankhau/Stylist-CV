import React, { Component } from 'react';
import ReactNative from 'react-native';

const { View, TouchableHighlight, Image, Dimensions } = ReactNative;

const screenWidth = Dimensions.get('window').width;

class ActivityListItem extends Component {

  render() {
    const { thumb, row } = styles;

    return (
      <TouchableHighlight
      style={row}
      underlayColor='rgba(0,0,0,0)'
      onPress={this.props.onPress}
      >
        <View>
          <View>
            <Image style={thumb} source={{ uri: this.props.item.URLSmall }} />

          </View>
        </View>
      </TouchableHighlight>
    );
  }
}

const styles = {
  row: {
    justifyContent: 'center',
    padding: 0,
    margin: 0,
    width: (screenWidth / 3),
    height: (screenWidth / 3) + 1,
    backgroundColor: '#F6F6F6',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: 'white'
  },
  thumb: {

    width: (screenWidth / 3),
    height: (screenWidth / 3)
  },
};

module.exports = ActivityListItem;
