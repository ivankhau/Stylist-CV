import {
  SEARCH_LOCATION_RETRIEVE_SUCCESS,
  //SEARCH_USER_RETRIEVE_SUCCESS,
  //SEARCH_PROFILE_RETRIEVE_SUCCESS
} from '../actions/types';

const INITIAL_STATE = {
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case SEARCH_LOCATION_RETRIEVE_SUCCESS:
      return action.payload;
    /*case SEARCH_USER_RETRIEVE_SUCCESS:
      return action.payload;
    case SEARCH_PROFILE_RETRIEVE_SUCCESS:
      return action.payload;*/
    default:
      return state;
  }
};
