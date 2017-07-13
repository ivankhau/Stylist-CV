import firebase from 'firebase';
import { Actions } from 'react-native-router-flux';
import {
  SEARCH_LOCATION_RETRIEVE_SUCCESS,
  //SEARCH_USER_RETRIEVE_SUCCESS,
  //SEARCH_PROFILE_RETRIEVE_SUCCESS
} from './types';

export const employeesFetch = () => {
  const { currentUser } = firebase.auth();

  return (dispatch) => {
    firebase.database().ref(`/users/${currentUser.uid}/employees`)
      .on('value', snapshot => {
        dispatch({ type: EMPLOYEES_FETCH_SUCCESS, payload: snapshot.val() });
      });
  };
};

export const locationFetch = () => {
  return (dispatch) => {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const initialPosition = JSON.stringify(position);
        //this.setState({initialPosition});
        console.log([position.coords.latitude, position.coords.longitude]);
        //console.log(position.coords);

        //this.queryItems(position.coords.latitude, position.coords.longitude)
          dispatch({
            type: SEARCH_LOCATION_RETRIEVE_SUCCESS,
            payload: [position.coords.latitude, position.coords.longitude]
          });
      },
      (error) => alert(error),
      { enableHighAccuracy: true, timeout: 20000, maximumAge: 1000 }
    );
  };
};
