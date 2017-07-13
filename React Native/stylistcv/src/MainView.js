
import { StyleSheet } from 'react-native';
import React, { Component } from 'react';
import { Scene, Router } from 'react-native-router-flux';
//, TabBar, Modal, Schema, Actions, Reducer, ActionConst, TouchableHighlight

import Icon from 'react-native-vector-icons/Ionicons';


import ActivityView from './activity/ActivityView';
import MessagesView from './messages/MessagesView';
import ProfileView from './profile/ProfileView';
import StylistProfileView from './components/StylistProfileView';
import TabIcon from './components/TabIcon';

const LargeImageView = require('./components/LargeImageView');
const SearchView = require('./search/SearchView');


const SettingsIcon = () => (<Icon name="md-pulse" size={30} />);

class MainView extends Component {

  state = {

  }

  render() {
    return (
      <Router sceneStyle={{ backgroundColor: 'snow' }}>
      <Scene key="tabbar" tabs >

          <Scene
          key="searchViewRoot"
          icon={TabIcon}
          initial
          title="SEARCH"
          iconTitle="md-search"
          navigationBarStyle={{ backgroundColor: 'snow' }}
          titleStyle={styles.navBarTitle}
          >
              <Scene
              key="searchView"
              component={SearchView}
              title="Seach"
              //onRight={() => alert('Right button')}
              //rightTitle="poo"
              renderRightButton={SettingsIcon}
              />
              <Scene
              key="stylistProfileView"
              component={StylistProfileView}
              title=""
              />
          </Scene>

          <Scene
          key="activityViewRoot"
          icon={TabIcon} iconTitle="md-pulse"
          title="ACTIVITY"
          titleStyle={styles.navBarTitle}
          >
              <Scene
              key="activityView"
              component={ActivityView}
              title="Activity"
              //onLeft={() => alert('Left button!')}
              //leftTitle="Left"
              />
              <Scene
              key="largeImageView"
              component={LargeImageView}
              hideTabBar
              hideNavBar
              direction={'vertical'}
              />
          </Scene>


          <Scene
          key="messagesView"
          icon={TabIcon}
          component={MessagesView}
          iconTitle="md-chatbubbles"
          title="MESSAGES"
          hideTabBar={false}
          titleStyle={styles.navBarTitle}
          />


          <Scene
          key="profileView"
          icon={TabIcon}
          component={ProfileView}
          iconTitle="md-person"
          title="PROFILE"
          hideNavBar={false}
          titleStyle={styles.navBarTitle}
          />

      </Scene>
      </Router>
    );
  }

}

const styles = StyleSheet.create({
  navBarTitle: {
      color: '#000000',
      //fontFamily: 'georgiaitalic',
  },
});

export default MainView;
