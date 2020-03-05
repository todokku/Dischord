import { RECEIVE_CURRENT_USER, LOGOUT_CURRENT_USER } from '../actions/session_actions';

export default (state = {}, action) => {
  Object.freeze(state);
  switch (action.type) {
    case RECEIVE_CURRENT_USER:
      let nextState = Object.assign({}, state);
      nextState[action.currentUser.id] = action.currentUser;
      return nextState;
    case LOGOUT_CURRENT_USER:
      return {}
    default:
      return state;
  }
}