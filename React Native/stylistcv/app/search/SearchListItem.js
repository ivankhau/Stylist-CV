import React, { Component } from 'react';
import ReactNative from 'react-native';

import StarRating from 'react-native-star-rating';


const { View, TouchableHighlight, TouchableOpacity, Text, StyleSheet, Image, Dimensions } = ReactNative;

const screenWidth = Dimensions.get('window').width;

class SearchListItem extends Component {

  render() {
    return (
      <TouchableOpacity onPress={this.props.onPress}>
        <View style={styles.li}>
          <Image style={styles.profileImage} source={{ uri: this.props.item[1].iu }} />

          <View style={styles.textContainer}>

            <View style={styles.topTextContainer}>

              <View style={styles.topTextContainerLeft}>
              <Text style={styles.liTextLarge}>{this.props.item[1].fn} {this.props.item[1].ln}</Text>

              <View style={styles.reviewbox}>
              <StarRating
              style={styles.starBox}
              disabled={true}
              maxStars={5}
              rating={(this.props.item[1].rc === 0) ? 0 : (this.props.item[1].rs / this.props.item[1].rc)}
              selectedStar={(rating) => this.onStarRatingPress(rating)}
              emptyStar={'star-o'}
              fullStar={'star'}
              halfStar={'star-half-o'}
              iconSet={'FontAwesome'}
              starColor={'rgba(0,0,128,1)'}
              emptyStarColor={'black'}
              starSize={15}

              />
              </View>

              <Text style={styles.liTextSmall}>
              {this.props.item[1].rc} reviews, {this.props.item[1].po ? this.props.item[1].po : 0} Photos
              </Text>
              </View>

              <View style={styles.topTextContainerRight}>
              <Text style={styles.liTextSide}>6.0 mi</Text>
              <Text style={styles.liTextSide}>{this.props.item[1].pr}</Text>
              </View>

            </View>

            <Text style={styles.liText}>{this.props.item[1].wn}</Text>
            <Text style={styles.liText}>{this.props.item[1].ao}</Text>
            <Text style={styles.liText}>{this.props.item[1].at}</Text>
          </View>

          <View style={styles.sideImageContainer}>
          <Image style={styles.sideImage} source={{ uri: this.props.item[1].iuo }} />
          <Image style={styles.sideImage} source={{ uri: this.props.item[1].iut }} />
          </View>
        </View>
      </TouchableOpacity>
    );
  }

}

const styles = StyleSheet.create({
  topTextContainer: {
    height: 50,
    width: screenWidth - 122 - 61,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'white',
  },

  topTextContainerLeft: {
    width: screenWidth - 122 - 61 - 40,
    height: 50,
    backgroundColor: 'white',
    paddingLeft: 6,
  },

  topTextContainerRight: {
    width: 40,
    height: 50,
    backgroundColor: 'white',
    alignItems: 'flex-end',
    paddingRight: 3
  },


  reviewbox: {
    width: 30,
    height: 15,
  },
  starBox: {
    width: 30,
    height: 15,
  },


  li: {
    flexDirection: 'row',
    height: 125,
    backgroundColor: 'gainsboro',
    borderBottomColor: '#eee',
    borderColor: 'transparent',
    borderWidth: 0,
    paddingLeft: 0,
    paddingTop: 0,
    paddingBottom: 3,
  },
  liTextSide: {
    color: '#333',
    fontSize: 10,
    //fontFamily: 'avenirnextregular',
  },
  liTextLarge: {
    color: '#333',
    fontSize: 14,
    paddingRight: 1,
    paddingTop: 1,
    paddingBottom: 1,
    width: screenWidth - 122 - 61 - 39,
    //fontFamily: 'avenirnextdemi',

  },
  liText: {
    color: '#333',
    fontSize: 11,
    paddingLeft: 6,
    paddingRight: 1,
    paddingTop: 1,
    paddingBottom: 1,
    //fontFamily: 'avenirnextregular',
  },
  liTextSmall: {
    color: '#333',
    fontSize: 9,
    paddingRight: 1,
    paddingTop: 1,
    paddingBottom: 1,
    //fontFamily: 'avenirnextdemi',
  },
  textContainer: {
    height: 122,
    width: screenWidth - 122 - 61,
    backgroundColor: 'white',
    justifyContent: 'center',
  },
  sideImageContainer: {
    height: 122,
    width: 61,
    backgroundColor: 'aliceblue',
  },
  profileImage: {
    height: 122,
    width: 122,
    backgroundColor: 'aliceblue',
  },
  sideImage: {
    height: 61,
    width: 61,
  },
});

module.exports = SearchListItem;
