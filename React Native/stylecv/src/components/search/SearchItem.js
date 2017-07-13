import React, { Component } from 'react';
import ReactNative from 'react-native';
import StarRating from 'react-native-star-rating';

const { View, TouchableOpacity, Text, Image, Dimensions } = ReactNative;

const { width } = Dimensions.get('window');

class SearchItem extends Component {

  render() {
    const { item } = this.props;
    const { li, profileImage, textContainer, topTextContainer, topTextContainerLeft,
    liTextLarge, reviewbox, starBox, liTextSmall, liTextSide, liText, sideImage,
    sideImageContainer, topTextContainerRight } = styles;

    return (
      <TouchableOpacity onPress={this.props.onPress}>
        <View style={li}>
          <Image style={profileImage} source={{ uri: item[1].iu }} />

          <View style={textContainer}>

            <View style={topTextContainer}>

              <View style={topTextContainerLeft}>
              <Text style={liTextLarge}>{item[1].fn} {item[1].ln}</Text>

              <View style={reviewbox}>
              <StarRating
              style={starBox}
              disabled={Boolean(true)}
              maxStars={5}
              rating={(item[1].rc === 0) ? 0 : (item[1].rs / item[1].rc)}
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

              <Text style={liTextSmall}>
              {item[1].rc} reviews, {item[1].po ? item[1].po : 0} Photos
              </Text>
              </View>

              <View style={topTextContainerRight}>
              <Text style={liTextSide}>6.0 mi</Text>
              <Text style={liTextSide}>{item[1].pr}</Text>
              </View>

            </View>

            <Text style={liText}>{item[1].wn}</Text>
            <Text style={liText}>{item[1].ao}</Text>
            <Text style={liText}>{item[1].at}</Text>
          </View>

          <View style={sideImageContainer}>
          <Image style={sideImage} source={{ uri: item[1].iuo }} />
          <Image style={sideImage} source={{ uri: item[1].iut }} />
          </View>
        </View>
      </TouchableOpacity>
    );
  }
}

  const styles = {
    topTextContainer: {
      height: 50,
      width: width - 122 - 61,
      flexDirection: 'row',
      alignItems: 'center',
      backgroundColor: 'white',
    },

    topTextContainerLeft: {
      width: width - 122 - 61 - 40,
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
      width: width - 122 - 61 - 39,
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
      width: width - 122 - 61,
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
  };
export default SearchItem;
