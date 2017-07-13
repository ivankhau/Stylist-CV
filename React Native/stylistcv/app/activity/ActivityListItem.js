import React, {Component} from 'react';
import ReactNative from 'react-native';

const { View, TouchableHighlight, Text, StyleSheet, Image, Dimensions } = ReactNative;

const screenWidth = Dimensions.get('window').width;

class ActivityListItem extends Component {

  render() {
    return (
      <TouchableHighlight style={styles.row} underlayColor='rgba(0,0,0,0)' onPress={this.props.onPress}>
        <View>
          <View>
            <Image style={styles.thumb} source={{uri: this.props.item.URLSmall}} />

          </View>
        </View>
      </TouchableHighlight>
    );
  }
}

const styles = StyleSheet.create({
  list: {
    paddingTop: 50,
    paddingBottom: 50,
    justifyContent: 'center',
    flexDirection: 'row',
    flexWrap: 'wrap'
  },
  row: {
    justifyContent: 'center',
    padding: 0,
    margin: 0,
    width: screenWidth/3,
    height: screenWidth/3 + 1,
    backgroundColor: '#F6F6F6',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: 'white'
  },
  thumb: {

    width: screenWidth/3,
    height: screenWidth/3
  },
  text: {
    flex: 1,
    marginTop: 5,
    fontWeight: 'bold'
  },
});

module.exports = ActivityListItem;
