import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:4000/api/',
  headers: {
    'Content-Type': 'application/json'
  },
})

export default {

  // Users
  listUsers(params = {}) {
    return apiClient.get('users', { params })
  },
  createUser(userData) {
    return apiClient.post('users', userData)
  },
  updateUser(id, userData) {
    return apiClient.put(`users/${id}`, userData)
  },
  deleteUser(id) {
    return apiClient.delete(`users/${id}`)
  },

  // WorkingTimes
  getClocks(userId) {
    return apiClient.get(`clocks/${userId}`)
  },
  postClock(userId, time, status) {
    return apiClient.post(`clocks/${userId}`, {
      time: time,
      status: status.toString()
    });
  }

}