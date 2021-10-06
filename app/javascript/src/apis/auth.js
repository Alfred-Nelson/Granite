import axios from "axios";

const logout = () => axios.delete(`/sessions`);

const signup = payload => axios.post("/users", payload);

const login = payload => axios.post("/sessions", payload);

const authApi = {
  signup,
  login,
  logout
};

export default authApi;
