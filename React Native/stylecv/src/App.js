import React, { Component } from 'react';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import firebase from 'firebase';
import ReduxThunk from 'redux-thunk';
import reducers from './reducers';
import Router from './Router';

class App extends Component {
  componentWillMount() {
    const config = {
      apiKey: 'AIzaSyDZrf_Arq7G69XITSYoZGyFhZZ9IlWdp-w',
      authDomain: 'hair-cv.firebaseapp.com',
      databaseURL: 'https://hair-cv.firebaseio.com',
      storageBucket: 'hair-cv.appspot.com',
      messagingSenderId: '776904779854'
    };

    firebase.initializeApp(config);
  }

  render() {
    const store = createStore(reducers, {}, applyMiddleware(ReduxThunk));

    return (
      <Provider store={store}>
        <Router />
      </Provider>
    );
  }
}

export default App;
