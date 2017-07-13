
import React, {
  PropTypes
} from 'react';
import {
  Text,
  View,
  StyleSheet,
} from 'react-native';
import Icon from 'react-native-vector-icons/Ionicons';

const propTypes = {
  selected: PropTypes.bool,
  title: PropTypes.string,
};

const TabIcon = (props) => (
  <View alignItems={'center'} justifyContent={'center'} >
  <Icon
    name={props.iconTitle}
    size={30}

    style={{ color: props.selected ? 'black' : 'rgba(0,0,0,0.2)' }}
  />
  <Text
    style={[{ color: props.selected ? 'black' : 'rgba(0,0,0,0.2)' }, styles.icontext]}
  >
    {props.title}
  </Text>
  </View>
);

const styles = StyleSheet.create({
  container: {
    marginTop: 50,
    marginBottom: 50,
    backgroundColor: 'white',
    flex: 1,
  },
  icontext: {
    //fontFamily: 'avenirnextregular',
    fontSize: 10
  },
});

TabIcon.propTypes = propTypes;

export default TabIcon;
