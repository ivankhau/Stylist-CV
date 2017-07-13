import React from 'react';
import { Scene, Router, Actions } from 'react-native-router-flux';
import SearchMain from './components/search/SearchMain';
import TabIcon from './components/common/TabIcon';

const RouterComponent = () => {
  return (
    <Router sceneStyle={{ backgroundColor: 'snow' }}>
      <Scene key="tabbar" tabs={Boolean(true)} >

          <Scene
          key="searchViewRoot"
          icon={TabIcon}
          initial={Boolean(true)}
          title="SEARCH"
          iconTitle="md-search"
          navigationBarStyle={{ backgroundColor: 'snow' }}
          titleStyle={styles.navBarTitle}
          >
              <Scene
              key="searchMain"
              component={SearchMain}
              title="Seach"
              //onRight={() => alert('Right button')}
              //rightTitle="poo"
              //renderRightButton={SettingsIcon}
              />
              {/*<Scene
              key="stylistProfileView"
              component={StylistProfileView}
              title=""
              />*/}
          </Scene>

          {/*<Scene
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
              hideTabBar={Boolean(true)}
              hideNavBar={Boolean(true)}
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
          />*/}

      </Scene>
      </Router>
  );
};

const styles = {
  navBarTitle: {
      color: '#000000',
      //fontFamily: 'georgiaitalic',
  },
};

export default RouterComponent;
