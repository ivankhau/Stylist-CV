'use strict'

import React, {Component} from 'react';
import { View, Text, Image, StyleSheet, Dimensions, ScrollView } from 'react-native';

import Button from 'apsl-react-native-button';
import SegmentTab from 'react-native-segment-tab';

const screenWidth = Dimensions.get('window').width;

class SearchSettingsView extends Component {

  state = {
    distanceSelected:2,
    locationSelected:0,
  }


  render() {
    return (
      <View style={styles.container}>

        <View style={styles.containerBox} height={90}>
            <View height={8} />
            <View width={screenWidth - 30}><Text>Distance:</Text></View>
            <View height={8} />
            <SegmentTab
            data={['10', '15', '25', '50']}
            selected={this.state.distanceSelected}
            onPress={ index => this.setState({distanceSelected: index})}
            activeColor={'black'}
            horizontalWidth={screenWidth - 30}
            />
            <View height={8} />
        </View>

        <View style={styles.containerBox} height={90}>
            <View height={8} />
            <View width={screenWidth - 30}><Text>Location:</Text></View>
            <View height={8} />
            <SegmentTab
            data={['Current', 'Custom']}
            selected={this.state.locationSelected}
            onPress={ index => [this.setState({locationSelected: index}), (index == 1)? console.log('is 1'):console.log('not 1')]}
            activeColor={'black'}
            horizontalWidth={screenWidth - 30}
            />
            <View height={8} />
        </View>


        <Button activeOpacity={0.5} style={{backgroundColor: 'blue', borderWidth: 0, borderRadius: 0}} textStyle={{fontSize: 14, color: 'white', //fontFamily: 'avenirnextdemi'}} onPress={this.buttomTapped}>
          Save
        </Button>
      </View>
    )
  }

  buttonTapped() {

  }

};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    //justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(227,228,232,1)',
    padding: 10,
  },

  containerBox: {
    width: screenWidth - 10,
    borderWidth: 1,
    borderColor: 'rgba(217,217,219,1)',
    backgroundColor: 'white',
    marginBottom: 8,
    alignItems: 'center'
  },
  toplogotext: {
    //fontFamily: 'avenirnextregular',
    fontSize: 24,
  },
  bottomlogotext: {
    //fontFamily: 'georgiaitalic',
    fontSize:24,
  },
  messagetext: {
    //fontFamily: 'avenirnextregular',
    fontSize: 14,

  },



});

module.exports = SearchSettingsView;
