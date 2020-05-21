import { Creators as KalevalaCreators } from "../kalevala";

export const Types = {
  LOGIN_ACTIVE: "LOGIN_ACTIVE",
  LOGGED_IN: "LOGGED_IN",
};

export const Creators = {
  login: (username, password) => {
    return (dispatch) => {
      const event = {
        topic: "Login",
        data: { username, password }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  loginActive: () => {
    return { type: Types.LOGIN_ACTIVE };
  },
  loggedIn: () => {
    return { type: Types.LOGGED_IN };
  },
  moveNorth: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "north" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  moveSouth: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "south" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  moveWest: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "west" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  moveEast: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "east" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  moveUp: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "up" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  moveDown: () => {
    return (dispatch) => {
      const event = {
        topic: "system/send",
        data: { text: "down" }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
  selectCharacter: (character) => {
    return (dispatch) => {
      const event = {
        topic: "Login.Character",
        data: { character }
      };

      dispatch(KalevalaCreators.socketSendEvent(event));
    };
  },
};
