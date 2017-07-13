'use strict';


import React, { Component } from 'react';

// ListView, TouchableHighlight, Text
import { View, StyleSheet, } from 'react-native';


const { GooglePlacesAutocomplete } = require('react-native-google-places-autocomplete');

class LocationPickerView extends Component {
  render() {
    return (
      <View
      style={styles.searchContainer}
      >
      <GooglePlacesAutocomplete
        placeholder='Search for a location'
        minLength={2} // minimum length of text to search
        autoFocus={false}
        fetchDetails={true}
        onPress={(data, details = null) => { // 'details' is provided when fetchDetails = true
          console.log(data);
          console.log(details.geometry.location);
        }}
        getDefaultValue={() => {
          return ''; // text input default value
        }}
        query={{
          // available options: https://developers.google.com/places/web-service/autocomplete
          key: 'AIzaSyCFmobCbdqqxhv2MCuwyJLBxIKma8fcarg',
          language: 'en', // language of the results
          types: 'address', // default: 'geocode'
        }}
        styles={{
          description: {
            fontWeight: 'bold',
          },
          predefinedPlacesDescription: {
            color: '#1faadb',
          },
        }}
        // Will add a 'Current location' button at the top of the predefined places list
        currentLocation={false}
        currentLocationLabel="Current location"
        // Which API to use: GoogleReverseGeocoding or GooglePlacesSearch
        nearbyPlacesAPI='GooglePlacesSearch'
        GoogleReverseGeocodingQuery={{
          // available options for GoogleReverseGeocoding API : https://developers.google.com/maps/documentation/geocoding/intro
        }}
        GooglePlacesSearchQuery={{
          // available options for GooglePlacesSearch API : https://developers.google.com/places/web-service/search
          rankby: 'distance',
          types: 'food',
        }}

        // filter the reverse geocoding results by types - ['locality',
        // 'administrative_area_level_3'] if you want to display only cities
        filterReverseGeocodingByTypes={['locality', 'administrative_area_level_3']}

        //predefinedPlaces={[homePlace, workPlace]}

        predefinedPlacesAlwaysVisible={false}
      />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  searchContainer: {
    //marginTop: 8,
    //paddingLeft: 8,
    //paddingRight: 8,
    //marginBottom:8,


  },

});

module.exports = LocationPickerView;
